import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SignupView: View {
    @AppStorage("uid") var userID: String = ""

    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var confirmPassword: String = ""

    @State private var accountCreated = false
    @State private var currentPage = 0
    
    @Environment(\.dismiss) private var dismiss

    @StateObject private var currentChallengeViewmodel = ChallengeViewModel()

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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "(?:[a-zA-Z0-9!#$%\\&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,}|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(?:\\.(?!$)|$)){4}\\])"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return predicate.evaluate(with: email)
    }

    
    private func isValidPhoneNumber(_ number: String) -> Bool {
        let cleaned = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return cleaned.count == 10 // Change this based on country rules if needed
    }

    private var isFormValid: Bool {
        return isValidEmail(email) &&
               isValidPhoneNumber(phoneNumber) &&
               isValidUsername(username) &&
               isValidPassword(password) &&
               confirmPassword == password
    }


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
                        .foregroundColor(.white)

                    Spacer().frame(height: 10)

                    HStack(spacing: 0) {
                        Text("Create")
                            .font(.largeTitle)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                        Text("Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }

                    Spacer().frame(height: 50)

                    ZStack {
                        TabView(selection: $currentPage) {
                            // Email Page
                            VStack {
                                Text("Email")
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.white)
                                    .padding(.top)
                                    .padding(.leading)
                                    .padding(.horizontal, 20)

                                HStack {
                                    TextField("Email", text: $email)
                                        .foregroundColor(Color.white)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)

                                    Spacer()

                                    if !email.isEmpty {
                                        if isValidEmail(email) {
                                            Image(systemName: "checkmark")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.greenColor)
                                        } else {
                                            Image(systemName: "xmark")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.pinkColor)
                                        }
                                    }

                                }
                                .padding(.horizontal, 35)
                                .padding(.bottom, 1)

                                Divider()
                                    .background(Color.white)
                                    .frame(height: 1)
                                    .padding(.horizontal, 35)
                            }
                            .padding()
                            .tag(0)
                            
                            // Phone Number Page
                            VStack {
                                Text("Phone Number")
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.white)
                                    .padding(.top)
                                    .padding(.leading)
                                    .padding(.horizontal, 20)

                                HStack {
                                    TextField("Phone Number", text: $phoneNumber)
                                        .foregroundColor(.white)
                                        .keyboardType(.phonePad)
                                        .disableAutocorrection(true)

                                    Spacer()

                                    if !phoneNumber.isEmpty {
                                        if isValidPhoneNumber(phoneNumber) {
                                            Image(systemName: "checkmark")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.greenColor)
                                        } else {
                                            Image(systemName: "xmark")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.pinkColor)
                                        }
                                    }

                                }
                                .padding(.horizontal, 35)
                                .padding(.bottom, 1)

                                Divider()
                                    .background(Color.white)
                                    .frame(height: 1)
                                    .padding(.horizontal, 35)
                            }
                            .padding()
                            .tag(1)


                            // Username Page
                            VStack {
                                Text("Username")
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.white)
                                    .padding(.top)
                                    .padding(.leading)
                                    .padding(.horizontal, 20)

                                HStack {
                                    TextField("Username", text: $username)
                                        .foregroundColor(.white)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)

                                    Spacer()

                                    if !username.isEmpty {
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
                                }
                                .padding(.horizontal, 35)
                                .padding(.bottom, 1)

                                Divider()
                                    .background(Color.white)
                                    .frame(height: 1)
                                    .padding(.horizontal, 35)
                            }
                            .padding()
                            .tag(2)

                            // Password Page
                            VStack {
                                Text("Password")
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.white)
                                    .padding(.top)
                                    .padding(.leading)
                                    .padding(.horizontal, 20)

                                HStack {
                                    SecureField("Password", text: $password)
                                        .foregroundColor(.white)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)

                                    Spacer()

                                    if !password.isEmpty {
                                        if isValidPassword(password) {
                                            Image(systemName: "checkmark")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.greenColor)
                                        } else {
                                            Image(systemName: "xmark")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.pinkColor)
                                        }
                                    }
                                }
                                .padding(.horizontal, 35)
                                .padding(.bottom, 1)

                                Divider()
                                    .background(Color.white)
                                    .frame(height: 1)
                                    .padding(.horizontal, 35)
                            }
                            .padding()
                            .tag(3)

                            // Confirm Password Page
                            VStack {
                                Text("Confirm Password")
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.white)
                                    .padding(.top)
                                    .padding(.leading)
                                    .padding(.horizontal, 20)

                                HStack {
                                    SecureField("Confirm Password", text: $confirmPassword)
                                        .foregroundColor(.white)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)

                                    Spacer()

                                    if confirmPassword == password && !confirmPassword.isEmpty {
                                        Image(systemName: "checkmark")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.greenColor)
                                    } else if !confirmPassword.isEmpty && confirmPassword != password {
                                        Image(systemName: "xmark")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.pinkColor)
                                    }
                                }
                                .padding(.horizontal, 35)
                                .padding(.bottom, 1)

                                Divider()
                                    .background(Color.white)
                                    .frame(height: 1)
                                    .padding(.horizontal, 35)
                            }
                            .padding()
                            .tag(4)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .frame(height: 250)
                        .animation(.easeInOut, value: currentPage)
                        .gesture(DragGesture()) // This blocks swiping

                    }

                    Spacer().frame(height: 40)

                    Button {
                        if isFormValid {
                            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                if let error = error {
                                    print("Error creating user: \(error.localizedDescription)")
                                    return
                                }

                                guard let authResult = authResult else { return }

                                let newUserID = authResult.user.uid
                                userID = newUserID
                                accountCreated = true
                                
                                let cleanedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                                let formattedPhoneNumber = "+1\(cleanedPhoneNumber)" // Replace +1 with dynamic country detection if needed

                                let db = Firestore.firestore()
                                db.collection("challenges").getDocuments { snapshot, error in
                                    if let error = error {
                                        print("Error fetching challenges: \(error.localizedDescription)")
                                        return
                                    }

                                    let allChallenges = snapshot?.documents.map { $0.documentID } ?? []
                                    let randomChallenges = allChallenges.shuffled().prefix(4)

                                    db.collection("users").document(newUserID).setData([
                                        "userID": newUserID,
                                        "username": username,
                                        "email": email,
                                        "createdAt": Timestamp(),
                                        "darkMode": true,
                                        "privateAccount": false,
                                        "findFriendsWithContacts": false,
                                        "contentFilter": "Everyone",
                                        "profileImage": "",
                                        "currentChallengeID": randomChallenges.first ?? "",
                                        "challenges": Array(randomChallenges),
                                        "lastUpdated": getFormattedDate(),
                                        "notifications": [
                                            "Friend Requests": false,
                                            "Friends' Posts": false,
                                            "Comments": false,
                                            "Likes": false,
                                            "Streak Warnings": false,
                                            "Achievements": false
                                        ],
                                        "friends": [],
                                        "friendRequests": [],
                                        "blockedUsers": [],
                                        "friendCount": 0,
                                        "pendingFriendRequestsCount": 0,
                                        "phoneNumber": formattedPhoneNumber
                                    ], merge: true) { error in
                                        if let error = error {
                                            print("Error creating user document: \(error.localizedDescription)")
                                        } else {
                                            print("User document created successfully!")
                                        }
                                    }
                                }
                            }
                        } else {
                            if email.isEmpty || !isValidEmail(email) {
                                currentPage = 0
                            } else if phoneNumber.isEmpty || !isValidPhoneNumber(phoneNumber) {
                                currentPage = 1
                            } else if !isValidUsername(username) {
                                currentPage = 2
                            } else if !isValidPassword(password) {
                                currentPage = 3
                            } else if confirmPassword != password {
                                currentPage = 4
                            }


                        }
                    } label: {
                        Text(isFormValid ? "Sign Up" : "Next")
                            .foregroundColor(isFormValid ? Color.black.opacity(0.6) : .white)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background {
                                if isFormValid {
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.tealColor, Color.greenColor]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                } else {
                                    Color.gray
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal, 100)
                    }

                    NavigationLink(
                        destination: MainView(),
                        isActive: $accountCreated
                    ) {
                        EmptyView()
                    }

                    Spacer()
                }
                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                    }
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
