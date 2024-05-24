//
//  NetworkingProfiles.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 1/11/24.
//

import Foundation
import UIKit

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

    func editUserData(newUserData: [String: Any]) {
        guard let url = URL(string: "\(IP_ADDRESS)/UserData/EditUserData") else {
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
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: newUserData, options: [])
        } catch {
            self.alertMessage = "Failed to encode user data"
            self.showAlert = true
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertMessage = "Error editing user data: \(error.localizedDescription)"
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
#if DEBUG
                    print("Saved User data")
#endif
                    self.alertMessage = "User data edited successfully"
                default:
                    self.alertMessage = "Failed to edit user data: \(httpResponse.statusCode)"
                }
                self.showAlert = true
            }
        }
        task.resume()
    }

    func editProfilePicture(profileImage: UIImage) {
        guard let url = URL(string: "\(IP_ADDRESS)/UserData/EditProfilePicture") else {
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
        
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let filename = "userProfile.jpg"
        let fieldName = "profilePicture"
        let mimeType = "image/jpeg"
        
        guard let imageData = profileImage.jpegData(compressionQuality: 1) else {
            self.alertMessage = "Failed to encode profile image"
            self.showAlert = true
            return
        }
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertMessage = "Error editing profile picture: \(error.localizedDescription)"
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
#if DEBUG
                    print("Saved User image")
#endif
                    self.alertMessage = "Profile picture edited successfully"
                default:
#if DEBUG
                    print("Failed saving User image")
#endif
                    self.alertMessage = "Failed to edit profile picture: \(httpResponse.statusCode)"
                }
                self.showAlert = true
            }
        }
        task.resume()
    }
    
    func downloadProfileImage(completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "\(IP_ADDRESS)/UserData/GetProfilePicture") else {
            self.alertMessage = "Invalid URL"
            self.showAlert = true
            completion(nil)
            return
        }
        
        guard let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
              let token = String(data: tokenData, encoding: .utf8) else {
            self.alertMessage = "Failed to retrieve authentication token."
            self.showAlert = true
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertMessage = "Error downloading profile image: \(error.localizedDescription)"
                    self.showAlert = true
                    completion(nil)
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    self.alertMessage = "Invalid image data"
                    self.showAlert = true
                    completion(nil)
                    return
                }
                
                completion(image)
            }
        }
        task.resume()
    }
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
