//
//  NetworkingSaved.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 4/19/24.
//

import Foundation

struct SavedWorkout: Identifiable, Codable {
    let workout_id: Int
    let category_id: Int
    let name: String
    let description: String?
    let image_url: String
    let user_has_access: Bool
    var id: Int { workout_id }
}

struct SavedWorkoutsResponse: Codable { // oh gosh this is such a bad naming scheme
    let workouts: [SavedWorkout]
}

class SavedWorkoutsViewModel: ObservableObject {
    @Published var savedWorkouts: [SavedWorkout] = []
    @Published var errorMessage: String = ""

    func fetchSavedWorkouts() {
        guard let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
              let token = String(data: tokenData, encoding: .utf8) else {
            DispatchQueue.main.async {
                self.errorMessage = "Authentication error: Unable to retrieve token."
            }
            return
        }
        
        let urlString = "http://\(IP_ADDRESS)/UserData/GetSavedWorkouts"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching data"
                }
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(SavedWorkoutsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.savedWorkouts = decodedResponse.workouts
                }
            } catch let decodingError {
                print("Decoding error:", decodingError)
                DispatchQueue.main.async {
                    self.errorMessage = "Error decoding data: \(decodingError.localizedDescription)"
                }
            }
            #if DEBUG
            print(self.errorMessage)
            #endif
        }.resume()
    }

    // Called with bookmark buttons on workout
    func saveWorkout(workoutID: Int) {
        guard let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
              let token = String(data: tokenData, encoding: .utf8) else {
            self.errorMessage = "Authentication error: Unable to retrieve token."
            return
        }

        let urlString = "http://\(IP_ADDRESS)/UserData/SaveWorkout"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }

        let requestBody: [String: Any] = ["workout_id": workoutID]

        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = requestData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Network error: \(error.localizedDescription)"
                    }
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error saving workout"
                    }
                    return
                }
                #if DEBUG
                print("Saved workout")
                #endif
                // NOTE: This is the success area if we need any logic here

            }.resume()
        } catch {
            self.errorMessage = "Error encoding request"
        }
    }
    
    // Called with bookmark buttons on workout
    func unsaveWorkout(workoutID: Int) {
        guard let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
              let token = String(data: tokenData, encoding: .utf8) else {
            self.errorMessage = "Authentication error: Unable to retrieve token."
            return
        }
        
        let urlString = "http://\(IP_ADDRESS)/UserData/UnsaveWorkout"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let requestBody: [String: Any] = ["workout_id": workoutID]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = requestData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Network error: \(error.localizedDescription)"
                    }
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error un-saving workout"
                    }
                    return
                }
                
                // Handle success if needed
                #if DEBUG
                print("Removed workout")
                #endif
            }.resume()
        } catch {
            self.errorMessage = "Error encoding request"
        }
    }
    
    func removeWorkouts(atOffsets offsets: IndexSet) {
        for index in offsets {
            let workoutID = savedWorkouts[index].workout_id
            removeWorkout(withID: workoutID)
        }
    }
    
    func removeWorkout(withID workoutID: Int) {
        if let index = savedWorkouts.firstIndex(where: { $0.workout_id == workoutID }) {
            savedWorkouts.remove(at: index)
            unsaveWorkout(workoutID: workoutID) // Assuming this function handles other necessary cleanup
        }
    }
}
