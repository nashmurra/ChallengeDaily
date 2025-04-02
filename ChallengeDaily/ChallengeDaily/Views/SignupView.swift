import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct SignupView: View {
    @AppStorage("uid") var userID: String = ""
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var accountCreated = false // Track login state
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }

    @StateObject private var currentChallengeViewmodel = ChallengeViewModel()
    
    /*
     
     */


    var body: some View {
        
        NavigationView {
        ZStack {
            
            Image("BackgroundScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                
                Spacer().frame(height: 20)
                
                Text("Create Your Account")
                    .font(.system(size: 50, weight: .heavy))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.whiteText)
                    .padding(.top, 50)
                    .padding()
                    .padding(.horizontal)
                
                Spacer().frame(height: 50)
                
                VStack(spacing:0) {
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: 10)
                        
                        VStack {
                            
                            Text("Email")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.primaryAccent)
                                .padding(.top)
                                .padding(.leading)
                            
                            HStack {
                                TextField("Email", text: $email)
                                    .foregroundColor(Color.white)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                
                                
                                
                                
                                Spacer()
                                
                                if email.count != 0 {
                                    Image(systemName: "checkmark")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.bottom)
                            .padding(.horizontal)
                            .padding(.top, -10)
                            //.padding()
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 0)
                            //.stroke(lineWidth: 2)
                                .fill(Color.dark)
                        )
                        .padding()
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: 0) {
                        //Spacer().frame(height: 10)
                        
                        VStack {
                            
                            Text("Username")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.primaryAccent)
                                .padding(.top)
                                .padding(.leading)
                            
                            HStack {
                                TextField("Username", text: $username)
                                    .foregroundColor(Color.white)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                
                                
                                
                                
                                Spacer()
                                
                                if email.count != 0 {
                                    Image(systemName: "checkmark")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.bottom)
                            .padding(.horizontal)
                            .padding(.top, -10)
                            //.padding()
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 0)
                            //.stroke(lineWidth: 2)
                                .fill(Color.dark)
                        )
                        .padding()
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: 0) {
                        //Spacer().frame(height: 10)
                        
                        VStack {
                            
                            Text("Password")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.primaryAccent)
                                .padding(.top)
                                .padding(.leading)
                            
                            HStack {
                                TextField("Password", text: $password)
                                    .foregroundColor(Color.white)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                
                                
                                
                                
                                Spacer()
                                
                                if email.count != 0 {
                                    Image(systemName: "checkmark")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.bottom)
                            .padding(.horizontal)
                            .padding(.top, -10)
                            //.padding()
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 0)
                            //.stroke(lineWidth: 2)
                                .fill(Color.dark)
                        )
                        .padding()
                        .padding(.horizontal)
                    }
                    
                    VStack {
                        
                        Text("Confirm Password")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.primaryAccent)
                            .padding(.top)
                            .padding(.leading)
                        
                        HStack {
                            TextField("Confirm Password", text: $confirmPassword)
                                .foregroundColor(Color.white)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                            
                            
                            
                            
                            Spacer()
                            
                            if email.count != 0 {
                                Image(systemName: "checkmark")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.bottom)
                        .padding(.horizontal)
                        .padding(.top, -10)
                        //.padding()
                        
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                        //.stroke(lineWidth: 2)
                            .fill(Color.dark)
                    )
                    .padding()
                    .padding(.horizontal)
                    
                    Spacer().frame(height: 40)
                    
                    Button {
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                print("Error creating user: \(error.localizedDescription)")
                                return
                            }

                            guard let authResult = authResult else { return }

                            let newUserID = authResult.user.uid
                            userID = newUserID  // Save userID in AppStorage
                            accountCreated = true

                            let db = Firestore.firestore()

                            // Fetch random challenges and store them in Firestore
                            db.collection("challenges").getDocuments { snapshot, error in
                                if let error = error {
                                    print("Error fetching challenges: \(error.localizedDescription)")
                                    return
                                }

                                let allChallenges = snapshot?.documents.map { $0.documentID } ?? []
                                let randomChallenges = allChallenges.shuffled().prefix(4)

                                // Create the user document with assigned challenges
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
                                    "currentChallengeID": randomChallenges.first ?? "",  // First challenge
                                    "challenges": Array(randomChallenges),  // Store all 4 challenge IDs
                                    "lastUpdated": getFormattedDate(),  // Today's date
                                    "notifications": [
                                        "Friend Requests": true,
                                        "New Followers": true,
                                        "Friends' Posts": false,
                                        "Tags": true,
                                        "Comments": true,
                                        "Likes": false,
                                        "Streak Warnings": true,
                                        "Achievements": true
                                    ]
                                ], merge: true) { error in
                                    if let error = error {
                                        print("Error creating user document: \(error.localizedDescription)")
                                    } else {
                                        print("User document created successfully!")
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Sign Up")
                            .foregroundColor(Color.white)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(17)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.secondaryAccent))
                            .padding(.horizontal, 25)
                    }

                    
                    
                    NavigationLink(destination: MainView(), isActive: $accountCreated) {
                        EmptyView()
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            currentChallengeViewmodel.fetchDailyChallenges()
            print("Fetched the challenges")
        }
    }
    }
    
    
}
