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
    @State private var navigateToPostView: Bool = false

    var body: some View {
        NavigationStack {
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
                                    navigateToPostView = true
                                }
                            }
                        }
                }
                .navigationDestination(isPresented: $navigateToPostView) {
                    if let image = selectedImage {
                        PostView(image: image)
                    } else {
                        Text("⚠️ No image available")
                    }
                }
            }
        }
    }
}
