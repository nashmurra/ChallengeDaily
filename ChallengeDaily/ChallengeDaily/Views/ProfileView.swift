import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var showSettings = false
    @State private var showProfilePhoto = false
    @State private var profileImage: UIImage?
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    //@Binding var currentViewShowing: String

    // Add state variables for username and email
    @State private var username: String = ""
    @State private var email: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    headerView
                    userInfoDetails
                    Spacer()
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            //presentationMode.wrappedValue.dismiss() // Navigate back
                            withAnimation {
                                //self.currentViewShowing = "main"
                            }
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
                        Button(action: {
                            withAnimation {
                                //self.currentViewShowing = "settings"
                            }
                            //showSettings = true
                        }) {
                            HStack {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white)
                                Text("")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showSettings) {
                //SettingsView()
            }
            .navigationDestination(isPresented: $showProfilePhoto) {
                ProfilePhotoSelectorView(profileImage: $profileImage, userID: userID)
            }
            .onAppear {
                fetchProfileImage() // Fetch the profile image
                fetchUserData()    // Fetch the user's data (username and email)
            }
        }
    }

    // Fetch user data (username and email) from Firestore
    func fetchUserData() {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("DEBUG: Failed to fetch user data: \(error.localizedDescription)")
                    return
                }

                guard let document = snapshot?.documents.first else {
                    print("DEBUG: No user data found")
                    return
                }

                let data = document.data()
                self.username = data["username"] as? String ?? "Unknown"
                self.email = data["email"] as? String ?? "No email"
            }
    }

    // Fetch profile image from Firestore
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
}

extension ProfileView {
    var headerView: some View {
        NavigationStack {
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
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else {
                                    Image("thanos")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                }
                            }
                        )
                    
                    Button(action: {
                        showProfilePhoto = true
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
        }
    }
    
    var userInfoDetails: some View {
        VStack(spacing: 0) {
            // Display the username
            Text(username) // Username from Firestore
                .font(.title.bold())
                .foregroundColor(.white)
            
            // Display the user ID after "@"
            Text("@\(userID)") // User ID from @AppStorage
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Goofy Goober")
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.top, 6)
            
            HStack {
                Text("Followers")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.top, 6)
                
                Text("1.2M")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.top, 6)
                
                Spacer().frame(width: 40)
                
                Text("Following")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.top, 6)
                
                Text("10K")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.top, 6)
            }
        }
    }
}

#Preview {
    //ProfileView()
}


//    var actionButtons: some View {
//        HStack() {
//            Button(action: {
//
//            }) {
//                Text("Edit Profile")
//                    .font(.subheadline.bold())
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 5)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(Color.gray, lineWidth: 1)
//                    )
//            }
//        }
//        .padding(.top, 5)
//    }
//}



//    @StateObject var userViewModel = UserViewModel()
//    @AppStorage("uid") var userID: String = ""
//    @Environment(\.presentationMode) var presentationMode // Allows navigation back
//
//    var body: some View {
//        ZStack {
//            Color.black.edgesIgnoringSafeArea(.all)
//
//            VStack {
//                Spacer().frame(height: 20) // Pushes the image down slightly
//
//                Image(systemName: "person.crop.circle.fill")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//
//                Text("\(userViewModel.username)")
//                    .foregroundColor(.white)
//                    .fontWeight(.bold)
//                    .font(.title2)
//                    .onAppear {
//                        userViewModel.fetchCurrentUser()
//                    }
//
//                Text("\(userViewModel.email)")
//                    .foregroundColor(.white)
//                    .fontWeight(.semibold)
//                    .font(.title3)
//
//                Spacer()
//
//                Text("Logged In!")
//                    .foregroundColor(.white)
//                    .font(.title2)
//
//                HStack {
//                    Button(action: {
//                        let firebaseAuth = Auth.auth()
//                        do {
//                            try firebaseAuth.signOut()
//                            withAnimation {
//                                userID = ""
//                            }
//                        } catch let signOutError as NSError {
//                            print("Error signing out: %@", signOutError)
//                        }
//                    }) {
//                        Text("Sign Out")
//                            .foregroundColor(.white)
//                    }
//                }
//                .foregroundColor(.black)
//                .padding()
//                .overlay {
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(lineWidth: 2)
//                        .foregroundColor(.white)
//                }
//
//                Spacer() // Keeps content balanced
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss() // Navigate back
//                }) {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.white)
//                        Text("")
//                            .foregroundColor(.white)
//                    }
//                }
//            }
//        }
//    }
