//
//  CategoryListView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 2/27/24.
// Each category contains a list of workouts

import SwiftUI
import Foundation

class CategoryContentsViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let cacheKey = "workoutsCache"
    private let cacheTimestampKey = "workoutsCacheTimestamp"

    init() {
        loadCachedWorkouts()
    }
    
    func fetchWorkoutsForCategory(categoryId: Int) {
        isLoading = true
        errorMessage = nil
        let urlString = "http://18.221.147.65:5000/Workout/GetEnabledWorkoutsByCategory"
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            self.errorMessage = "Invalid URL"
            return
        }
        
        let body: [String: Int] = ["category_id": categoryId]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            self.isLoading = false
            self.errorMessage = "Error encoding request body"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    self.errorMessage = "Error fetching data"
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(WorkoutsResponse.self, from: data)
                    self.workouts = decodedResponse.workouts
                } catch {
                    self.errorMessage = "Failed to decode response"
                }
            }
        }.resume()
    }
    
    private func cacheWorkouts() {
        if let encodedData = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encodedData, forKey: cacheKey)
        }
    }

    private func loadCachedWorkouts() {
        guard let data = UserDefaults.standard.data(forKey: cacheKey),
              let cachedWorkouts = try? JSONDecoder().decode([Workout].self, from: data) else {
            return
        }
        self.workouts = cachedWorkouts
    }
    
    private func isCacheValid() -> Bool {
        guard let cacheDate = UserDefaults.standard.object(forKey: cacheTimestampKey) as? Date else {
            return false
        }
        return Calendar.current.isDate(cacheDate, inSameDayAs: Date()) || Calendar.current.dateComponents([.hour], from: cacheDate, to: Date()).hour! < 24
    }
}

struct CategoryContentsView: View {
    @StateObject var viewModel = CategoryContentsViewModel()
    let categoryId: Int

    var body: some View {
        ZStack {
            Color("PrimaryBlueColor")
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                LazyVStack {
                    ForEach(viewModel.workouts) { workout in
                        NavigationLink(destination: WorkoutView(workoutId: workout.workout_id)) {
                                AsyncImage(url: URL(string: workout.image_url)) { phase in
                                    switch phase {
                                    case .empty:
                                        Rectangle()
                                            .frame(width: 330, height: 180)
                                            .cornerRadius(5)
                                            .foregroundColor(Color.white)
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.white, lineWidth: 8)
                                                    .cornerRadius(5)
                                                    .overlay(
                                                        Text(workout.name.uppercased())
                                                            .font(.system(size: 20, weight: .bold, design: .default))
                                                            .foregroundColor(Color("TabButtonColor"))
                                                            .padding(5)
                                                            .cornerRadius(5)
                                                    )
                                            )
                                    case .success(let image):
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 330, height: 180)
                                            .blur(radius:2)
                                            .cornerRadius(5)
                                            .clipped()
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.white, lineWidth: 8)
                                                    .cornerRadius(5)
                                                    .overlay(
                                                        Text(workout.name.uppercased())
                                                            .font(.system(size: 20, weight: .bold, design: .default))
                                                            .foregroundColor(.white)
                                                            .padding(5)
                                                            .cornerRadius(5)
                                                    )
                                            )
                                        
                                    case .failure:
                                        Rectangle()
                                            .frame(width: 330, height: 180)
                                            .cornerRadius(5)
                                            .foregroundColor(Color.white)
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.white, lineWidth: 8)
                                                    .cornerRadius(5)
                                                    .overlay(
                                                        Text(workout.name.uppercased())
                                                            .font(.system(size: 20, weight: .bold, design: .default))
                                                            .foregroundColor(Color("TabButtonColor"))
                                                            .padding(5)
                                                            .cornerRadius(5)
                                                    )
                                            )
                                    @unknown default:
                                        EmptyView()
                                }
                            }
                            .padding() // Add padding to each item for better spacing
                            .background(Color("PrimaryBlueColor")) // Optional: Ensure each item also has the blue background
                            .cornerRadius(10) // Optional: Add rounded corners for a nicer look
                        }
                        .buttonStyle(PlainButtonStyle()) // Improve tap feedback
                    }
                }
                .padding() // Add some padding around the VStack
            }
        }
        .onAppear {
            viewModel.fetchWorkoutsForCategory(categoryId: categoryId)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading...")
            }
        }
        .alert("Error", isPresented: Binding<Bool>.constant(viewModel.errorMessage != nil), presenting: viewModel.errorMessage) { errorMessage in
            Button("OK", role: .cancel) { }
        } message: { errorMessage in
            Text(errorMessage)
        }
    }
}
