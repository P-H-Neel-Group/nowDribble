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
                    Text("NOW Happening")
                        .font(.system(.title, design: .rounded))
                        .foregroundColor(Color.white)
                        .padding()
                        .bold()
                    
                    // Display the app intro video
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

