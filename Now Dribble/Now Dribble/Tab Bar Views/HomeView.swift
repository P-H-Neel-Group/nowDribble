//
//  HomeView.swift
//  Calls PostView for Each Post
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var viewModel = PostViewModel() // Now using PostViewModel
    @State var showVideo: Bool = false
    private let aspectRatio: CGFloat = 16/9

    var body: some View {
        VStack {          
            ScrollView {
                VStack {
                    // Display the app intro video
                    PostView(post: Post(profileImageURL: "https://cdn.discordapp.com/attachments/1060379681158860901/1219836710792331335/605e5208db9ddc7d468a3a1c_coachCookAvatar.png?ex=660cc077&is=65fa4b77&hm=0fc6f3ed74adbeaac44b4d7ffb5921b8e56e006908c867f01c6f95c1e9764525&", name: "Coach Cook", content: "Welcome to Now Dribble", video_url: "https://now-dribble.s3.us-east-2.amazonaws.com/static/AppIntro.mp4", image_url: ""))
                    
                    Divider()

                    // Display Antonio's posts
                    LazyVStack {
                        ForEach(viewModel.posts) { post in
                            PostView(post: post)
                        }
                    }
                    .onAppear {
                        viewModel.fetchPosts()
                    }
                } // End VStack
            } // End of Scroll View
        } // End of outer VStack
        .background(Color("PrimaryBlueColor"))
    } // End View
} // End Struct

