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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            if (showImage) {
                Image("Logo2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showImage = false
                                showButton = true
                            }
                        }
                    }
            } // Endif showImage
            
            if(showButton) {
                ZStack(alignment: .topLeading) {
                    Image("LoginSwirl")
                        .resizable()
                        .scaledToFit() // Ensure the image fills the screen
                        .edgesIgnoringSafeArea(.all) // Make the image extend to the edges of the screen
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image("Logo4")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 2)
                            
                            Text("NowDribble")
                                .foregroundColor(Color(.white))
                                .font(.system(size: 28, weight: .bold))
                        }
                        .padding(.bottom, 2)
                        
                        Text("Become an unstoppable ball handler with game-proven basketball drills created by Coach Antonio Cook.")
                            .foregroundColor(.white.opacity(0.85))
                        Spacer() // Spacer to push content up
                        
                        VStack {
                            ZStack {
                                // Custom background with rounded corners
                                RoundedRectangle(cornerRadius: 30) // Fully rounded
                                    .fill(Color(.black)) // Use your custom color
                                    .frame(maxWidth: .infinity, maxHeight: 45)
                                
                                // Sign in with Apple button
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
                                            if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                                                if let authCodeData = appleIDCredential.authorizationCode,
                                                   let authCode = String(data: authCodeData, encoding: .utf8),
                                                   let idTokenData = appleIDCredential.identityToken,
                                                   let idToken = String(data: idTokenData, encoding: .utf8) {
                                                    postLoginWithApple(authorizationCode: authCode, idToken: idToken, avm: authViewModel)
                                                }
                                            } else {
                                                print("\n!!!Credential is not of type ASAuthorizationAppleIDCredential!!!")
                                            }
                                        case .failure(let error):
                                            print("\nAuthorization failed: \(error)")
                                        }
                                    }
                                )
                                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                                .frame(maxWidth: .infinity, maxHeight: 45)
                                .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(34) // Add padding if you want space from the edges
                }
            }
        }
    }
}

func postLoginWithApple(authorizationCode: String, idToken: String, avm: AuthenticationViewModel) {
    guard let url = URL(string: "\(IP_ADDRESS)/Authentication/LogInWithApple") else {
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
        // TODO: add name fields
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
