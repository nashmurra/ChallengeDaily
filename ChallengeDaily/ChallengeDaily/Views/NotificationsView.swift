//
//  NotificationsView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 3/24/25.
//
import SwiftUI
import FirebaseFirestore
import UserNotifications

struct NotificationsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("uid") var userID: String = ""
    @State private var masterToggle: Bool = false
    @State private var notifications: [String: Bool] = [
        "Friend Requests": false,
        "Friends' Posts": false,
        "Comments": false,
        "Likes": false,
        "Streak Warnings": false,
        "Achievements": false
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Notification Settings")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 40)
                            .padding(.horizontal, 24)
                        
                        HStack {
                            Text("Notifications")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .semibold))
                            Spacer()
                            Toggle("", isOn: $masterToggle.animation())
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                                .onChange(of: masterToggle) { newValue in
                                    if newValue {
                                        requestNotificationPermission()
                                    } else {
                                        // Turn off all individual toggles
                                        for key in notifications.keys {
                                            notifications[key] = false
                                        }
                                        saveNotificationsToFirestore()
                                        // Remove all pending notifications
                                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                    }
                                }
                        }
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 24)
                        
                        if masterToggle {
                            VStack(spacing: 16) {
                                ForEach(notifications.keys.sorted(), id: \.self) { key in
                                    HStack {
                                        Text(key)
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                        Spacer()
                                        Toggle("", isOn: Binding(
                                            get: { self.notifications[key] ?? false },
                                            set: { newValue in
                                                self.notifications[key] = newValue
                                                saveNotificationsToFirestore()
                                                if newValue {
                                                    scheduleNotification(for: key)
                                                }
                                            }
                                        ))
                                        .labelsHidden()
                                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.4))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.horizontal, 24)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                }
                            }
                            .padding(.top, 20)
                            .animation(.easeInOut(duration: 0.5), value: masterToggle)
                        }

                        Spacer().frame(height: 50)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadNotificationsFromFirestore()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
            }
        }
    }

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
                    self.masterToggle = savedNotifications.values.contains(true)
                }
            }
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }

    func scheduleNotification(for key: String) {
        let content = UNMutableNotificationContent()
        content.title = "You have a new \(key)"
        content.body = "This is a notification about your \(key.lowercased())."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: key, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("DEBUG: Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("DEBUG: \(key) notification scheduled successfully")
            }
        }
    }
}

