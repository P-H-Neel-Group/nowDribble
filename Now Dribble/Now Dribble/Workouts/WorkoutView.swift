//
//  WorkoutView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 1/15/24.
//

import SwiftUI

struct WorkoutsResponse: Codable {
    let workouts: [Workout]
}

struct Workout: Identifiable, Codable {
    let workout_id: Int
    let category_id: Int
    let name: String
    let description: String
    let image_url: String
    var id: Int { workout_id }
}

struct WorkoutDetailResponse: Codable {
    let workout: WorkoutDetail
}

struct WorkoutDetail: Identifiable, Codable {
    let workout_id: Int
    let category_id: Int
    let name: String
    let description: String
    let image_url: String
    let sequences: [WorkoutSequence]
    let videos: [WorkoutVideo]
    var id: Int { workout_id }
}

struct WorkoutSequence: Identifiable, Codable {
    let workout_sequence_id: Int
    let description: String
    let time: Int
    var id: Int { workout_sequence_id }
}

struct WorkoutVideo: Identifiable, Codable {
    let video_id: Int
    let title: String
    let url: String
    var id: Int { video_id }
}

class WorkoutFetcher: ObservableObject {
    @Published var workoutDetail: WorkoutDetail?
    @Published var errorMessage: String?

    func fetchWorkout(byId id: Int) {
        let urlString = "http://18.221.147.65:5000/Workout/GetWorkoutDetails"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let body: [String: Int] = ["workout_id": id]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            self.errorMessage = "Error encoding request body"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(WorkoutDetailResponse.self, from: data)
                    self.workoutDetail = decodedResponse.workout
                } catch {
                    self.errorMessage = "Failed to decode response"
                }
            }
        }.resume()
    }
}

struct WorkoutView: View {
    let workoutId: Int
    @StateObject private var fetcher = WorkoutFetcher()
    
    var body: some View {
        Group {
            if let workout = fetcher.workoutDetail {
                ScrollView {
                    VStack {
                        AsyncImage(url: URL(string: workout.image_url)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300, maxHeight: 300)
                        
                        Text(workout.name)
                            .font(.title)
                        Text(workout.description)
                            .font(.body)
                            .padding()
                        
                        ForEach(workout.sequences) { sequence in
                            Text(sequence.description)
                                .padding()
                        }
                        
                        ForEach(workout.videos) { video in
                            VideoPlayerView(url: URL(string: video.url)!, caption: video.title)
                                .frame(height: 200)
                                .padding([.leading, .trailing, .bottom], 15)
                        }
                    }
                }
            } else {
                ProgressView("Loading workout...")
            }
        }
        .background(Color("PrimaryBlueColor"))
        .onAppear {
            fetcher.fetchWorkout(byId: workoutId)
        }
        .alert("Error", isPresented: Binding<Bool>.constant(fetcher.errorMessage != nil), presenting: fetcher.errorMessage) { errorMessage in
            Button("OK", role: .cancel) { }
        } message: { errorMessage in
            Text(errorMessage)
        }
    }
}
