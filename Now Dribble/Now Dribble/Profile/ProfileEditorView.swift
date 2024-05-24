//
//  ProfileEditorView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 12/3/23.
//

import SwiftUI
import UIKit

func saveImage(image: UIImage) -> URL? {
    guard let data = image.jpegData(compressionQuality: 1) else {
        print("Failed to convert UIImage to JPEG data.")
        return nil
    }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
        print("Failed to find document directory.")
        return nil
    }
    let filePath = directory.appendingPathComponent("userProfile.jpg")
    do {
        try data.write(to: filePath)
        print("Image saved successfully at path: \(filePath.absoluteString)")
        return filePath
    } catch {
        print("Error saving image: \(error.localizedDescription)")
        return nil
    }
}

func loadImage(imageName: String) -> UIImage? {
    let fileManager = FileManager.default
    if let directory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
        let imagePath = directory.appendingPathComponent(imageName).path
        
        if fileManager.fileExists(atPath: imagePath) {
            // The file exists, so attempt to create and return a UIImage
            return UIImage(contentsOfFile: imagePath)
        } else {
            print("Image does not exist at path: \(imagePath).")
        }
    } else {
        print("Could not find the directory.")
    }
    return nil
}


struct ProfileEditorView: View {
    @Environment(\.presentationMode) var presentationMode // For navigation
    @State private var userName: String = ""
    @State private var profileUIImage: UIImage? = UIImage(systemName: "person.crop.circle") // Now using UIImage
    @State private var isImagePickerDisplayed: Bool = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel // for signing out
    @StateObject var accountVM = AccountViewModel()

    private func updateProfileImage() {
        if let loadedUIImage = loadImage(imageName: "userProfile.jpg") {
            self.profileUIImage = loadedUIImage
        } else {
            self.profileUIImage = UIImage(systemName: "person.crop.circle")
        }
    }

    func loadUserName() {
        userName = getUserName() ?? "Person"
    }
    
    var body: some View {
        VStack {
            Image(uiImage: profileUIImage ?? UIImage(systemName: "person.crop.circle")!)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()
                .onTapGesture {
                    isImagePickerDisplayed = true
                }

            TextField("Display Name", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save Changes") {
                if let profileUIImage = profileUIImage, let imageURL = saveImage(image: profileUIImage) {
                    accountVM.editProfilePicture(profileImage: profileUIImage)
            
                    let userData: [String: Any] = ["username": userName]
                    accountVM.editUserData(newUserData: userData)
                } else {
                    // Send user data to backend if no image is uploaded
                    let userData: [String: Any] = ["username": userName]
                    accountVM.editUserData(newUserData: userData)
                }
                
                presentationMode.wrappedValue.dismiss() // Navigate back
            }
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("TabButtonColor"))
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
        .sheet(isPresented: $isImagePickerDisplayed) {
            ImagePicker(selectedImage: $profileUIImage, sourceType: .photoLibrary)
        }
        .background(bcolor(cc: "primary", backup: "env"))
        .navigationTitle("Edit Profile")
        .onAppear {
            updateProfileImage()
        }
        .alert(isPresented: $accountVM.showAlert) {
            Alert(title: Text("Alert"), message: Text(accountVM.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
