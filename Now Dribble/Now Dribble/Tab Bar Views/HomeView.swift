//
//  HomeView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI


struct HomeView: View {
    @State var posts: [Post] = [] // Holds the posts on the feed
    
    var body: some View {
        VStack {          
            ScrollView {
                VStack {
                    Text("NOW Happening")
                        .font(.system(.title, design: .rounded))
                        .padding()
                        .bold()
                    
                    // Display antonio's posts
                    Text("POSTS HERE")
                    List(posts) { post in
                        PostView(post: post)
                    }
                    .onAppear {
                        fetchPosts { fetchedPosts in
                            self.posts = fetchedPosts
                        }
                    }
                } // End VStack
            } // End of Scroll View
        } // End of outer VStack
    } // End View
} // End Struct

#Preview {
    HomeView()
}
