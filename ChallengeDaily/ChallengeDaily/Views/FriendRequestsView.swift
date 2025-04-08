//
//  FriendRequestsView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 4/7/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct FriendRequestsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("uid") var userID: String = ""
    @State private var friendRequests: [UserProfile] = []

    var body: some View {
        NavigationView {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Friend Requests")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    if friendRequests.isEmpty {
                        Spacer()
                        Text("You have no friend requests.")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(friendRequests) { user in
                                    requestRow(for: user)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
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
            .onAppear {
                loadFriendRequests()
            }
        }
    }

    private func requestRow(for user: UserProfile) -> some View {
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
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    let senderIDs = documents.compactMap { $0.data()["senderId"] as? String }
                    fetchUserProfiles(userIDs: senderIDs) { users in
                        self.friendRequests = users
                    }
                }
            }
    }

    private func acceptFriendRequest(from user: UserProfile) {
        let db = Firestore.firestore()

        // Update friend list for both users
        let currentUserRef = db.collection("users").document(userID)
        let senderRef = db.collection("users").document(user.id)

        currentUserRef.updateData([
            "friends": FieldValue.arrayUnion([user.id])
        ])

        senderRef.updateData([
            "friends": FieldValue.arrayUnion([userID])
        ])

        // Update the request status to accepted
        db.collection("friendRequests")
            .whereField("senderId", isEqualTo: user.id)
            .whereField("receiverId", isEqualTo: userID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, error in
                snapshot?.documents.forEach { doc in
                    doc.reference.updateData(["status": "accepted"])
                }
                // Remove from UI
                friendRequests.removeAll { $0.id == user.id }
            }
    }

    private func fetchUserProfiles(userIDs: [String], completion: @escaping ([UserProfile]) -> Void) {
        let db = Firestore.firestore()
        var profiles: [UserProfile] = []
        let group = DispatchGroup()

        for id in userIDs {
            group.enter()
            db.collection("users").document(id).getDocument { document, error in
                if let document = document, let data = document.data() {
                    let profile = UserProfile(
                        id: id,
                        username: data["username"] as? String ?? "",
                        profilePic: data["profilePic"] as? String ?? ""
                    )
                    profiles.append(profile)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(profiles)
        }
    }
}
