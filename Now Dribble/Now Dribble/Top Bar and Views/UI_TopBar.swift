//
//  UI_TopBar.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 12/3/23.
//

import SwiftUI

struct UI_TopBar: View {
    var body: some View {
        HStack {
            NavigationLink(destination: SavedForLaterView()) {
                Image(systemName: "star.fill")
                    .font(.system(size: 33))
                    .foregroundColor(Color.white)
            }

            Spacer()

            Text("NOW")
                .font(.system(.title, design: .rounded))
                .bold()
                .foregroundColor(Color.white)

            Spacer()

            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.circle")
                    .font(.system(size: 35))
                    .foregroundColor(Color.white)
            }
        }
        .padding()
        .background(Color("SecondaryBlueColor"))
    }
}

/*
#Preview {
    UI_TopBar()
} */
