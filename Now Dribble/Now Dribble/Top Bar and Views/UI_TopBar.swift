//
//  UI_TopBar.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 12/3/23.
//

import SwiftUI

struct UI_TopBar: View {
    @State private var isSavedForLaterPresented = false
    @Environment(\.colorScheme) var colorScheme

    var oppositeColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        HStack {
            Button(action: {
                isSavedForLaterPresented.toggle()
            }) {
                Image(systemName: "bookmark")
                    .font(.system(size: 35))
                    .foregroundColor(oppositeColor)
            }
            
            Spacer()
            
            Image("Logo1")
                .resizable()
                .scaledToFit()
                .frame(width: 85, height: 40)
            
            Spacer()
            
            NavigationLink(destination: ProfileView()) {
                if let userImage = loadImage(imageName: "userProfile.jpg") {
                    Image(uiImage: userImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 1)
                                .foregroundColor(oppositeColor)
                        )
                } else {
                    Image(systemName: "person.circle")
                        .font(.system(size: 35))
                        .foregroundColor(oppositeColor)
                }
            }
        }
        .padding([.bottom, .leading, .trailing])
        //.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top) NOTE: deprecated since ios 15 -- doesnt look like we need it though
        .background(bcolor(cc: "primary", backup: "env"))
        .sheet(isPresented: $isSavedForLaterPresented) {
            SavedForLaterView()
        }
    }
}
