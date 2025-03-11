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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                List {
                    
                    Section(header: Text("Features")) {
                        Button (action: {
                            showPastChallenges = true
                        }) {
                            Text("Past Challenges")
                                .foregroundColor(.white)
                        }
                        
                        Button (action: {
                            showAchievements = true
                        }) {
                            Text("Achievements")
                                .foregroundColor(.white)
                        }
                    }
                    
                    Section(header: Text("Settings")) {
                        Button {
                        } label: {
                            Text("Privacy")
                                .foregroundColor(.white)
                        }
                        
                        Button {
                        } label: {
                            Text("Time Zone")
                                .foregroundColor(.white)
                        }
                        
                        Button {
                        } label: {
                            Text("Notifications")
                                .foregroundColor(.white)
                        }
                    }
                    
                    Section(header: Text("About")) {
                        Button {
                            let appURL = URL(string: "https://apps.apple.com/app/your-app-id")!
                            let activityVC = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
                            
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootVC = windowScene.windows.first?.rootViewController {
                                rootVC.present(activityVC, animated: true, completion: nil)
                            }
                        } label: {
                            Text("Share")
                                .foregroundColor(.white)
                        }
                        
                        Button {
                        } label: {
                            Text("About")
                                .foregroundColor(.white)
                        }
                        
                        Button {
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        } label: {
                            Text("Rate")
                                .foregroundColor(.white)
                        }
                        
                    }
                    
                    Section() {
                        Button(action: {
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                withAnimation {
                                    userID = ""
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
                .listStyle(GroupedListStyle())
                .navigationTitle("Settings")
            }
            .navigationDestination(isPresented: $showPastChallenges) {
                PastChallengesView()
            }
            .navigationDestination(isPresented: $showAchievements) {
                AchievementsView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                        Text("")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
