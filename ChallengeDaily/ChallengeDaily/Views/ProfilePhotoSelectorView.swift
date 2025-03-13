//
//  ProfilePhotoSelectorView.swift
//  ChallengeDaily
//
//  Created by HPro2 on 3/5/25.
//

import SwiftUI
import FirebaseFirestore

struct ProfilePhotoSelectorView: View {
    @Binding var profileImage: UIImage?
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    var userID: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button(action: {
                    showImagePicker = true
                }) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }

                Button(action: {
                    if let image = selectedImage {
                        uploadImageToFirestore(image)
                    }
                }) {
                    if isUploading {
                        ProgressView()
                    } else {
                        Text("Continue")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("Select Profile Picture")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Upload image as Base64 to Firestore
    func uploadImageToFirestore(_ image: UIImage) {
        isUploading = true
        ImageUploader.uploadImage(image: image) { base64String in
            DispatchQueue.main.async {
                self.isUploading = false
                if let base64String = base64String {
                    saveBase64ToFirestore(base64String)
                } else {
                    print("Failed to encode image")
                }
            }
        }
    }

    // Save Base64 string to Firestore
    func saveBase64ToFirestore(_ base64String: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).setData([
            "profileImage": base64String
        ], merge: true) { error in
            if let error = error {
                print("DEBUG: Failed to save image to Firestore: \(error.localizedDescription)")
            } else {
                print("DEBUG: Image saved to Firestore successfully")
                profileImage = selectedImage
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var profileImage: UIImage? = nil
        var body: some View {
            ProfilePhotoSelectorView(profileImage: $profileImage, userID: "previewUserID")
                .preferredColorScheme(.dark)
        }
    }
    return PreviewWrapper()
}




//import SwiftUI
//
//struct ProfilePhotoSelectorView: View {
//    @State private var showImagePicker = false
//    @State private var selectedImage: UIImage? {
//        didSet { loadImage() }
//    }
//    @State private var profileImage: Image?
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Button {
//                    showImagePicker.toggle()
//                } label: {
//                    if let profileImage = profileImage {
//                        profileImage
//                            .resizable()
//                            .modifier(ProfileImageModifier())
//                            .clipShape(Circle())
//                    } else {
//                        Image(systemName: "plus.circle")
//                            .renderingMode(.template)
//                            .modifier(ProfileImageModifier())
//                    }
//                }
//                .sheet(isPresented: $showImagePicker) {
//                    ImagePicker(selectedImage: $selectedImage)
//                }
//                .padding(.top, 44)
//
//                if profileImage != nil {
//                    Button {
//                        print("DEBUG: Finish registiring user...")
//                    } label: {
//                        Text("Continue")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(width: 340, height: 50)
//                            .background(Color(.systemBackground))
//                            .clipShape(Capsule())
//                            .padding()
//                    }
//                    .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
//                }
//            }
//            .navigationTitle("Select Profile Picture")
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.white)
//                        Text("")
//                            .foregroundColor(.white)
//                    }
//                }
//            }
//        }
//    }
//
//    func loadImage() {
//        guard let selectedImage = selectedImage else { return }
//        profileImage = Image(uiImage: selectedImage)
//    }
//}
//
//private struct ProfileImageModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .scaledToFit()
//            .frame(width: 180, height: 180)
//    }
//}

