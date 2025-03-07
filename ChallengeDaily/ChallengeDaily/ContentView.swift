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
    //@Binding var currentViewShowing: String
    
    // View Properties
    @State private var showSignup: Bool = false
    @State private var showCamera: Bool = false
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        if userID == "" {
            AuthView()
        } else {
            ZStack {
                // Tab View
                TabView {
                    
                    MainView()
                        .preferredColorScheme(.dark)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                    
                    AchievementsView()
                        .preferredColorScheme(.dark)
                        .tabItem {
                            Label("Achievements", systemImage: "star.fill")
                        }
                    
                }
                
                // Floating Camera Button
                VStack {
                    Spacer() // Push to the bottom
                    Button(action: {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            // Open Camera
                            showCamera = true
                        } else {
                            print("Camera not available")
                        }

                        
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .background(Color.whiteText)  // Set button background to green
                            .foregroundColor(.black)  // Set icon color to black
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .offset(y: -20) // Raise above the Tab Bar
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView(selectedImage: $selectedImage)
            }
            .preferredColorScheme(.dark) // Applies dark mode globally
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
                parent.selectedImage = image
            } else if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}



