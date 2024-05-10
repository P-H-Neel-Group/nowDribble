//
//  Networking_Posts.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 12/3/23.
//

import Foundation

struct PostResponse: Codable {
    let posts: [PostData]
}

struct PostData: Codable {
    let post_id: Int
    let user_id: Int
    let username: String
    let user_image_url: String
    let content: String
    var video_url: String
    var image_url: String
}


class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    func fetchPosts() {
        guard let url = URL(string: "\(IP_ADDRESS)/Post/GetRecentPosts") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(PostResponse.self, from: data)
                DispatchQueue.main.async {
                    self.posts = response.posts.map { post in
                        Post(id: UUID(), profileImageURL: post.user_image_url, name: post.username, content: post.content, video_url: post.video_url, image_url: post.image_url)
                    }
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}
