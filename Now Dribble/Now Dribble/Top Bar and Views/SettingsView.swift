//
//  SettingsView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 5/20/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var useColor: Bool = getUseColorPreference()
    @EnvironmentObject var authViewModel: AuthenticationViewModel // for signing out
    @EnvironmentObject var subscriptionManager: SubscriptionManager // to access the shared subscription manager
   @State private var showRestartAlert = false

    var body: some View {
        VStack {
            Button(action: {
                if let url = URL(string: "https://phneelgroup.com/nowdribble/privacy-policy") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Privacy Policy")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.vertical, 10)

            Button(action: {
                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("EULA")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.vertical, 10)

            Button(action: {
                if let url = URL(string: "https://phneelgroup.com/nowdribble/data-request") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Data Request")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.vertical, 10)
            
            Button(action: {
                if let url = URL(string: "https://phneelgroup.com/nowdribble/data-deletion") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Data Deletion")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.vertical, 10)

            Button(action: {
                subscriptionManager.refreshPurchases()
            }) {
                Text("Refresh Subscription Purchases")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.vertical, 10)

            Spacer()
            
            Toggle("Use Color", isOn: $useColor)
                .onChange(of: useColor) { _, newValue in
                    saveUseColorPreference(useColor: newValue)
                    showRestartAlert = true
                }
                .padding()

            Button("Sign Out") {
                authViewModel.signOut()
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .cornerRadius(10)
            .padding(.vertical, 10)
        }
        .padding()
        .alert(isPresented: $showRestartAlert) {
            Alert(
                title: Text("Restart Required"),
                message: Text("The application needs to be restarted for the changes to take effect."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
