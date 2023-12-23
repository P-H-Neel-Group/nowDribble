//
//  TrainNowView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

struct AnyViewWrapper: View {
    let contentView: AnyView

    init(_ contentView: AnyView) {
        self.contentView = contentView
    }

    var body: some View {
        contentView
    }
}

struct TrainNowView: View {
    // Hide the ugly default navigation bar
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        //appearance.backgroundColor = UIColor.systemBackground
        appearance.shadowColor = nil // Remove the shadow line
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().shadowImage = UIImage() // Empty image for shadow line
    }
    
    var body: some View {
        Text("WIP")
    }
}

/*
 struct TrainNowView: View {
     @State private var selectedCategory: WorkoutCategory? = nil
     @State private var selectedWorkoutView: WorkoutCategory? = nil
     @State private var showDetailView: Bool = false

     // Hide the ugly default navigation bar
     init() {
         let appearance = UINavigationBarAppearance()
         appearance.configureWithOpaqueBackground()
         //appearance.backgroundColor = UIColor.systemBackground
         appearance.shadowColor = nil // Remove the shadow line
         UINavigationBar.appearance().standardAppearance = appearance
         UINavigationBar.appearance().compactAppearance = appearance
         UINavigationBar.appearance().scrollEdgeAppearance = appearance
         UINavigationBar.appearance().shadowImage = UIImage() // Empty image for shadow line
     }
     
     var body: some View {
         NavigationView {
             ScrollView {
                 VStack {
                     Text(selectedCategory?.label ?? "Train NOW")
                         .font(.system(.title, design: .rounded))
                         .padding()
                         .bold()
                     
                     // Display subcategories or main categories based on the selected category
                     if let subcategories = selectedCategory?.subCategories {
                         ForEach(subcategories) { subcategory in
                             Button(action: {
                                 self.selectedWorkoutView = subcategory
                                 self.showDetailView = true  // Set to true when any subcategory is selected
                             }) {
                                 WorkoutCategoryView(category: subcategory)
                             }
                             .padding(.bottom)
                         }
                     } else {
                         ForEach(workoutCategories) { category in
                             Button(action: {
                                 self.selectedCategory = category
                             }) {
                                 WorkoutCategoryView(category: category)
                             }
                             .padding(.bottom)
                         }
                     }
                 }
             }
             .sheet(isPresented: $showDetailView) {
                 // Check if the selected category has a specific view
                 if let specificView = selectedWorkoutView?.view {
                     specificView
                 } else {
                     // Fallback to the generic workout detail view
                     WorkoutDetailView(workout: selectedCategory ?? WorkoutCategory(imageName: "", label: ""))
                 }
             }
             .navigationBarHidden(false)
             .navigationBarTitle("", displayMode: .inline)
             .navigationBarItems(trailing: Button("Back") {
                 // Go back to the main categories
                 self.selectedCategory = nil
             }.opacity(selectedCategory != nil ? 1 : 0))
         }
     }
 }

 */
