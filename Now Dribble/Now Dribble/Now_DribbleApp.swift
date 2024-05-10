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
                print("Token retrieved and validated: \(token)")
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    print("Authentication status updated to true")
                }
            } else {
                print("No valid token found.")
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    print("Authentication status updated to false")
                }
            }
        }
    }

    
    func signOut() {
        KeychainHelper.standard.delete(service: "com.phneelgroup.Now-Dribble", account: "userToken")
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }
}

extension KeychainHelper {
    func delete(service: String, account: String) {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ] as [String: Any]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Error deleting keychain item: \(status)")
        } else {
            print("Keychain item deleted successfully")
        }
    }
}

func saveUseColorPreference(useColor: Bool) {
    UserDefaults.standard.set(false, forKey: "UseColor") // NOTE: HARDCODED TO FALSE FOR NOW
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
