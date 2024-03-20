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
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())

                Text(post.name)
                    .font(.headline)
            }

            Text(post.content)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


//#Preview {
//    PostView(post: <#Post#>)
//}
