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
                NavigationLink(destination: ProfileEditorView()) {
                    Image(systemName: "pencil.circle.fill")
                        .imageScale(.large)
                        .padding()
                }
                
                Spacer()
                
                Text("Profile")
                    .font(.system(.title, design: .rounded))
                    .bold()
                
                Spacer()
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .padding()
                }
            }
            .background(bcolor(cc: "primary", backup: "env"))
            .padding()
            
            Divider()
            
            profileImage
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()

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
        }
        .accentColor(Color("TabButtonColor"))
        .background(bcolor(cc: "primary", backup: "env"))
        .onAppear {
            loadUserName()
            updateProfileImage()
        }
    }
}
