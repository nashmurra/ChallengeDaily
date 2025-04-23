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
    @State private var showPreferences = false
    @State private var showNotifications = false
    @State private var showPrivacy = false
    @State private var showAbout = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Settings")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top, 60)
                    
                    List {
                        settingsSection(title: "Settings") {
                            SettingsButton(title: "Privacy", icon: "lock.fill") { showPrivacy = true }
                            SettingsButton(title: "Notifications", icon: "bell.fill") { showNotifications = true }
                        }
                        
                        settingsSection(title: "About") {
                            SettingsButton(title: "Share", icon: "square.and.arrow.up") {
                                let appURL = URL(string: "https://apps.apple.com/app/your-app-id")!
                                let activityVC = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let rootVC = windowScene.windows.first?.rootViewController {
                                    rootVC.present(activityVC, animated: true, completion: nil)
                                }
                            }
                            
                            SettingsButton(title: "About", icon: "info.circle") { showAbout = true }
                            
                            SettingsButton(title: "Rate", icon: "hand.thumbsup.fill") {
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
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation {
                                            userID = ""
                                        }
                                    }
                                } catch let signOutError as NSError {
                                    print("Error signing out: %@", signOutError)
                                }
                            }) {
                                Text("LOG OUT")
                                    .foregroundColor(.red)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }

                        }
                        .listRowBackground(Color.clear)
                        
                        
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationDestination(isPresented: $showPreferences) { PreferencesView() }
            .navigationDestination(isPresented: $showPrivacy) { PrivacyView(userID: userID) }
            .navigationDestination(isPresented: $showNotifications) { NotificationsView(userID: userID) }
            .navigationDestination(isPresented: $showAbout) { AboutView() }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    // MARK: - Reusable Settings Section with Transparent Background
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        Section(header: Text(title).foregroundColor(.white)) {
            content()
        }
        .listRowBackground(Color.white.opacity(0.1).blur(radius: 1))
    }

    // MARK: - Reusable Settings Button
    struct SettingsButton: View {
        let title: String
        let icon: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .frame(width: 24)
                    Text(title)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

