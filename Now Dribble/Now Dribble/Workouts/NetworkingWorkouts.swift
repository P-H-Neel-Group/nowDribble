//
//  NetworkingWorkouts.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 1/15/24.
//

import Foundation

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
    
    private func cacheKey(forWorkoutId id: Int) -> String {
        return "workoutDetailsCache_\(id)"
    }
    
    private func cacheWorkoutDetail() {
        if let workoutDetail = workoutDetail, let encodedData = try? JSONEncoder().encode(workoutDetail) {
            let key = cacheKey(forWorkoutId: workoutDetail.workout_id)
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
    
    private func loadCachedWorkoutDetail(forWorkoutId id: Int) {
        let key = cacheKey(forWorkoutId: id)
        if let data = UserDefaults.standard.data(forKey: key), let cachedWorkout = try? JSONDecoder().decode(WorkoutDetail.self, from: data) {
            self.workoutDetail = cachedWorkout
        }
    }
    
    func fetchWorkout(byId id: Int) {
        loadCachedWorkoutDetail(forWorkoutId: id)

        let urlString = "http://18.224.58.18:5000/Workout/GetWorkoutDetails"
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
