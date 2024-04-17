//
//  Now_DribbleApp.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

let IP_ADDRESS: String = "18.224.94.30:5000"

@main
struct Now_DribbleApp: App {
    @StateObject var authViewModel = AuthenticationViewModel()

    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                ContentView()
                    .preferredColorScheme(.dark)
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
    @Published var isAuthenticated = false;
    
    init() {
        checkAuthentication()
    }
    
    func checkAuthentication() {
        DispatchQueue.global(qos: .background).async {
            var authenticated = false
            
            if let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
               let token = String(data: tokenData, encoding: .utf8) {
                print("Retrieved token: \(token)")
                authenticated = true
                // TODO: refresh token?
            }
            
            DispatchQueue.main.async {
                self.isAuthenticated = authenticated // Update the published property on the main thread
            }
        }
    }
    func signOut() {
        KeychainHelper.standard.delete(service: "com.phneelgroup.Now-Dribble", account: "userToken")

        // Update the authentication state
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }
}

extension KeychainHelper {
    func delete(service: String, account: String) {
        let query = [
            kSecClass as String: kSecClassGenericPassword, // Keychain item class
            kSecAttrService as String: service,            // Service name
            kSecAttrAccount as String: account             // Account name
        ] as [String: Any]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Error deleting keychain item: \(status)")
        } else {
            print("Keychain item deleted successfully")
        }
    }
}
