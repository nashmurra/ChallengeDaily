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

    @State private var username: String = ""
    @State private var email: String = ""
    @State private var friendCount: Int = 0

    @StateObject private var postViewModel = PostViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        headerView
                        userInfoDetails

                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(postViewModel.viewModelPosts, id: \.id) { post in
                                Rectangle()
                                    .foregroundColor(.white.opacity(0.1))
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay(
                                        FeedView(post: post)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    )
                            }
                        }
                        .padding(.top)
                    }
                    .padding()
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .sheet(isPresented: $showImagePicker, onDismiss: {
                if let selectedImage = selectedImage {
                    uploadImageToFirestore(selectedImage)
                }
            }) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .onAppear {
                fetchProfileImage()
                fetchUserData()
                postViewModel.fetchPostsForUser(userID: userID)
            }
        }
    }

    func fetchUserData() {
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

                self.username = data["username"] as? String ?? "Unknown"
                self.email = data["email"] as? String ?? "No email"
                if let friends = data["friends"] as? [String] {
                    self.friendCount = friends.count
                } else {
                    self.friendCount = 0
                }
            }
    }

    func fetchProfileImage() {
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

    func uploadImageToFirestore(_ image: UIImage) {
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

// MARK: - Subviews

extension ProfileView {
    var headerView: some View {
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
                                Image("thanos")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            }
                        }
                    )

                Button(action: {
                    showImagePicker = true
                }) {
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
        }
        .frame(maxWidth: .infinity)
    }

    var userInfoDetails: some View {
        VStack(spacing: 0) {
            Text(username)
                .font(.title.bold())
                .foregroundColor(.white)

            Text("@\(userID)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("Friends")
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .padding(.top, 6)

            Text("\(friendCount)")
                .font(.subheadline.bold())
                .foregroundColor(.white)
        }
    }
}
