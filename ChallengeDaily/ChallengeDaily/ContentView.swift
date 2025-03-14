//
//  ContentView.swift
//  TodaysChallenge
//
//  Created by HPro2 on 1/24/25.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import PhotosUI

struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    @State private var showCamera: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var showPostView: Bool = false

    var body: some View {
        if userID == "" {
            AuthView()
        } else {
            
            ZStack {
                TabView {
                    MainView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }

                    AchievementsView()
                        .tabItem {
                            Label("Achievements", systemImage: "star.fill")
                        }
                }

                VStack {
                    Spacer()
                    Button(action: {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            showCamera = true
                        } else {
                            print("Camera not available")
                        }
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .offset(y: -20)
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView(selectedImage: $selectedImage)
                    .onDisappear {
                        print("📸 selectedImage after camera: \(String(describing: selectedImage))")
                        if selectedImage != nil {
                            DispatchQueue.main.async {
                                showPostView = true
                            }
                        }
                    }
            }
            .fullScreenCover(isPresented: Binding(
                get: { showPostView && selectedImage != nil },
                set: { showPostView = $0 }
            )) {
                if let image = selectedImage {
                    PostView(image: image)
                } else {
                    Text("⚠️ No image available")
                }
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                print("✅ Captured edited image!")
                parent.selectedImage = image
            } else if let image = info[.originalImage] as? UIImage {
                print("✅ Captured original image!")
                parent.selectedImage = image
            } else {
                print("❌ No image captured!")
            }
            print("📸 selectedImage now: \(String(describing: parent.selectedImage))")
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

