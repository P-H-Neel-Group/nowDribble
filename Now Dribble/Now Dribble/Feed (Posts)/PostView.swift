//
//  PostView.swift
//  Displays one Post
//
//  Created by Isaiah Harville on 12/3/23.
//

import SwiftUI

// Post Data Structure
struct Post: Identifiable, Codable {
    var id = UUID()
    var profileImageURL: String
    var name: String
    var content: String
    var video_url: String
    var image_url: String
}

// Post View
struct PostView: View {
    var post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                AsyncImage(url: URL(string: post.profileImageURL)) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.crop.circle").resizable()
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())

                Text(post.name)
                    .font(.headline)
            }

            Text(post.content)
            
            if (post.image_url != "") {
                AsyncImage(url: URL(string: post.image_url)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .clipped()
                } placeholder: {
                    ProgressView("Loading Image...")
                }
            }
            
            if (post.video_url != "") {
                VideoPlayerView(url: URL(string: post.video_url)!, showCaption: false, caption: "")
                    .padding([.leading, .trailing, .bottom], 15)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
