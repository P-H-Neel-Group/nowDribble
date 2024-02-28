//
//  HomeView.swift
//  Calls PostView for Each Post
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
                    
                    // Display the app intro video
                    VideoPlayerView(url: URL(string: "https://nowdribble-static.s3.amazonaws.com/AppIntro.mp4")!, caption: "Welcome")
                        .frame(height: 200)
                        .padding([.leading, .trailing, .bottom], 15)

                    // Display Antonio's posts
                    Text("POSTS HERE")
                    List(self.posts) { post in
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

