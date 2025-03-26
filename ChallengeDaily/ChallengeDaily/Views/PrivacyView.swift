//
//  PrivacyView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 3/24/25.
//

import SwiftUI
import FirebaseFirestore

struct PrivacyView: View {
    @State private var isPrivate: Bool = false
    @State private var findFriendsWithContacts: Bool = false
    @State private var showBlockedUsers = false
    var userID: String  // User ID for Firestore storage

    var body: some View {
        ZStack {
            Image("BackgroundScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Title
                Text("Privacy")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 60)
                
                VStack(spacing: 15) {
                    privacyToggle(title: "Private Account", description: "Only approved followers can see your content.", isOn: $isPrivate)
                    privacyToggle(title: "Find Friends with Contacts", description: "Find and connect with friends using your contacts.", isOn: $findFriendsWithContacts)
                    
                    // Blocked Users Button
                    Button(action: { showBlockedUsers = true }) {
                        HStack {
                            Text("Blocked Users")
                                .font(.title3)
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Save Settings Button
                Button(action: {
                    savePrivacySettings()
                }) {
                    Text("Save Settings")
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(17)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.blue.opacity(0.8))
                        )
                        .padding(.horizontal, 25)
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showBlockedUsers) {
            BlockedUsersView()
        }
        .onAppear {
            loadPrivacySettings()
        }
    }
    
    // Custom Toggle View
    func privacyToggle(title: String, description: String, isOn: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Toggle(isOn: isOn) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            
            Text(description)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    // Save privacy settings to Firestore
    func savePrivacySettings() {
        let db = Firestore.firestore()
        db.collection("users").document(userID).setData([
            "isPrivate": isPrivate,
            "findFriendsWithContacts": findFriendsWithContacts
        ], merge: true) { error in
            if let error = error {
                print("DEBUG: Failed to save privacy settings: \(error.localizedDescription)")
            } else {
                print("DEBUG: Privacy settings saved successfully")
            }
        }
    }

    // Load privacy settings from Firestore
    func loadPrivacySettings() {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                isPrivate = data["isPrivate"] as? Bool ?? false
                findFriendsWithContacts = data["findFriendsWithContacts"] as? Bool ?? false
            }
        }
    }
}

