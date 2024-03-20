//
//  HomeView.swift
//  Calls PostView for Each Post
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI


struct HomeView: View {
    @State var posts: [Post] = [] // Holds the posts on the feed
    @State var showVideo: Bool = false
    private let aspectRatio: CGFloat = 16/9

    var body: some View {
        VStack {          
            ScrollView {
                VStack {
                    // Display the app intro video
                    PostView(post: Post(profileImageURL: "https://cdn.discordapp.com/attachments/1060379681158860901/1219836710792331335/605e5208db9ddc7d468a3a1c_coachCookAvatar.png?ex=660cc077&is=65fa4b77&hm=0fc6f3ed74adbeaac44b4d7ffb5921b8e56e006908c867f01c6f95c1e9764525&", name: "Coach Cook", content: "Welcome to Now Dribble"))

                    if showVideo {
                        VideoPlayerView(url: URL(string: "https://nowdribble-static.s3.amazonaws.com/AppIntro.mp4")!, showCaption: false, caption: "Welcome")
                            .padding([.leading, .trailing, .bottom], 15)
                    } else {
                        ZStack {
                            AsyncImage(url: URL(string: "https://nowdribble-static.s3.amazonaws.com/images/shoulderPullDowns.PNG")) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 400, height: 250) // Match the VideoPlayer's frame dimensions
                            .clipped()
                            .scaledToFill()
                            .cornerRadius(10)

                            // Overlay a play button on the thumbnail
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            withAnimation {
                                showVideo = true
                            }
                        }
                    }
                    
                    Divider()

                    // Display Antonio's posts
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
        .background(Color("PrimaryBlueColor"))
    } // End View
} // End Struct

