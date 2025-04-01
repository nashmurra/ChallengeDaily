//
//  ContentView.swift
//  TodaysChallenge
//
//  Created by HPro2 on 1/24/25.
//

import FirebaseAuth
import PhotosUI
import SwiftUI

struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    @State private var showCamera: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var navigateToPostView: Bool = false

    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.white)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.darkBlueColor) // Set disabled tabs to red
    }


    var body: some View {

        NavigationStack {
            if userID == "" {
                AuthView()
            } else {

                ZStack {
                    
                    Color.white.ignoresSafeArea(.all)

                    //Color.black.opacity(0.2).ignoresSafeArea()
                    
                    TabView {

                        MainView()
                            //.preferredColorScheme(.dark)
                            .tabItem {
                                Label("Home", systemImage: "house.fill")
                            }

                        DetailView()
                           // .preferredColorScheme(.dark)
                            .tabItem {
                                Label("Explore", systemImage: "target")
                            }

                        
                        ChallengeDashboardView()
                           //.preferredColorScheme(.dark)
                            .tabItem {
                                Label("Challenge", systemImage: "star.fill")
                            }
                        
                        ProfileView()
                            //.preferredColorScheme(.dark)
                            .tabItem {
                                Label("Profile", systemImage: "person.fill")
                            }
                    }
                    .accentColor(Color.pinkColor)
                    .background()
                    .preferredColorScheme(.dark)
                    

                }
            }

        }
    }
}
