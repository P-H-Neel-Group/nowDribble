//
//  ContentView.swift (main)
//  Displays the UI_TopBar() on all views and the TabView at the bottom.
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: String = "TRAIN" // Default tab

    var body: some View {
        NavigationView {
            VStack (spacing: 0){
                UI_TopBar()

                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag("HOME")
                    
                    TrainNowView()
                        .tabItem {
                            Label("Train Now", systemImage: "basketball.fill")
                        }
                        .tag("TRAIN")
                    
                    NumberView()
                        .tabItem {
                            Label("Numbers", systemImage: "ellipsis.rectangle.fill")
                        }
                        .tag("NUMBERS")
//                    Subscriptions()
//                        .tabItem {
//                            Label("Subscriptions", systemImage: "ellipsis.rectangle.fill")
//                        }
//                        .tag("SUBSCRIPTIONS")
                } // End of Tab View
                .accentColor(Color("TabButtonColor"))
                .padding(0)

            } // End of VStack
            .background(bcolor(cc: "primary", backup: "env"))

        } // End of NavView
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .background(bcolor(cc: "secondary", backup: "env"))
        
    } // End of Body
} // End of Struct
