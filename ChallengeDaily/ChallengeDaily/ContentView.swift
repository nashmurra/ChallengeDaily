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
    
    var mainView = MainView()
    var socialView = SocialView()
    var settingsView = SettingsView()
    var challengeView = ChallengeDashboardView()
    var profileView = ProfileView()



    var body: some View {

        NavigationStack {
            if userID == "" {
                StartView().preferredColorScheme(.dark)
            } else {

                ZStack {
                    
                    Color.white.ignoresSafeArea(.all)

                    //Color.black.opacity(0.2).ignoresSafeArea()
                    
                    TabView {
                        mainView
                            .tabItem {
                                Label("Home", systemImage: "house.fill")
                            }

                        socialView
                            .tabItem {
                                Label("Friends", systemImage: "shared.with.you")
                            }

                        settingsView
                            .tabItem {
                                Label("Explore", systemImage: "target")
                            }

                        challengeView
                            .tabItem {
                                Label("Challenge", systemImage: "star.fill")
                            }

                        profileView
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
