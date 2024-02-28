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
    var id: Int { category_id }

}

class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchCategories() {
        guard let url = URL(string: "http://18.221.147.65:5000/Workout/GetEnabledCategories") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        self.isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
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

//struct CategoriesView: View {
//    @StateObject private var viewModel = CategoriesViewModel()
//
//    var body: some View {
//        NavigationView {
//            ScrollView{
//                VStack{
//                    List(viewModel.categories) { category in
//                        Text(category.name)
//                    }
//                    .navigationTitle("Categories")
//                    .onAppear {
//                        viewModel.fetchCategories()
//                    }
//                    .overlay {
//                        if viewModel.isLoading {
//                            ProgressView("Loading...")
//                        }
//                    }
//                    .alert("Error", isPresented: Binding<Bool>.constant(viewModel.errorMessage != nil), presenting: viewModel.errorMessage) { errorMessage in
//                        Button("OK", role: .cancel) { }
//                    } message: { errorMessage in
//                        Text(errorMessage)
//                    }
//                }
//            }
//        }
//    }
//}
