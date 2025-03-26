//
//  SettingsView.swift
//  ChallengeDaily
//
//  Created by HPro2 on 2/28/25.
//

import SwiftUI
import FirebaseAuth
import StoreKit

struct SettingsView: View {
    @StateObject var userViewModel = UserViewModel()
        @AppStorage("uid") var userID: String = ""
        @Environment(\.presentationMode) var presentationMode
        @State private var showPastChallenges = false
        @State private var showAchievements = false
        @State private var showPreferences = false
        @State private var showNotifications = false
        @State private var showPrivacy = false
        @State private var isPrivate = false

        @Binding var currentViewShowing: String

        var body: some View {
            NavigationView {
                ZStack {
                    Image("BackgroundScreen")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Settings")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 60)
                        
                        List {
                            Section(header: Text("Features").foregroundColor(.white)) {
                                SettingsButton(title: "Past Challenges") { showPastChallenges = true }
                                SettingsButton(title: "Achievements") { showAchievements = true }
                            }

                            Section(header: Text("Settings").foregroundColor(.white)) {
                                SettingsButton(title: "Privacy") { showPrivacy = true }
                                SettingsButton(title: "Time Zone") { }
                                SettingsButton(title: "Notifications") { showNotifications = true }
                                SettingsButton(title: "Preferences") { showPreferences = true }
                            }

                            Section(header: Text("About").foregroundColor(.white)) {
                                SettingsButton(title: "Share") {
                                    let appURL = URL(string: "https://apps.apple.com/app/your-app-id")!
                                    let activityVC = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
                                    
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let rootVC = windowScene.windows.first?.rootViewController {
                                        rootVC.present(activityVC, animated: true, completion: nil)
                                    }
                                }
                                
                                SettingsButton(title: "About") {
                                    // go to AboutView
                                }
                                
                                SettingsButton(title: "Rate") {
                                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                        SKStoreReviewController.requestReview(in: scene)
                                    }
                                }
                            }

                            Section {
                                Button(action: {
                                    let firebaseAuth = Auth.auth()
                                    do {
                                        try firebaseAuth.signOut()
                                        
                                        withAnimation {
                                            userID = ""
                                            self.currentViewShowing = "login"
                                        }
                                    } catch let signOutError as NSError {
                                        print("Error signing out: %@", signOutError)
                                    }
                                }) {
                                    Text("LOG OUT")
                                        .foregroundColor(.red)
                                        .fontWeight(.heavy)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .background(Color.black.opacity(0.5)) // Adds a slight overlay for readability
                    }
                }
            }
            .navigationDestination(isPresented: $showPastChallenges) { PastChallengesView() }
            .navigationDestination(isPresented: $showAchievements) { AchievementsView() }
            .navigationDestination(isPresented: $showPreferences) { PreferencesView() }
            .navigationDestination(isPresented: $showPrivacy) { PrivacyView(userID: userID) }
            .navigationDestination(isPresented: $showNotifications) { NotificationsView(userID: userID) }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { self.currentViewShowing = "profile" }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }

    // Reusable Button for Settings List
    struct SettingsButton: View {
        let title: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .foregroundColor(.white)
            }
        }
    }
