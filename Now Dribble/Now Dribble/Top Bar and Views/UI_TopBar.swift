//
//  UI_TopBar.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 12/3/23.
//

import SwiftUI

struct UI_TopBar: View {
    var body: some View {
        VStack{
            HStack {
                NavigationLink(destination: SavedForLaterView()) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 35))
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                
                Image("Logo1")
                    .resizable() // Make the image resizable
                    .scaledToFit() // Maintain the aspect ratio and fit it within the given dimensions
                    .frame(width: 85, height: 40)
                
                Spacer()
                
                NavigationLink(destination: ProfileView()) {
                    if let userImage = loadImage(imageName: "userProfile.jpg") {
                        Image(uiImage: userImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .foregroundColor(Color.white)
                            .overlay(
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.white)
                            )
                    } else {
                        Image(systemName: "person.circle")
                            .font(.system(size: 35))
                            .foregroundColor(Color.white)
                    }
                }
            }
            .padding()
            .background(Color("SecondaryBlueColor"))
            .clipShape(Capsule())
        }
        .background(Color("PrimaryBlueColor").edgesIgnoringSafeArea(.all))
    }
}

/*
#Preview {
    UI_TopBar()
} */
