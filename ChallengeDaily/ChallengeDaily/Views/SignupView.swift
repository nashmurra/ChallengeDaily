import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct SignupView: View {
    @AppStorage("uid") var userID: String = ""

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var confirmPassword: String = ""

    @State private var accountCreated = false  // Track login state

    @State private var currentPage = 0  // New for paging UI

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(
            format: "SELF MATCHES %@",
            "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }

    private func isValidUsername(_ username: String) -> Bool {
        let regex = "^(?![_.])[a-zA-Z0-9._]{3,15}(?<![_.])$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: username)
    }

    @StateObject private var currentChallengeViewmodel = ChallengeViewModel()

    var body: some View {

        NavigationView {
            ZStack {

                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {

                    Spacer().frame(height: 120)

                    Image(systemName: "target")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.white)

                    Spacer().frame(height: 10)

                    HStack(spacing: 0) {
                        Text("Create")
                            .font(.largeTitle)
                            .fontWeight(.light)
                            .foregroundColor(Color.white)

                        Text("Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }

                    Spacer().frame(height: 50)

                    TabView(selection: $currentPage) {

                        // Email Page
                        VStack(spacing: 0) {
                            Spacer().frame(height: 10)

                            VStack {

                                Text("Email")
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .frame(
                                        maxWidth: .infinity, alignment: .leading
                                    )
                                    .foregroundColor(Color.white)
                                    .padding(.top)
                                    .padding(.leading)

                                HStack {
                                    TextField("Email", text: $email)
                                        .foregroundColor(Color.white)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)

                                    Spacer()

                                    if isValidUsername(username) {
                                        Image(systemName: "checkmark")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.greenColor)
                                    } else {
                                        Image(systemName: "xmark")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.pinkColor)
                                    }

                                }
                                .padding(.horizontal)
                                .padding(.bottom, 1)

                                // More visible divider
                                Divider()
                                    .background(Color.white)  // Make it more visible
                                    .frame(height: 1)  // Adjust thickness
                                    .padding(.horizontal)
                            }
                            .background(Color.clear)
                            .padding()
                            .padding(.horizontal)
                        }
                        .tag(0)

                        // Username Page
                        VStack(spacing: 0) {
                            VStack {

                                Text("Username")
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .frame(
                                        maxWidth: .infinity, alignment: .leading
                                    )
                                    .foregroundColor(Color.white)
                                    .padding(.top)
                                    .padding(.leading)

                                HStack {
                                    TextField("Username", text: $username)
                                        .foregroundColor(Color.white)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)

                                    Spacer()

                                    if username.count != 0 {
                                        Image(systemName: "checkmark")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.greenColor)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 1)

                                // More visible divider
                                Divider()
                                    .background(Color.white)  // Make it more visible
                                    .frame(height: 1)  // Adjust thickness
                                    .padding(.horizontal)

                            }
                            .background(Color.clear)
                            .padding()
                            .padding(.horizontal)
                        }
                        .tag(1)

                        // Password Page
                        VStack(spacing: 0) {
                            VStack {

                                Text("Password")
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .frame(
                                        maxWidth: .infinity, alignment: .leading
                                    )
                                    .foregroundColor(Color.white)
                                    .padding(.top)
                                    .padding(.leading)

                                HStack {
                                    SecureField("Password", text: $password)
                                        .foregroundColor(Color.white)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)

                                    Spacer()

                                    if isValidPassword(password) {
                                        Image(systemName: "checkmark")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.greenColor)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 1)

                                // More visible divider
                                Divider()
                                    .background(Color.white)  // Make it more visible
                                    .frame(height: 1)  // Adjust thickness
                                    .padding(.horizontal)

                            }
                            .background(Color.clear)
                            .padding()
                            .padding(.horizontal)
                        }
                        .tag(2)

                        // Confirm Password Page
                        VStack {
                            Text("Confirm Password")
                                .font(.footnote)
                                .fontWeight(.light)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.white)
                                .padding(.top)
                                .padding(.leading)

                            HStack {
                                SecureField(
                                    "Confirm Password", text: $confirmPassword
                                )
                                .foregroundColor(Color.white)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)

                                Spacer()

                                if confirmPassword == password
                                    && !confirmPassword.isEmpty
                                {
                                    Image(systemName: "checkmark")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.greenColor)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 1)

                            // More visible divider
                            Divider()
                                .background(Color.white)  // Make it more visible
                                .frame(height: 1)  // Adjust thickness
                                .padding(.horizontal)

                        }
                        .background(Color.clear)
                        .padding()
                        .padding(.horizontal)
                        .tag(3)

                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 250)  // Adjust height as needed
                    .animation(.easeInOut, value: currentPage)

                    Spacer().frame(height: 20)

                    // Arrow Controls
                    HStack {
                        Button(action: {
                            if currentPage > 0 {
                                currentPage -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }

                        Spacer()

                        Button(action: {
                            if currentPage < 3 {
                                currentPage += 1
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .padding(.horizontal, 50)

                    Spacer().frame(height: 40)

                    Button {
                        Auth.auth().createUser(
                            withEmail: email, password: password
                        ) { authResult, error in
                            if let error = error {
                                print(
                                    "Error creating user: \(error.localizedDescription)"
                                )
                                return
                            }

                            guard let authResult = authResult else {
                                return
                            }

                            let newUserID = authResult.user.uid
                            userID = newUserID  // Save userID in AppStorage
                            accountCreated = true

                            let db = Firestore.firestore()

                            // Fetch random challenges and store them in Firestore
                            db.collection("challenges").getDocuments {
                                snapshot, error in
                                if let error = error {
                                    print(
                                        "Error fetching challenges: \(error.localizedDescription)"
                                    )
                                    return
                                }

                                let allChallenges =
                                    snapshot?.documents.map {
                                        $0.documentID
                                    } ?? []
                                let randomChallenges =
                                    allChallenges.shuffled().prefix(4)

                                db.collection("users").document(newUserID)
                                    .setData(
                                        [
                                            "userID": newUserID,
                                            "username": username,
                                            "email": email,
                                            "createdAt": Timestamp(),
                                            "darkMode": true,
                                            "privateAccount": false,
                                            "findFriendsWithContacts": false,
                                            "contentFilter": "Everyone",
                                            "profileImage": "",
                                            "currentChallengeID":
                                                randomChallenges.first ?? "",
                                            "challenges": Array(
                                                randomChallenges),
                                            "lastUpdated": getFormattedDate(),
                                            "notifications": [
                                                "Friend Requests": false,
                                                "Friends' Posts": false,
                                                "Comments": false,
                                                "Likes": false,
                                                "Streak Warnings": false,
                                                "Achievements": false,
                                            ],
                                            "friends": [],
                                            "friendRequests": [],
                                            "blockedUsers": [],
                                            "friendCount": 0,
                                            "pendingFriendRequestsCount": 0,
                                        ],
                                        merge: true
                                    ) { error in
                                        if let error = error {
                                            print(
                                                "Error creating user document: \(error.localizedDescription)"
                                            )
                                        } else {
                                            print(
                                                "User document created successfully with friends data!"
                                            )
                                        }
                                    }
                            }
                        }
                    } label: {
                        Text("Sign Up")
                            .foregroundColor(Color.black).opacity(0.6)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.tealColor, Color.greenColor,
                                    ]),
                                    startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal, 100)
                    }

                    NavigationLink(
                        destination: MainView(), isActive: $accountCreated
                    ) {
                        EmptyView()
                    }

                    Spacer()
                }
            }
        }
    }

    private func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
