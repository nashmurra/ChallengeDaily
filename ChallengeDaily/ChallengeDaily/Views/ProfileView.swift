import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var showSettings = false
    @State private var profileImage: UIImage?
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    
    @State private var username: String = "Username"
    @State private var email: String = "user@example.com"
    @State private var friendCount: Int = 0
    
    @StateObject private var postViewModel = PostViewModel()
    
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        headerView
                        userInfoDetails
                        
                        // Posts grid
                        if !postViewModel.viewModelPosts.isEmpty {
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(postViewModel.viewModelPosts) { post in
                                    NavigationLink {
                                        PostDetailView(post: post)
                                            .navigationBarBackButtonHidden(true)
                                    } label: {
                                        PostGridItem(post: post)
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
                .padding(.bottom, 30)
            }
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(10)
                                //.background(Color.black.opacity(0.6))
                                //.clipShape(Circle())
                        }
                    }
                    .padding(.top, 0)
                    .padding(.trailing, 20)

                    Spacer()
                }
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    settingsButton
                }
            }
            .sheet(isPresented: $showImagePicker, onDismiss: handleImagePickerDismiss) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .onAppear {
                if !userID.isEmpty {
                    loadProfileData()
                }
            }
        }
    }
    
    // MARK: - Subviews
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
                
                if isUploading {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
                
                Button(action: { showImagePicker = true }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .offset(x: 30, y: 30)
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
            
            Text("Complete challenges to share your first post!")
                .foregroundColor(.gray)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 40)
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
    
    private var settingsButton: some View {
        NavigationLink(destination: SettingsView()) {
            Image(systemName: "gearshape.fill")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
        }
    }
    
    // MARK: - Methods
    private func loadProfileData() {
        //postViewModel.fetchPosts()
        fetchProfileImage()
        fetchUserData()
        postViewModel.fetchPostsForUser(userID: userID)
    }
    
    private func handleImagePickerDismiss() {
        guard let selectedImage = selectedImage else { return }
        uploadImageToFirestore(selectedImage)
    }
    
    private func fetchUserData() {
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
                }
            }
    }
    
    private func fetchProfileImage() {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG: Failed to fetch profile image: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data(),
                  let base64String = data["profileImage"] as? String,
                  let imageData = Data(base64Encoded: base64String),
                  let image = UIImage(data: imageData) else {
                print("DEBUG: No profile image found or failed to decode")
                return
            }
            
            DispatchQueue.main.async {
                self.profileImage = image
            }
        }
    }
    
    private func uploadImageToFirestore(_ image: UIImage) {
        isUploading = true
        ImageUploader.uploadImage(image: image) { base64String in
            DispatchQueue.main.async {
                self.isUploading = false
                guard let base64String = base64String else {
                    print("Failed to encode image")
                    return
                }
                
                let db = Firestore.firestore()
                db.collection("users").document(userID).setData([
                    "profileImage": base64String
                ], merge: true) { error in
                    if let error = error {
                        print("DEBUG: Failed to save image to Firestore: \(error.localizedDescription)")
                    } else {
                        print("DEBUG: Image saved to Firestore successfully")
                        self.profileImage = image
                    }
                }
            }
        }
    }
}

// MARK: - Post Grid Item Subview
struct PostGridItem: View {
    let post: Post
    
    var body: some View {
        Group {
            if let uiImage = decodeBase64ToImage(post.image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: (UIScreen.main.bounds.width / 3) - 1,
                           height: (UIScreen.main.bounds.width / 3) - 1)
                    .clipped()
                    .contentShape(Rectangle())
            } else {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(width: (UIScreen.main.bounds.width / 3) - 1,
                           height: (UIScreen.main.bounds.width / 3) - 1)
                    .overlay(
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.white)
                    )
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
