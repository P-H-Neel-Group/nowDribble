//
//  Now_DribbleApp.swift
//  Displays and calls the signin with Apple button
//
//  Created by Isaiah Harville on 12/23/23.
//

import SwiftUI
import UIKit
import AuthenticationServices

struct LoginView: View {
    @State private var showButton = false
    @State private var showImage = true

    var body: some View {
        VStack {
            if (showImage) {
                Image(systemName: "basketball.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color("TabButtonColor")) // Apply accent color
                    .padding()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showImage = false
                                showButton = true
                            }
                        }
                    }
                Text("NOW DRIBBLE")
                    .font(.system(.title, design: .rounded))
            } // Endif showImage
            if (showButton) {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        // Configure the request for user information
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        // Handle the authentication result
                        switch result {
                        case .success(let auth):
                            // Successfully authenticated
                            if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                                #if DEBUG
                                // Check if full name and email are present
                                if let fullName = appleIDCredential.fullName {
                                    let givenName = fullName.givenName ?? "Unknown"
                                    let familyName = fullName.familyName ?? "Unknown"
                                    print("Full Name: \(givenName) \(familyName)")
                                } else {
                                    print("Full Name not provided")
                                }
                                
                                if let email = appleIDCredential.email {
                                    print("Email: \(email)")
                                } else {
                                    print("Email not provided")
                                }
                                
                                // Retrieve and print the authorization code
                                if let authCodeData = appleIDCredential.authorizationCode,
                                   let authCode = String(data: authCodeData, encoding: .utf8) {
                                    print("\nAuthorization Code: \(authCode)")
                                } else {
                                    print("\nAuthorization Code not available")
                                }
                                
                                // Retrieve and print the ID token
                                if let idTokenData = appleIDCredential.identityToken,
                                   let idToken = String(data: idTokenData, encoding: .utf8) {
                                    print("\nID Token: \(idToken)")
                                } else {
                                    print("\nID Token not available")
                                }
                                #endif
                            } else {
                                print("\n!!!Credential is not of type ASAuthorizationAppleIDCredential!!!")
                            }
                            
                        case .failure(let error):
                            // Authentication failed
                            print("\nAuthorization failed: \(error)")
                        }
                    }
                )
                .signInWithAppleButtonStyle(.black)
                .frame(width: 280, height: 60)
            } // Endif showButton
        }
    }
}

// Preview
/*
#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif*/
