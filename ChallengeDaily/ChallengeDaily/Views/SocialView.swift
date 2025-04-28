//
//  SocialView.swift
//  ChallengeDaily
//
//  Created by Jonathan on 2/20/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import Contacts
import UserNotifications

struct UserProfile: Identifiable {
    var id: String
    var username: String
    var profilePic: String
    var phoneNumber: String?
    var isContact: Bool = false
}

struct SocialView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    @State private var friends: [UserProfile] = []
    @State private var friendRequests: [UserProfile] = []
    @State private var recommendedFriends: [UserProfile] = []
    @State private var outgoingRequests: [String] = []
    @State private var contactsMatched: [String] = []
    @State private var isLoadingContacts = false
    @AppStorage("uid") var userID: String = ""
    //private let userViewModel = UserViewModel.shared
    @StateObject userViewModel = new UserViewModel()
    @State private var showPrivateProfileAlert = false
    @State private var privateProfileUsername = ""
    @State private var selectedUserID = ""
    @State private var friendListener: ListenerRegistration?
    @State private var requestListener: ListenerRegistration?
    @State private var showRemoveFriendAlert = false
    @State private var friendToRemove: UserProfile?
    
    private let contactStore = CNContactStore()
    
    var filteredProfiles: [UserProfile] {
        let filtered = searchText.isEmpty ? recommendedFriends :
                     recommendedFriends.filter { $0.username.lowercased().contains(searchText.lowercased()) }
        
        return filtered.sorted {
            if $0.isContact == $1.isContact {
                return $0.username < $1.username
            }
            return $0.isContact && !$1.isContact
        }
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
                        
                        // Search Bar
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
                        
                        if searchText.isEmpty {
                            // Friends Section
                            VStack {
                                Text("Your Friends")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
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
                                            VStack(spacing: 8) {
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
                                                
                                                Button(action: {
                                                    friendToRemove = friend
                                                    showRemoveFriendAlert = true
                                                }) {
                                                    Text("Remove")
                                                        .font(.caption2)
                                                        .foregroundColor(.red)
                                                        .padding(5)
                                                        .background(Color.red.opacity(0.2))
                                                        .cornerRadius(5)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // Contacts Section
                            if !contactsMatched.isEmpty {
                                Text("Contacts")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                            }
                            
                            // Recommended Friends
                            Text("Recommended Friends")
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.top, 10)
                            
                            // Friends List
                            VStack(spacing: 10) {
                                ForEach(filteredProfiles) { profile in
                                    HStack {
                                        ZStack(alignment: .bottomTrailing) {
                                            AsyncImage(url: URL(string: profile.profilePic)) { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image.resizable()
                                                case .failure:
                                                    Image(systemName: "person.circle.fill")
                                                        .resizable()
                                                case .empty:
                                                    ProgressView()
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            
                                            if profile.isContact {
                                                Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 12))
                                                    .offset(x: 5, y: 5)
                                            }
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(profile.username)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18, weight: .medium))
                                            
                                            if profile.isContact {
                                                Text("From contacts")
                                                    .font(.caption2)
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        if friends.contains(where: { $0.id == profile.id }) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.green)
                                        } else if let request = friendRequests.first(where: { $0.id == profile.id }) {
                                            Button(action: {
                                                acceptFriendRequest(from: request)
                                            }) {
                                                Text("Accept")
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(Color.green)
                                                    .cornerRadius(8)
                                            }
                                        } else if outgoingRequests.contains(profile.id) {
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
                                                    .foregroundColor(.pink)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        checkProfilePrivacyBeforeNavigation(user: profile)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            // Search Results
                            VStack(spacing: 10) {
                                ForEach(filteredProfiles) { profile in
                                    HStack {
                                        ZStack(alignment: .bottomTrailing) {
                                            AsyncImage(url: URL(string: profile.profilePic)) { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image.resizable()
                                                case .failure:
                                                    Image(systemName: "person.circle.fill")
                                                        .resizable()
                                                case .empty:
                                                    ProgressView()
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            
                                            if profile.isContact {
                                                Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 12))
                                                    .offset(x: 5, y: 5)
                                            }
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(profile.username)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18, weight: .medium))
                                            
                                            if profile.isContact {
                                                Text("From contacts")
                                                    .font(.caption2)
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        if friends.contains(where: { $0.id == profile.id }) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.green)
                                        } else if let request = friendRequests.first(where: { $0.id == profile.id }) {
                                            Button(action: {
                                                acceptFriendRequest(from: request)
                                            }) {
                                                Text("Accept")
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(Color.green)
                                                    .cornerRadius(8)
                                            }
                                        } else if outgoingRequests.contains(profile.id) {
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
                                                    .foregroundColor(.pink)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        checkProfilePrivacyBeforeNavigation(user: profile)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 40)
                }
<<<<<<< HEAD
                .padding(.bottom, 30)
=======
                
                if isLoadingContacts {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                }
>>>>>>> c735d23e3f46a9d36620ed2861f242dec0070967
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FriendRequestsView()) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
            }
            .onAppear {
                setupFriendListener()
                setupFriendRequestListener()
                loadRecommendedFriends()
                loadFriendRequests()
                loadOutgoingFriendRequests()
                checkContactsPermission()
            }
            .onDisappear {
                friendListener?.remove()
                requestListener?.remove()
            }
            .alert("Private Account", isPresented: $showPrivateProfileAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You can't view \(privateProfileUsername)'s account because it's private. Send a friend request to connect.")
            }
            .alert("Remove Friend", isPresented: $showRemoveFriendAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Remove", role: .destructive) {
                    if let friend = friendToRemove {
                        removeFriend(friendID: friend.id)
                    }
                }
            } message: {
                if let friend = friendToRemove {
                    Text("Are you sure you want to remove \(friend.username) from your friends?")
                }
            }
            .alert("Contacts Access", isPresented: .constant(CNContactStore.authorizationStatus(for: .contacts) == .denied)) {
                Button("Cancel", role: .cancel) { }
                Button("Settings") {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(settingsUrl)
                }
            } message: {
                Text("Please enable contacts access in Settings to find friends from your contacts.")
            }
            .navigationDestination(isPresented: Binding(
                get: { !selectedUserID.isEmpty },
                set: { _ in selectedUserID = "" }
            )) {
                UserProfileView(userID: selectedUserID)
            }
        }
    }
    
    // MARK: - Contact Matching
    
    private func checkContactsPermission() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .authorized {
            matchContactsWithUsers()
        } else if status == .notDetermined {
            contactStore.requestAccess(for: .contacts) { granted, _ in
                if granted {
                    DispatchQueue.main.async {
                        self.matchContactsWithUsers()
                    }
                }
            }
        }
    }
    
    private func matchContactsWithUsers() {
        isLoadingContacts = true
        contactsMatched.removeAll()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let keys = [CNContactPhoneNumbersKey] as [CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keys)
            var contactNumbers = Set<String>()
            
            do {
                try self.contactStore.enumerateContacts(with: request) { contact, _ in
                    for phone in contact.phoneNumbers {
                        let number = phone.value.stringValue
                        let digits = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                        contactNumbers.insert(digits)
                    }
                }
                
                DispatchQueue.main.async {
                    self.recommendedFriends = self.recommendedFriends.map { user in
                        var user = user
                        if let phone = user.phoneNumber {
                            let userDigits = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                            user.isContact = contactNumbers.contains(userDigits)
                            if user.isContact {
                                self.contactsMatched.append(user.id)
                            }
                        }
                        return user
                    }
                    self.isLoadingContacts = false
                }
            } catch {
                print("Contact matching failed: \(error)")
                DispatchQueue.main.async {
                    self.isLoadingContacts = false
                }
            }
        }
    }
    
    // MARK: - Firebase Helpers
    
    private func setupFriendListener() {
        let db = Firestore.firestore()
        friendListener = db.collection("users").document(userID).addSnapshotListener { document, _ in
            if let document = document, let data = document.data(), let friendIDs = data["friends"] as? [String] {
                fetchUserProfiles(userIDs: friendIDs) { self.friends = $0 }
            }
        }
    }
    
    private func setupFriendRequestListener() {
        let db = Firestore.firestore()
        requestListener = db.collection("friendRequests")
            .whereField("receiverId", isEqualTo: userID)
            .whereField("status", isEqualTo: "pending")
            .addSnapshotListener { snapshot, _ in
                let senderIDs = snapshot?.documents.compactMap { $0.data()["senderId"] as? String } ?? []
                fetchUserProfiles(userIDs: senderIDs) { users in
                    self.friendRequests = users
                }
            }
        
        db.collection("friendRequests")
            .whereField("senderId", isEqualTo: userID)
            .whereField("status", isEqualTo: "pending")
            .addSnapshotListener { snapshot, _ in
                self.outgoingRequests = snapshot?.documents.compactMap { $0.data()["receiverId"] as? String } ?? []
            }
    }
    
    private func checkProfilePrivacyBeforeNavigation(user: UserProfile) {
        if user.id == userID || friends.contains(where: { $0.id == user.id }) {
            selectedUserID = user.id
            return
        }
        
        Firestore.firestore().collection("users").document(user.id).getDocument { document, _ in
            if let document = document, document.exists {
                let isPrivate = document.data()?["isPrivate"] as? Bool ?? false
                if isPrivate {
                    privateProfileUsername = user.username
                    showPrivateProfileAlert = true
                } else {
                    selectedUserID = user.id
                }
            }
        }
    }
    
    private func loadRecommendedFriends() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, _ in
            if let documents = snapshot?.documents {
                let users = documents.compactMap { doc -> UserProfile? in
                    let id = doc.documentID
                    guard id != self.userID else { return nil }
                    let data = doc.data()
                    return UserProfile(
                        id: id,
                        username: data["username"] as? String ?? "",
                        profilePic: data["profilePic"] as? String ?? "",
                        phoneNumber: data["phoneNumber"] as? String
                    )
                }
                let friendIDs = Set(self.friends.map { $0.id })
                self.recommendedFriends = users.filter { !friendIDs.contains($0.id) }
                self.checkContactsPermission()
            }
        }
    }
    
    private func loadFriendRequests() {
        let db = Firestore.firestore()
        db.collection("friendRequests")
            .whereField("receiverId", isEqualTo: userID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, _ in
                if let documents = snapshot?.documents {
                    let senderIDs = documents.compactMap { $0.data()["senderId"] as? String }
                    fetchUserProfiles(userIDs: senderIDs) { self.friendRequests = $0 }
                }
            }
    }
    
    private func loadOutgoingFriendRequests() {
        let db = Firestore.firestore()
        db.collection("friendRequests")
            .whereField("senderId", isEqualTo: userID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, _ in
                if let documents = snapshot?.documents {
                    self.outgoingRequests = documents.compactMap { $0.data()["receiverId"] as? String }
                }
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
                        profilePic: data["profilePic"] as? String ?? "",
                        phoneNumber: data["phoneNumber"] as? String
                    ))
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(profiles.sorted { $0.username < $1.username })
        }
    }
    
    private func sendFriendRequest(to user: UserProfile) {
        let db = Firestore.firestore()
        db.collection("friendRequests")
            .whereField("senderId", isEqualTo: userID)
            .whereField("receiverId", isEqualTo: user.id)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, _ in
                guard let snapshot = snapshot, snapshot.isEmpty else { return }
                
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
                        outgoingRequests.append(user.id)
                        recommendedFriends.removeAll { $0.id == user.id }
                    }
                }
            }
    }
    
    private func removeFriend(friendID: String) {
        let db = Firestore.firestore()
        let batch = db.batch()
        
        let currentUserRef = db.collection("users").document(userID)
        batch.updateData([
            "friends": FieldValue.arrayRemove([friendID])
        ], forDocument: currentUserRef)
        
        let friendRef = db.collection("users").document(friendID)
        batch.updateData([
            "friends": FieldValue.arrayRemove([userID])
        ], forDocument: friendRef)
        
        batch.commit { error in
            if error == nil {
                friends.removeAll { $0.id == friendID }
                fetchUserProfiles(userIDs: [friendID]) { profiles in
                    if let profile = profiles.first {
                        if !recommendedFriends.contains(where: { $0.id == profile.id }) &&
                           !friendRequests.contains(where: { $0.id == profile.id }) &&
                           !outgoingRequests.contains(profile.id) {
                            recommendedFriends.append(profile)
                        }
                    }
                }
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
            .getDocuments { snapshot, _ in
                snapshot?.documents.forEach { $0.reference.updateData(["status": "accepted"]) }
                
                DispatchQueue.main.async {
                    friendRequests.removeAll { $0.id == user.id }
                    if !friends.contains(where: { $0.id == user.id }) {
                        friends.append(user)
                    }
                    recommendedFriends.removeAll { $0.id == user.id }
                }
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
