//
//  ProfileView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 1/11/24.
//

import SwiftUI

struct ProfileView: View {
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
                        .foregroundColor(Color("TabButtonColor"))
                }
            } // End HStack
            .padding()
            
            Divider()
            
            Spacer()
            
            // Display user's profile
            Text("Profile Image")
            Text("Name")
            
            // Show user's friends
            HStack{
                ScrollView(.horizontal, showsIndicators: false) {
                    Spacer()
                    Text("List of friends")
                    Spacer()
                }
            } // End HStack
            
            Spacer()
        }
    }
}

/*
#Preview {
    ProfileView()
}*/
