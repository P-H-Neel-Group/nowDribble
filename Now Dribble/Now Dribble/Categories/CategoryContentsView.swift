//
//  CategoryListView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 2/27/24.
// Each category contains a list of workouts, this file displays the contents of a category.

import SwiftUI
import Foundation

class CategoryContentsViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchWorkoutsForCategory(categoryId: Int) {
        isLoading = true
        errorMessage = nil
        
        guard let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
              let token = String(data: tokenData, encoding: .utf8) else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Authentication error: Unable to retrieve token."
            }
            return
        }

        let urlString = "\(IP_ADDRESS)/Workout/GetEnabledUserWorkoutsByCategory"
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
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
}

struct CategoryContentsView: View {
    @StateObject var viewModel = CategoryContentsViewModel()
    let categoryId: Int
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.workouts, id: \.workout_id) { workout in
                        NavigationLink(destination: destinationView(for: workout)) {
                            WorkoutContent(workout: workout)
                        }
                        .padding()
                        .background(bcolor(cc: "primary", backup: "env"))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding() // Add some padding around the VStack
        }
        .background(bcolor(cc: "primary", backup: "env"))
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

struct WorkoutContent: View {
    var workout: Workout

    var body: some View {
        AsyncImage(url: URL(string: workout.image_url)) { phase in
            switch phase {
            case .empty, .failure:
                Rectangle()
                    .frame(width: 400, height: 300)
                    .cornerRadius(10)
                    .background(bcolor(cc: "secondary", backup: "env"))
            case .success(let image):
                image.resizable()
                    .frame(width: 400, height: 300)
                    .scaledToFill()
                    .cornerRadius(10)
                    .clipped()
            @unknown default:
                EmptyView()
            }
        }
        .overlay(
            VStack {
                Text(workout.name.uppercased())
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .padding(5)
                    .cornerRadius(5)
                Image(systemName: "flame.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .foregroundColor(.accentColor)
                    .font(.system(size: 50))
            }
        )
        .grayscale(workout.user_has_access ? 0 : 1)
    }
}

@ViewBuilder
 private func destinationView(for workout: Workout) -> some View {
     if workout.user_has_access {
         WorkoutView(workoutId: workout.workout_id)
     } else {
         SubscriptionsView()
     }
 }
