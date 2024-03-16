//
//  Now_DribbleApp.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

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
            // Perform the authentication check here

            
            // Once done, update the UI on the main thread
            DispatchQueue.main.async {
                self.isAuthenticated = true // Update based on actual check
            }
        }
    }
}
