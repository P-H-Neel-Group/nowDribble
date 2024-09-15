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
    
    @Environment(\.colorScheme) var colorScheme
    
    var oppositeColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
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
//            HStack {
//                NavigationLink(destination: ProfileEditorView()) {
//                    Image(systemName: "pencil.circle.fill")
//                        .imageScale(.large)
//                        .padding()
//                }
//
//                Spacer()
//
//                Text("Profile")
//                    .font(.system(.title, design: .rounded))
//                    .bold()
//
//                Spacer()
//
//                NavigationLink(destination: SettingsView()) {
//                    Image(systemName: "gear")
//                        .imageScale(.large)
//                        .padding()
//                }
//            }
//            .background(bcolor(cc: "primary", backup: "env"))
//            .padding()
            
            // Divider()
            
            profileImage
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()

            Text(userName).font(.system(size: 24, weight: .bold))
            Text("Your Profile").foregroundColor(oppositeColor.opacity(0.4)).padding(.bottom, 10)
                        
            HStack {
                // Edit Profile Button
                NavigationLink(destination: ProfileEditorView()) {
                    HStack {
                        Image(systemName: "pencil.circle")
                            .imageScale(.medium)
                            .foregroundColor(.white)
                            .padding(.trailing, 2)
                        
                        Text("Edit Profile")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .frame(width: 175)
                    .padding(.vertical, 10)
                    .background(Color("Primary"))
                    .cornerRadius(64)
                }
                
                // Settings Button
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Image(systemName: "gear")
                            .imageScale(.medium)
                            .foregroundColor(oppositeColor)
                            .padding(.trailing, 2)
                        
                        Text("Settings")
                            .foregroundColor(oppositeColor)
                            .font(.headline)
                    }
                    .frame(width: 175)
                    .padding(.vertical, 10)
                    .background(Color.clear) // Keep background clear to show border
                    .cornerRadius(64)
                    .overlay(
                        RoundedRectangle(cornerRadius: 64)
                            .stroke(oppositeColor.opacity(0.2), lineWidth: 2) // Apply the border with rounded corners
                    )
                }
            }

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
        .navigationTitle("Profile")
        .background(bcolor(cc: "primary", backup: "env"))
        .onAppear {
            loadUserName()
            updateProfileImage()
        }
    }
}
