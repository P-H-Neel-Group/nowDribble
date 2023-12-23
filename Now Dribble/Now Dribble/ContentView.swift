//
//  ContentView.swift (main)
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                UI_TopBar()
                Divider()
                Spacer()
                
                TabView {
                    HomeView()
                        .tabItem {
                            Label("HOME", systemImage: "house")
                        }
                    
                    TrainNowView()
                        .tabItem {
                            Label("TRAIN NOW", systemImage: "figure.basketball")
                        }
                    
                    NumberView()
                        .tabItem {
                            Label("NUMBERS", systemImage: "basketball.fill")
                        }
                    LoginView()
                        .tabItem {
                            Label("LOGIN", systemImage: "person.circle")
                        }
                } // End of Tab View
                .accentColor(Color("TabButtonColor")) // Set the selected tab color to your primary color
                
            } // End of VStack
        } // End of NavView
    } // End of Body
} // End of Struct

#Preview {
    ContentView()
}
