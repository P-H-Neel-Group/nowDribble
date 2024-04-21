//
//  ContentView.swift (main)
//  Displays the UI_TopBar() on all views and the TabView at the bottom.
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: String = "HOME" // Default tab
    
//    init() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(Color("PrimaryBlueColor"))
//        appearance.shadowColor = nil // Remove the shadow line
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().compactAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        UINavigationBar.appearance().isTranslucent = true // Set translucency
//        UINavigationBar.appearance().tintColor = .clear // Make the tint color clear
//        UINavigationBar.appearance().shadowImage = UIImage() // Empty image for shadow line
//    }
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0){
                if selectedTab != "LOGIN" { // Dont show top bar on login page
                    UI_TopBar()
                }
                Spacer()
                
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
                        .tag("TRAIN NOW")
                    
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
            } // End of VStack
        } // End of NavView
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .background(Color("SecondaryBlueColor"))
    } // End of Body
} // End of Struct
