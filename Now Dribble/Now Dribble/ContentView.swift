//
//  ContentView.swift (main)
//  Displays the UI_TopBar() on all views and the TabView at the bottom.
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "HOME" // Default tab

    var body: some View {
        NavigationView {
            VStack {
                if selectedTab != "LOGIN" { // Dont show top bar on login page
                    UI_TopBar()
                    Divider()
                }
                Spacer()
                
                TabView {
                    HomeView()
                        .tabItem {
                            Label("HOME", systemImage: "house")
                        }
                        .tag("HOME")
                    
                    TrainNowView()
                        .tabItem {
                            Label("TRAIN NOW", systemImage: "figure.basketball")
                        }
                        .tag("TRAIN NOW")
                    
                    NumberView()
                        .tabItem {
                            Label("NUMBERS", systemImage: "basketball.fill")
                        }
                        .tag("NUMBERS")
                } // End of Tab View
                .accentColor(Color("TabButtonColor")) // Set the selected tab color to your primary color
                
            } // End of VStack
        } // End of NavView
    } // End of Body
} // End of Struct

struct HideTopBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarHidden(true) // Hides the navigation bar
            .navigationBarBackButtonHidden(true) // Hides the back button
    }
}

/*#Preview {
    ContentView()
}*/
