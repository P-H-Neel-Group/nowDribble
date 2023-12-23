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
                    .preferredColorScheme(.light)
            } else {
                LoginView()
            }
        }
    }
}

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = true // TODO: Set to true for debug

    init() {
        checkAuthentication()
    }

    func checkAuthentication() {
        // Check if the user is authenticated
        // Update isAuthenticated based on the result
        // For example, check for a valid token or user credentials
    }
}
