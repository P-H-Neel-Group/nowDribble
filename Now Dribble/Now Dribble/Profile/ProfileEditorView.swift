//
//  ProfileEditorView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 12/3/23.
//

import SwiftUI

func saveImage(image: UIImage) {
    guard let data = image.jpegData(compressionQuality: 1) else { return }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return }
    let filePath = directory.appendingPathComponent("userProfile.jpg")
    do {
        try data.write(to: filePath)
        print("Image saved successfully!")
    } catch {
        print("Error saving image: \(error.localizedDescription)")
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
            print("Image does not exist at path.")
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
                if let profileUIImage = profileUIImage {
                    saveImage(image: profileUIImage)
                }
                saveUserName(name: userName)
                presentationMode.wrappedValue.dismiss() // Navigate back
            }
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
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
