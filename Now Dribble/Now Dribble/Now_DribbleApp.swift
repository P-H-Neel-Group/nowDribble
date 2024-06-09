//
//  Now_DribbleApp.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

// prod url "https://nowdribbleapp.com"
let IP_ADDRESS: String = "https://dev.nowdribbleapp.com"

@main
struct Now_DribbleApp: App {
    @StateObject private var subscriptionManager = SubscriptionManager()
    @StateObject private var authViewModel = AuthenticationViewModel()

    @Environment(\.scenePhase) var scenePhase

    init() {
        if IP_ADDRESS.contains("dev") {
            print("----------------------")
            print("WARNING: ON DEV SERVER")
            print("----------------------")
        }
    }

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                ContentView()
                    .environmentObject(authViewModel)
                    .environmentObject(subscriptionManager)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    if UIDevice.current.userInterfaceIdiom == .pad {
                                        adjustFrameForiPad(geometry: geometry)
                                    }
                                }
                        }
                    )
            } else {
                LoginView()
                    .preferredColorScheme(.light)
                    .environmentObject(authViewModel)
                    .environmentObject(subscriptionManager)
            }
        }
    }

    private func adjustFrameForiPad(geometry: GeometryProxy) {
        let iPhoneFrame = CGRect(x: 0, y: 0, width: 375, height: 812) // iPhone X dimensions
        let scale = min(geometry.size.width / iPhoneFrame.width, geometry.size.height / iPhoneFrame.height)
        let xOffset = (geometry.size.width - (iPhoneFrame.width * scale)) / 2
        let yOffset = (geometry.size.height - (iPhoneFrame.height * scale)) / 2
        let frame = CGRect(x: xOffset, y: yOffset, width: iPhoneFrame.width * scale, height: iPhoneFrame.height * scale)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.frame = frame
        }
    }
}

class AuthenticationViewModel: ObservableObject {
    @MainActor @Published var isAuthenticated = false

    init() {
        validateToken()
    }

    func validateToken() {
        DispatchQueue.global(qos: .background).async {
            if let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
               let token = String(data: tokenData, encoding: .utf8), !token.isEmpty {
                print("Found an existing token")
                let receipt = self.getReceiptFromKeychain() ?? ""
                if (receipt.count > 0 ) { print("Retrieved a receipt")}
                DispatchQueue.main.async { [weak self] in
                    self?.refreshToken(token: token, receipt: receipt)
                }
            } else {
                print("No valid token found")
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    print("Authentication status updated to false, directing to LoginView.")
                }
            }
        }
    }

    func signOut() {
        KeychainHelper.standard.delete(service: "com.phneelgroup.Now-Dribble", account: "userToken")
        DispatchQueue.main.async {
            self.isAuthenticated = false
            print("Signed out, directing to LoginView.")
        }
    }

    func refreshToken(token: String, receipt: String) {
        guard let url = URL(string: "\(IP_ADDRESS)/Authentication/RefreshToken") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body: [String: Any] = ["receipt": receipt]
        if let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) {
            request.httpBody = jsonData
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error during URLSession data task: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let newToken = json["token"] as? String {
                        // Save new token
                        if let tokenData = newToken.data(using: .utf8) {
                            KeychainHelper.standard.save(tokenData, service: "com.phneelgroup.Now-Dribble", account: "userToken")
                            DispatchQueue.main.async {
                                self.isAuthenticated = true
                            }
                        }
                    }
                } catch {
                    print("JSON decoding error: \(error)")
                }
            } else {
                self.signOut()
            }
        }
        task.resume()
    }

    private func getReceiptFromKeychain() -> String? {
        guard let receiptData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "receipt") else {
            return nil
        }
        return String(data: receiptData, encoding: .utf8)
    }
}

func saveUseColorPreference(useColor: Bool) {
    UserDefaults.standard.set(useColor, forKey: "UseColor")
}

func getUseColorPreference() -> Bool {
    UserDefaults.standard.bool(forKey: "UseColor")
}

func bcolor(cc: String, backup: String) -> some View {
    let useColor = getUseColorPreference()
    @Environment(\.colorScheme) var colorScheme

    return Group {
        if useColor {
            switch cc {
            case "primary":
                Color("PrimaryBlueColor")
            case "secondary":
                Color("SecondaryBlueColor")
            default:
                Color.clear
            }
        } else {
            switch backup {
            case "env":
                Color.clear
            case "none":
                Color.clear
            case "black":
                Color.black
            case "white":
                Color.white
            case "envopp":
                colorScheme == .dark ? Color.white : Color.black
            default:
                Color.clear
            }
        }
    }
}
