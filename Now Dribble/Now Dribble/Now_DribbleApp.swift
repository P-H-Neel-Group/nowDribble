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
    @StateObject var authViewModel = AuthenticationViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                ContentView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .preferredColorScheme(.light)
                    .environmentObject(authViewModel)
            }
        }
    }
}

class AuthenticationViewModel: ObservableObject {
    @MainActor @Published var isAuthenticated = false;
    
    init() {
        validateToken()
    }
    
    func validateToken() {
        DispatchQueue.global(qos: .background).async {
            if let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
               let token = String(data: tokenData, encoding: .utf8), !token.isEmpty {
                print("Found an existing token")
                DispatchQueue.main.async {
                    self.refreshToken(token: token)
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
    
    func refreshToken(token: String) {
        guard let url = URL(string: "\(IP_ADDRESS)/Authentication/RefreshToken") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body: [String: Any] = ["receipt": "string"] // TODO: add receipt
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
                #if DEBUG
                print("HTTP Response: \(response)")
                #endif
                self.signOut()
            }
        }
        task.resume()
    }
}

func saveUseColorPreference(useColor: Bool) {
    UserDefaults.standard.set(useColor, forKey: "UseColor") // NOTE: HARDCODED TO FALSE FOR NOW
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
