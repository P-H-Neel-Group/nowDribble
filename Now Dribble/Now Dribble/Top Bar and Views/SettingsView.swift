//
//  SettingsView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 5/20/24.
//

import SwiftUI

// Reusable SettingsButton Component
struct SettingsButton: View {
    let title: String
    let action: () -> Void
    let backgroundColor: Color
    let textColor: Color

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(textColor)
                    .padding(.vertical, 15)
                Spacer()
            }
            .padding(.horizontal)
            .background(backgroundColor)
        }
    }
}

// Main SettingsView with iOS Settings Style
struct SettingsView: View {
    @State private var useColor: Bool = getUseColorPreference()
    @EnvironmentObject var authViewModel: AuthenticationViewModel // for signing out
    @EnvironmentObject var subscriptionManager: SubscriptionManager // to access the shared subscription manager
    @State private var showRestartAlert = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var oppositeColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var body: some View {
        Form {
            Section(header: Text("Privacy and Legal")) {
                Button(action: {
                    if let url = URL(string: "https://phneelgroup.com/nowdribble/privacy-policy") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Privacy Policy").foregroundColor(oppositeColor)
                }
                
                Button(action: {
                    if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("EULA").foregroundColor(oppositeColor)
                }
            }
            
            Section(header: Text("Data")) {
                Button(action: {
                    if let url = URL(string: "https://phneelgroup.com/nowdribble/data-deletion") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Data Deletion").foregroundColor(oppositeColor)
                }
                
                Button(action: {
                    if let url = URL(string: "https://phneelgroup.com/nowdribble/data-request") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Data Request").foregroundColor(oppositeColor)
                }
                
                Button(action: {
                    subscriptionManager.refreshPurchases()
                }) {
                    Text("Refresh Subscription Purchases").foregroundColor(oppositeColor)
                }
            }
            
            Button(role: .destructive) {
                authViewModel.signOut()
            } label: {
                Text("Sign Out")
            }
        }.navigationTitle("Settings")
    }
}
