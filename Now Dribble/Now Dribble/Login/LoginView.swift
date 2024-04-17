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
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showButton = false
    @State private var showImage = true

    var body: some View {
        VStack {
            if (showImage) {
                Image("Logo1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
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
                                }  else {
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
                                
                                // MAKE POST REQUEST TO /Authentication/LogInWithApple
                                // Extract the authorization code and ID token
                                if let authCodeData = appleIDCredential.authorizationCode,
                                   let authCode = String(data: authCodeData, encoding: .utf8),
                                   let idTokenData = appleIDCredential.identityToken,
                                   let idToken = String(data: idTokenData, encoding: .utf8) {
                                   
                                    // Now call the function to make the POST request
                                    postLoginWithApple(authorizationCode: authCode, idToken: idToken, avm: authViewModel)
                                }
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

func postLoginWithApple(authorizationCode: String, idToken: String, avm: AuthenticationViewModel) {
    guard let url = URL(string: "http://\(IP_ADDRESS)/Authentication/LogInWithApple") else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    let body: [String: Any] = [
        "authorization_code": authorizationCode,
        "id_token": idToken
    ]

    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: \(error?.localizedDescription ?? "No data")")
            return
        }

        do {
            if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Handle the server response here
                print(responseJSON)
                if let tokenString = responseJSON["token"] as? String,
                   let tokenData = tokenString.data(using: .utf8) {
                    // Save token to Keychain
                    KeychainHelper.standard.save(tokenData, service: "com.phneelgroup.Now-Dribble", account: "userToken")
                    print("Token saved to Keychain")
                    DispatchQueue.main.async {
                        avm.validateToken()
                    }
                } else {
                    print("Token not found in the response")
                }
            }
        } catch let jsonError {
            print("Failed to decode JSON: \(jsonError.localizedDescription)")
        }
    }

    task.resume()
}
