//
//  ContentView.swift
//  TodaysChallenge
//
//  Created by HPro2 on 1/24/25.
//

import SwiftUI
import SwiftData
import FirebaseAuth

struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    
    // View Properities
    @State private var showSignup: Bool = false
    var body: some View {
        if userID == ""{
            AuthView()
        } else {

                    ZStack {
                        // Tab View
                        TabView {
                            MainView()
                                .tabItem {
                                    Label("Home", systemImage: "house.fill")
                                        .foregroundColor(Color.white)

                                }
                            
                            FeedView()
                                .tabItem {
                                    Label("Feed", systemImage: "person.3.fill")
                                }
                            
                        }
                        
                        // Floating Camera Button
                        VStack {
                            Spacer() // Push to the bottom
                            Button(action: {
                                print("Camera button tapped!")
                                // Add your camera action here
                            }) {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding()
                                    .background(Color.accentColor)
                                    .foregroundColor(.black)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            .offset(y: -20) // Raise above the Tab Bar
                        }
                    }
                    .preferredColorScheme(.dark) // Applies dark mode globally
                }
            }
    
}

#Preview {
    ContentView()
}
