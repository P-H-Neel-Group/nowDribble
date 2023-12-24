//
//  Networking_Posts.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 12/3/23.
//

import Foundation


// GET POSTS
func fetchPosts(completion: @escaping ([Post]) -> Void) {
    guard let url = URL(string: "") else {
        print("Invalid URL")
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching posts: \(error)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Invalid response from server")
            return
        }

        if let data = data {
            if let decodedResponse = try? JSONDecoder().decode([Post].self, from: data) {
                DispatchQueue.main.async {
                    completion(decodedResponse)
                }
            }
        }
    }

    task.resume()
}
