//
//  Networking_Posts.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 12/3/23.
//

import Foundation


// Verify Poster
func isSpecialUser() -> Bool {
    // Replace with actual logic to determine if the current user is the special user
    return true // for testing, assuming the current user is the special user
}

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


// POST POSTS
func createPost(post: Post, completion: @escaping (Bool) -> Void) {
    guard let url = URL(string: "") else {
        print("Invalid URL")
        return
    }

    guard let encoded = try? JSONEncoder().encode(post) else {
        print("Failed to encode post")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = encoded

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error creating post: \(error)")
            completion(false)
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Invalid response from server")
            completion(false)
            return
        }

        DispatchQueue.main.async {
            completion(true)
        }
    }

    task.resume()
}

