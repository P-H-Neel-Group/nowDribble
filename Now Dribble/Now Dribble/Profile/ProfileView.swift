//
//  ProfileView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 1/11/24.
//

import SwiftUI


func saveUserName(name: String) {
    var val_name: String = name
    
    if (val_name.count <= 2) {
        val_name = "User"
    }
    UserDefaults.standard.set(val_name, forKey: "UserName")
}

func getUserName() -> String? {
    return UserDefaults.standard.string(forKey: "UserName")
}

struct ProfileView: View {
    @State private var userName: String = ""
    @State private var profileImage: Image = Image(systemName: "person.crop.circle")
    @EnvironmentObject var authViewModel: AuthenticationViewModel // for signing out
    @State private var useColor: Bool = getUseColorPreference()
    
    func loadUserName() {
        userName = getUserName() ?? "User"
    }

    private func updateProfileImage() {
        if let loadedUIImage = loadImage(imageName: "userProfile.jpg") {
            self.profileImage = Image(uiImage: loadedUIImage)
        } else {
            self.profileImage = Image(systemName: "person.crop.circle")
        }
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("Profile")
                    .font(.system(.title, design: .rounded))
                    .bold()
                
                Spacer()

            }
            .background(bcolor(cc: "primary", backup: "env"))
            .padding()
            
            Divider()
            
            NavigationLink(destination: ProfileEditorView()) {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
            }

            Text(userName)

            Spacer()
            HStack {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//                        Spacer()
//                        Text("List of friends")
//                    }
//                }
            }

            Spacer()
            
//            Toggle("Use Color", isOn: $useColor)
//                .onChange(of: useColor) { newValue in
//                    saveUseColorPreference(useColor: newValue)
//                }
//                .padding()
            
            Button("Sign Out") {
                authViewModel.signOut()
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .cornerRadius(10)
            .padding()
        }
        .background(bcolor(cc: "primary", backup: "env"))
        .onAppear {
            loadUserName()
            updateProfileImage()
        }
    }
}
