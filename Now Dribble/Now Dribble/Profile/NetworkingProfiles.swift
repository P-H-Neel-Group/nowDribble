//
//  NetworkingProfiles.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 1/11/24.
//

import Foundation

class AccountViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertMessage = ""

    func deleteAccount() {
        guard let url = URL(string: "\(IP_ADDRESS)/UserData/DeleteCurrentUser") else {
            self.alertMessage = "Invalid URL"
            self.showAlert = true
            return
        }
        
        guard let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
              let token = String(data: tokenData, encoding: .utf8) else {
            self.alertMessage = "Failed to retrieve authentication token."
            self.showAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertMessage = "Error deleting account: \(error.localizedDescription)"
                    self.showAlert = true
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.alertMessage = "Invalid response"
                    self.showAlert = true
                    return
                }

                switch httpResponse.statusCode {
                case 200...299:
                    self.alertMessage = "Account deleted successfully"
                default:
                    self.alertMessage = "Failed to delete account: \(httpResponse.statusCode)"
                }
                self.showAlert = true
            }
        }
        task.resume()
    }
}
