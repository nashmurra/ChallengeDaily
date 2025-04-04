//
//  NotificationsView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 3/24/25.
//

import SwiftUI
import FirebaseFirestore

struct NotificationsView: View {
    @State private var notifications: [String: Bool] = [
        "Friend Requests": true,
        "New Followers": true,
        "Friends' Posts": false,
        "Tags": true,
        "Comments": true,
        "Likes": false,
        "Streak Warnings": true,
        "Achievements": true
    ]
    var userID: String
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 30) { // Increased spacing
                    // Title
                    Text("Notification Settings")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 50)
                        .padding(.horizontal)

                    Spacer().frame(height: 10)

                    // Toggle settings
                    VStack(spacing: 20) { // More spacing between toggles
                        ForEach(notifications.keys.sorted(), id: \.self) { key in
                            Toggle(isOn: Binding(
                                get: { self.notifications[key] ?? false },
                                set: { newValue in
                                    self.notifications[key] = newValue
                                    saveNotificationsToFirestore() // Auto-save on toggle
                                }
                            )) {
                                Text(key)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .medium))
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                loadNotificationsFromFirestore() // Load user settings on appear
            }
        }
    }
    
    // Save settings to Firestore
    func saveNotificationsToFirestore() {
        let db = Firestore.firestore()
        db.collection("users").document(userID).setData([
            "notifications": notifications
        ], merge: true) { error in
            if let error = error {
                print("DEBUG: Failed to save notifications: \(error.localizedDescription)")
            } else {
                print("DEBUG: Notifications saved successfully")
            }
        }
    }

    // Load user notification preferences from Firestore
    func loadNotificationsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("DEBUG: Failed to fetch notifications: \(error.localizedDescription)")
                return
            }
            if let data = document?.data(), let savedNotifications = data["notifications"] as? [String: Bool] {
                DispatchQueue.main.async {
                    self.notifications = savedNotifications
                }
            }
        }
    }
}
