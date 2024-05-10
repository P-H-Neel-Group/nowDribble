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
    let user_saved: Bool
    let user_has_access: Bool
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
    let user_saved: Bool
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
        guard let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
              let token = String(data: tokenData, encoding: .utf8) else {
            DispatchQueue.main.async {
                self.errorMessage = "Authentication error: Unable to retrieve token."
            }
            return
        }
        
        let urlString = "\(IP_ADDRESS)/Workout/GetUserWorkoutDetails"
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
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

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
