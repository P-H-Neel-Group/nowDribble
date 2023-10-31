//
//  ContentView.swift (main)
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Group {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                } // End of VStack
                .padding()
            } // End of Group
        } // End of NavStack
    }
}

#Preview {
    ContentView()
}
