//
//  SocialView.swift
//  ChallengeDaily
//
//  Created by Jonathan on 2/20/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct UserProfile: Identifiable {
    var id: String
    var username: String
    var profilePic: String
}

struct SocialView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    @State private var friends: [UserProfile] = []
    @State private var friendRequests: [UserProfile] = []
    @State private var recommendedFriends: [UserProfile] = []
    @State private var outgoingRequests: [String] = []
    @AppStorage("uid") var userID: String = ""
    @StateObject var userViewModel = UserViewModel()
    @State private var showPrivateProfileAlert = false
    @State private var privateProfileUsername = ""
    @State private var selectedUserID = ""
    
    var filteredProfiles: [UserProfile] {
        searchText.isEmpty ? recommendedFriends :
        recommendedFriends.filter { $0.username.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        Spacer().frame(height: 20)
                        searchBar

                        if searchText.isEmpty {
                            friendsSection
                            recommendedTitle
                            friendsList
                        } else {
                            searchResults
                        }
                    }
                    .padding(.bottom, 40)
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FriendRequestsView()) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
            }
            .onAppear {
                loadFriends()
                loadRecommendedFriends()
                loadFriendRequests()
                loadOutgoingFriendRequests()
            }
            .alert("Private Account", isPresented: $showPrivateProfileAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You can't view \(privateProfileUsername)'s account because it's private. Send a friend request to connect.")
            }
            .navigationDestination(isPresented: Binding(
                get: { !selectedUserID.isEmpty },
                set: { _ in selectedUserID = "" }
            )) {
                UserProfileView(userID: selectedUserID)
            }
        }
    }

    // MARK: - Subviews
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search...", text: $searchText)
                .foregroundColor(.white)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
    }

    private var friendsSection: some View {
        VStack {
            Text("Your Friends")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)

            if friends.isEmpty {
                Text("You have no friends yet.")
                    .foregroundColor(.white.opacity(0.6))
                    .padding()
            } else {
                let columns = [
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 20)
                ]

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(friends) { friend in
                        Button(action: {
                            selectedUserID = friend.id
                        }) {
                            VStack(spacing: 8) {
                                AsyncImage(url: URL(string: friend.profilePic)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                }
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())

                                Text(friend.username)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            .frame(width: 95, height: 100)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var recommendedTitle: some View {
        Text("Recommended Friends")
            .font(.title)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
    }

    private var friendsList: some View {
        VStack(spacing: 10) {
            ForEach(filteredProfiles) { profile in
                friendRow(for: profile)
            }
        }
        .padding(.horizontal)
    }

    private var searchResults: some View {
        VStack(spacing: 10) {
            ForEach(filteredProfiles) { profile in
                friendRow(for: profile)
            }
        }
        .padding(.horizontal)
    }

    private func friendRow(for user: UserProfile) -> some View {
        Button(action: {
            checkProfilePrivacyBeforeNavigation(user: user)
        }) {
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

                if friends.contains(where: { $0.id == user.id }) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.green)
                } else if friendRequests.contains(where: { $0.id == user.id }) || outgoingRequests.contains(user.id) {
                    Text("Pending")
                        .foregroundColor(.yellow)
                        .font(.caption)
                } else {
                    Button(action: {
                        sendFriendRequest(to: user)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.pink)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Privacy Check Function
    
    private func checkProfilePrivacyBeforeNavigation(user: UserProfile) {
        // Always allow navigation to your own profile
        if user.id == userID {
            selectedUserID = user.id
            return
        }
        
        // Check if already friends
        if friends.contains(where: { $0.id == user.id }) {
            selectedUserID = user.id
            return
        }
        
        let db = Firestore.firestore()
        
        // Check if account is private
        db.collection("users").document(user.id).getDocument { document, error in
            if let document = document, document.exists {
                let isPrivate = document.data()?["isPrivate"] as? Bool ?? false
                
                if isPrivate {
                    // Show alert instead of navigating
                    privateProfileUsername = user.username
                    showPrivateProfileAlert = true
                } else {
                    // Not private, allow navigation
                    selectedUserID = user.id
                }
            }
        }
    }

    // MARK: - Firebase Functions (unchanged)
    
    private func loadFriends() {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, let data = document.data(), let friendIDs = data["friends"] as? [String] {
                fetchUserProfiles(userIDs: friendIDs) { users in
                    self.friends = users.sorted { $0.username.lowercased() < $1.username.lowercased() }
                }
            }
        }
    }

    private func loadRecommendedFriends() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in
            if let documents = snapshot?.documents {
                let users = documents.compactMap { doc -> UserProfile? in
                    let data = doc.data()
                    let id = doc.documentID
                    guard id != self.userID else { return nil }
                    return UserProfile(
                        id: id,
                        username: data["username"] as? String ?? "",
                        profilePic: data["profilePic"] as? String ?? ""
                    )
                }
                self.recommendedFriends = users.sorted { $0.username.lowercased() < $1.username.lowercased() }
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
                    let senderIDs = documents.compactMap { $0.data()["senderId"] as? String }
                    fetchUserProfiles(userIDs: senderIDs) { users in
                        self.friendRequests = users
                    }
                }
            }
    }

    private func loadOutgoingFriendRequests() {
        let db = Firestore.firestore()
        db.collection("friendRequests")
            .whereField("senderId", isEqualTo: userID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    let receiverIDs = documents.compactMap { $0.data()["receiverId"] as? String }
                    self.outgoingRequests = receiverIDs
                }
            }
    }

    private func sendFriendRequest(to user: UserProfile) {
        let db = Firestore.firestore()

        db.collection("friendRequests")
            .whereField("senderId", isEqualTo: userID)
            .whereField("receiverId", isEqualTo: user.id)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot, snapshot.isEmpty else {
                    return
                }

                let requestData: [String: Any] = [
                    "senderId": userID,
                    "senderName": userViewModel.username,
                    "receiverId": user.id,
                    "receiverName": user.username,
                    "status": "pending",
                    "timestamp": Timestamp(date: Date())
                ]

                db.collection("friendRequests").addDocument(data: requestData) { error in
                    if error == nil {
                        friendRequests.append(user)
                        outgoingRequests.append(user.id)
                    }
                }
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

import SwiftUI
import FirebaseFirestore

struct UserProfileView: View {
    let userID: String
    @Environment(\.presentationMode) var presentationMode
    @State private var profileImage: UIImage?
    @State private var username: String = "Username"
    @State private var email: String = "user@example.com"
    @State private var friendCount: Int = 0
    @State private var isPrivateAccount: Bool = false
    @State private var isFriend: Bool = false
    @State private var showPrivateAccountAlert: Bool = false
    @StateObject private var postViewModel = PostViewModel()
    @AppStorage("uid") var currentUserID: String = ""
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
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
                
                if canViewProfile {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            headerView
                            userInfoDetails
                            
                            // Posts grid - using the original style
                            if !postViewModel.viewModelPosts.isEmpty {
                                LazyVGrid(columns: columns, spacing: 1) {
                                    ForEach(postViewModel.viewModelPosts) { post in
                                        NavigationLink {
                                            PostDetailView(post: post)
                                                .navigationBarBackButtonHidden(true)
                                        } label: {
                                            if let uiImage = decodeBase64ToImage(post.image) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: (UIScreen.main.bounds.width / 3) - 1,
                                                           height: (UIScreen.main.bounds.width / 3) - 1)
                                                    .clipped()
                                            } else {
                                                Rectangle()
                                                    .foregroundColor(.gray)
                                                    .frame(width: (UIScreen.main.bounds.width / 3) - 1,
                                                           height: (UIScreen.main.bounds.width / 3) - 1)
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 8)
                            } else {
                                emptyStateView
                            }
                        }
                        .padding(.bottom, 20)
                    }
                } else {
                    privateAccountView
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
            .alert("Private Account", isPresented: $showPrivateAccountAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You can't view \(username)'s account because it's private.")
            }
            .onAppear {
                fetchUserProfile()
                checkFriendshipStatus()
                postViewModel.fetchPostsForUser(userID: userID)
            }
        }
    }
    
    // MARK: - Subviews (unchanged from previous implementation)
    private var headerView: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Group {
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .foregroundColor(.gray)
                            }
                        }
                    )
            }
            .padding(.top, 20)
        }
    }
    
    private var userInfoDetails: some View {
        VStack(spacing: 0) {
            Text(username)
                .font(.title.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
            
            Text("@\(userID.prefix(8))")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 16)
            
            HStack(spacing: 24) {
                VStack {
                    Text("\(postViewModel.viewModelPosts.count)")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                    Text("Posts")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                VStack {
                    Text("\(friendCount)")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                    Text("Friends")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 8)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 8) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.5))
                .padding(.bottom, 4)
            
            Text("No posts yet")
                .foregroundColor(.white)
                .font(.headline)
            
            Text(userID == currentUserID ?
                 "Complete challenges to share your first post!" :
                 "This user hasn't posted anything yet!")
                .foregroundColor(.gray)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 40)
    }
    
    private var privateAccountView: some View {
        VStack {
            Image(systemName: "lock.fill")
                .font(.system(size: 50))
                .foregroundColor(.white)
                .padding()
            
            Text("Private Account")
                .font(.title)
                .foregroundColor(.white)
                .padding(.bottom, 8)
            
            Text("This account is private.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
        }
    }
    
    // MARK: - Helper Functions (unchanged)
    private var canViewProfile: Bool {
        if userID == currentUserID {
            return true
        }
        return !isPrivateAccount || (isPrivateAccount && isFriend)
    }
    
    private func checkFriendshipStatus() {
        let db = Firestore.firestore()
        db.collection("users").document(currentUserID).getDocument { document, error in
            if let document = document, document.exists {
                let friends = document.data()?["friends"] as? [String] ?? []
                self.isFriend = friends.contains(userID)
                
                if self.isPrivateAccount && !self.isFriend && self.userID != self.currentUserID {
                    self.showPrivateAccountAlert = true
                }
            }
        }
    }
    
    private func fetchUserProfile() {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userID)
            .getDocument { snapshot, error in
                if let error = error {
                    print("DEBUG: Failed to fetch user data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = snapshot?.data() else {
                    print("DEBUG: No user data found")
                    return
                }
                
                DispatchQueue.main.async {
                    self.username = data["username"] as? String ?? "Username"
                    self.email = data["email"] as? String ?? "No email"
                    self.friendCount = (data["friends"] as? [String])?.count ?? 0
                    self.isPrivateAccount = data["isPrivate"] as? Bool ?? false
                    
                    if let base64String = data["profileImage"] as? String,
                       let imageData = Data(base64Encoded: base64String),
                       let image = UIImage(data: imageData) {
                        self.profileImage = image
                    }
                }
            }
    }
    
    private func decodeBase64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String),
              let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }
}
