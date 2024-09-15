//
//  UI_TopBar.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 12/3/23.
//

import SwiftUI

struct UI_TopBar: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isSavedForLaterPresented = false

    var oppositeColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var nonSelectedTabColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    var body: some View {
        HStack(alignment: .center) {
            // Bookmark button (Left)
            Button(action: {
                // Action for saving for later
            }) {
                Image(systemName: "bookmark.circle")
                    .font(.system(size: 32))
                    .foregroundColor(nonSelectedTabColor)
            }
            
            Spacer()
            
            // Logo (Center)
            Image("Logo1")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 30)
            
            Spacer()
            
            // Profile button (Right)
            NavigationLink(destination: ProfileView()) {
                if let userImage = loadImage(imageName: "userProfile.jpg") {
                    Image(uiImage: userImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 0.5)
                                .foregroundColor(nonSelectedTabColor)
                        )
                } else {
                    Image(systemName: "person.circle")
                        .font(.system(size: 32))
                        .foregroundColor(nonSelectedTabColor)
                }
            }
        }
        .padding(.horizontal) // Add some horizontal padding to give the buttons space from the edges
        .padding(.vertical, 12)
    }
}
