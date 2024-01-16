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
        // TODO
        // Show categories,
        // Under categories show the workouts (WorkoutView.swift)
        
        Text("WIP")
    }
}
