//
//  FriendRequestsView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 4/7/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import UserNotifications

struct FriendRequestsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("uid") var userID: String = ""
    @State private var receivedRequests: [UserProfile] = []
    @State private var sentRequests: [UserProfile] = []

    var body: some View {
        NavigationStack {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        Text("Friend Requests")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .multilineTextAlignment(.center)

                        VStack(spacing: 15) {
                            Text("Sent")
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            if sentRequests.isEmpty {
                                Text("No sent requests.")
                                    .foregroundColor(.white.opacity(0.6))
                            } else {
                                ForEach(sentRequests) { user in
                                    requestRow(for: user, isReceived: false)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)

                        Divider().background(Color.white.opacity(0.3)).padding(.horizontal)

                        VStack(spacing: 15) {
                            Text("Received")
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            if receivedRequests.isEmpty {
                                Text("No received requests.")
                                    .foregroundColor(.white.opacity(0.6))
                            } else {
                                ForEach(receivedRequests) { user in
                                    requestRow(for: user, isReceived: true)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity)
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
            .onAppear {
                loadFriendRequests()
            }
        }
    }

    private func requestRow(for user: UserProfile, isReceived: Bool) -> some View {
        HStack {
            AsyncImage(url: URL(string: user.profilePic)) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.circle.fill")
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())

            Text(user.username)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium))
                .padding(.leading, 10)

            Spacer()

            if isReceived {
                Button(action: {
                    acceptFriendRequest(from: user)
                }) {
                    Text("Accept")
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            } else {
                Button(action: {
                    cancelFriendRequest(to: user)
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }

    private func loadFriendRequests() {
        let db = Firestore.firestore()

        db.collection("friendRequests")
            .whereField("receiverId", isEqualTo: userID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, _ in
                let senderIDs = snapshot?.documents.compactMap { $0.data()["senderId"] as? String } ?? []
                fetchUserProfiles(userIDs: senderIDs) { users in
                    self.receivedRequests = users
                    sendNotificationIfEnabled(for: users, isReceived: true)
                }
            }

        db.collection("friendRequests")
            .whereField("senderId", isEqualTo: userID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, _ in
                let receiverIDs = snapshot?.documents.compactMap { $0.data()["receiverId"] as? String } ?? []
                fetchUserProfiles(userIDs: receiverIDs) { users in
                    self.sentRequests = users
                }
            }
    }

    private func acceptFriendRequest(from user: UserProfile) {
        let db = Firestore.firestore()
        let currentUserRef = db.collection("users").document(userID)
        let senderRef = db.collection("users").document(user.id)

        currentUserRef.updateData(["friends": FieldValue.arrayUnion([user.id])])
        senderRef.updateData(["friends": FieldValue.arrayUnion([userID])])

        db.collection("friendRequests")
            .whereField("senderId", isEqualTo: user.id)
            .whereField("receiverId", isEqualTo: userID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, _ in
                snapshot?.documents.forEach { $0.reference.updateData(["status": "accepted"]) }
                receivedRequests.removeAll { $0.id == user.id }
                sendAcceptedRequestNotification(for: user)
            }
    }

    private func cancelFriendRequest(to user: UserProfile) {
        let db = Firestore.firestore()
        db.collection("friendRequests")
            .whereField("senderId", isEqualTo: userID)
            .whereField("receiverId", isEqualTo: user.id)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, _ in
                snapshot?.documents.forEach { $0.reference.delete() }
                sentRequests.removeAll { $0.id == user.id }
            }
    }

    private func fetchUserProfiles(userIDs: [String], completion: @escaping ([UserProfile]) -> Void) {
        let db = Firestore.firestore()
        var profiles: [UserProfile] = []
        let group = DispatchGroup()

        for id in userIDs {
            group.enter()
            db.collection("users").document(id).getDocument { document, _ in
                if let document = document, let data = document.data() {
                    profiles.append(UserProfile(
                        id: id,
                        username: data["username"] as? String ?? "",
                        profilePic: data["profilePic"] as? String ?? ""
                    ))
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(profiles)
        }
    }

    private func sendNotificationIfEnabled(for users: [UserProfile], isReceived: Bool) {
        for user in users {
            let content = UNMutableNotificationContent()
            content.title = isReceived ? "New Friend Request" : "Friend Request Sent"
            content.body = "You have a new friend request from \(user.username)"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "\(isReceived ? "received" : "sent")_\(user.id)", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }

    private func sendAcceptedRequestNotification(for user: UserProfile) {
        let content = UNMutableNotificationContent()
        content.title = "Friend Request Accepted"
        content.body = "\(user.username) accepted your friend request!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "accepted_\(user.id)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
