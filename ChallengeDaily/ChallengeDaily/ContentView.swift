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
       // UITabBar.appearance().backgroundColor = UIColor(Color.creamColor)
    }

    var body: some View {

        NavigationStack {
            if userID == "" {
                AuthView()
            } else {

                ZStack {

                    //Color.black.opacity(0.2).ignoresSafeArea()
                    
                    TabView {

                        MainView()
                            //.preferredColorScheme(.dark)
                            .tabItem {
                                Label("", systemImage: "house.fill")
                            }

                        SocialView()
                           // .preferredColorScheme(.dark)
                            .tabItem {
                                Label("", systemImage: "magnifyingglass")
                            }

                        ProfileView()
                            //.preferredColorScheme(.dark)
                            .tabItem {
                                Label("", systemImage: "person.crop.circle")
                            }

                        SettingsView()
                           //.preferredColorScheme(.dark)
                            .tabItem {
                                Label("", systemImage: "gear")
                            }
                    }
                    .accentColor(Color.red)
                    .background()
                    .preferredColorScheme(.dark)
                    

                }
            }

        }
    }
}
