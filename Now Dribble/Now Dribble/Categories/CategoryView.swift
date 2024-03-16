//
//  CategoryView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 2/27/24.
//

import SwiftUI

struct CategoriesResponse: Decodable {
    let categories: [Category]
}

struct Category: Identifiable, Decodable {
    let category_id: Int
    let name: String
    let image_url: String
    let workout_count: Int
    let user_has_access : Bool
    var id: Int { category_id }
}

class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func fetchCategories() {
        guard let url = URL(string: "http://\(IP_ADDRESS)/Workout/GetEnabledUserCategories") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        guard let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
              let token = String(data: tokenData, encoding: .utf8) else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Authentication error: Unable to retrieve token."
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        self.isLoading = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Failed to fetch: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                    self.categories = response.categories // Now accessing the categories array
                    #if DEBUG
                    print("Fetched categories: \(self.categories)")
                    #endif
                    
                } catch {
                    self.errorMessage = "Failed to decode JSON: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
