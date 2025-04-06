//
//  SocialView.swift
//  ChallengeDaily
//
//  Created by Jonathan on 2/20/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SocialView: View {
    @StateObject var userViewModel = UserViewModel()
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    @State private var friends: [String] = []
    @State private var friendRequests: [String] = []
    
    let fakeProfiles = [
        "KongSun", "Bob Smith", "Charlie Brown",
        "Matthew Li", "Emma Watson", "Frank White"
    ]

    var filteredProfiles: [String] {
        searchText.isEmpty ? fakeProfiles :
        fakeProfiles.filter { $0.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {
        NavigationView {
            ZStack {
                backgroundImage
                mainContent
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.whiteText)
                            Text("")
                                .foregroundColor(.whiteText)
                        }
                    }
                }
            }
            .onAppear {
                loadFriends()
                loadFriendRequests()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var backgroundImage: some View {
        Image("appBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea(.all)
    }
    
    private var mainContent: some View {
        VStack {
            Spacer().frame(height: 20)
            searchBar
            friendsTitle
            friendsList
            Spacer()
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search...", text: $searchText)
                .foregroundColor(.white)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)

            if !searchText.isEmpty {
                clearSearchButton
            }
        }
        .padding(10)
        .background(Color.backgroundLight)
        .cornerRadius(8)
        .padding(.horizontal)
    }
    
    private var clearSearchButton: some View {
        Button(action: { searchText = "" }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
        }
    }
    
    private var friendsTitle: some View {
        Text("Recommended Friends")
            .font(.title)
            .foregroundColor(.whiteText)
            .fontWeight(.bold)
            .padding(.top, 10)
    }
    
    private var friendsList: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(filteredProfiles, id: \.self) { profile in
                    friendRow(for: profile)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func friendRow(for profile: String) -> some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
            
            Text(profile)
                .foregroundColor(.whiteText)
                .font(.system(size: 18, weight: .medium))
                .padding(.leading, 10)

            Spacer()

            // Show different button states based on friend status
            if friends.contains(profile) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.green)
            } else if friendRequests.contains(profile) {
                Text("Pending")
                    .foregroundColor(.yellow)
                    .font(.caption)
            } else {
                Button(action: {
                    sendFriendRequest(to: profile)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.pinkColor)
                }
            }
        }
        .padding()
        .background(Color.backgroundLight)
        .cornerRadius(10)
    }
    
    // MARK: - Firebase Functions
    
    private func loadFriends() {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                if let friendsList = document.data()?["friends"] as? [String] {
                    DispatchQueue.main.async {
                        self.friends = friendsList
                    }
                }
            }
        }
    }
    
    private func loadFriendRequests() {
        let db = Firestore.firestore()
        db.collection("friendRequests")
            .whereField("receiverId", isEqualTo: userID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    let requests = documents.compactMap { $0.data()["senderName"] as? String }
                    DispatchQueue.main.async {
                        self.friendRequests = requests
                    }
                }
            }
    }
    
    private func sendFriendRequest(to friendName: String) {
        let db = Firestore.firestore()
        let requestData: [String: Any] = [
            "senderId": userID,
            "senderName": userViewModel.username,
            "receiverName": friendName,
            "status": "pending",
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("friendRequests").addDocument(data: requestData) { error in
            if let error = error {
                print("Error sending friend request: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    friendRequests.append(friendName)
                }
            }
        }
    }
}
