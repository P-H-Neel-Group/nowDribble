//
//  ProfileView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 1/11/24.
//

import SwiftUI


func saveUserName(name: String) {
    UserDefaults.standard.set(name, forKey: "UserName")
}

func getUserName() -> String? {
    return UserDefaults.standard.string(forKey: "UserName")
}


struct ProfileView: View {
    // Load the user's profile picture once when the view appears
    @State private var userName: String = ""
    @State private var profileImage: Image = Image(systemName: "person.crop.circle")

    func loadUserName() {
            userName = getUserName() ?? "Person"
    }

    private func updateProfileImage() {
        // Attempt to load the saved image
        if let loadedUIImage = loadImage(imageName: "userProfile.jpg") {
            // If an image is successfully loaded, update the profileImage to display it
            self.profileImage = Image(uiImage: loadedUIImage)
        } else {
            // If no image is found, use a default system image
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
                // Profile Edit button
                NavigationLink(destination: ProfileEditorView()) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 35))
                        .foregroundColor(Color("SecondaryBlueColor"))
                }
            }
            .background(Color("PrimaryBlueColor"))
            .padding()
            
            Divider()
                        
            // Display user's profile image
            profileImage
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()

            Text(userName)

            Spacer()
            // Show user's friends
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer()
                        Text("List of friends")
                    }
                }
            }

            Spacer()
        }
        .background(Color("PrimaryBlueColor"))
        .onAppear {
            updateProfileImage()
        }
    }
}

// Make sure `loadImage(imageName:)` is defined somewhere accessible to this view,
// returning an optional UIImage based on whether the image exists in your app's document directory.
