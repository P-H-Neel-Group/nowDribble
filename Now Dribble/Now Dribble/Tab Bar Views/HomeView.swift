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
    @State private var showIntroVideoSheet: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var oppositeColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Display the app intro video
                    PostView(post: Post(profileImageURL: "https://do8xgcq7e6j49.cloudfront.net/profile-picture-test/605e5208db9ddc7d468a3a1c_coachCookAvatar.png", name: "Coach Cook", content: "Welcome to Now Dribble!", video_url: "", image_url: ""))
                    
                    Button(action: {
                        showIntroVideoSheet = true
                    }) {
                        Text("Watch Intro Video")
                            .foregroundColor(Color("TabButtonColor"))
                            .padding()
                            .background(bcolor(cc: "primary", backup: "env"))
                            .shadow(radius: 1)
                            .bold()
                    }
                    .sheet(isPresented: $showIntroVideoSheet) {
                        VideoPlayerView(
                            url: URL(string: "https://now-dribble.s3.us-east-2.amazonaws.com/static/AppIntro.mp4")!,
                            showCaption: false,
                            caption: "",
                            isFullScreen: true
                        )
                    }
//                    NavigationLink(destination: SubscriptionsView()) {
//                        Text("Subscribe")
//                            .foregroundColor(Color("TabButtonColor"))
//                            .padding()
//                            .background(bcolor(cc: "primary", backup: "env"))
//                            .shadow(radius: 1)
//                            .bold()
//                    }
                    
                    Divider()

                    // Display Antonio's posts
                    LazyVStack {
                        if viewModel.posts.count == 0 {
                            Text("Nothing has been posted here.")
                                .foregroundColor(oppositeColor.opacity(0.50))
                                .fontWeight(.semibold)
                                .padding(.vertical, 24)
                        } else {
                            ForEach(viewModel.posts) { post in
                                PostView(post: post)
                            }
                        }
                        Spacer().frame(height: 80)
                    }
                    .onAppear {
                        viewModel.fetchPosts()
                    }
                } // End VStack
            } // End of Scroll View
        } // End of outer NavigationView
            .background(bcolor(cc: "primary", backup: "env")).edgesIgnoringSafeArea(.vertical)
    } // End View
} // End Struct

