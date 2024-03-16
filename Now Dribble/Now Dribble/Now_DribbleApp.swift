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
    @StateObject private var authViewModel = AuthenticationViewModel()

    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                ContentView()
                    .preferredColorScheme(.dark)
            } else {
                LoginView()
                    .preferredColorScheme(.light)
            }
        }
    }
}

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    
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
}
