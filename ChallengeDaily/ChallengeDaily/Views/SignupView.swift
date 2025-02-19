//
//  SignupView.swift
//  ChallengeDaily
//
//  Created by Jonathan on 2/11/25.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @AppStorage("uid") var userID: String = ""
    
    @Binding var currentViewShowing: String
    
    private func isValidPassword(_ password: String) -> Bool {
        //minimum 6 characters long
        //1 uppercase character
        //1 special character
        
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
        
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack {
                    Text("Create an Account!")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack{
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    Spacer()
                    
                    if (email.count != 0) {
                        Image(systemName: email.isValidEmail() ?  "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                    
                }
                .foregroundColor(.white)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                }
                
                .padding()
                
                HStack{
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    Spacer()
                    
                    if (password.count != 0) {
                        Image(systemName: isValidPassword(password) ?  "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) ? .green : .red)
                    }
                    
                }
                .foregroundColor(.white)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                }
                
                .padding()
                
                HStack{
                    Image(systemName: "mail")
                    TextField("Username", text: $username)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    Spacer()
                    
                    if (username.count != 0) {
                        Image(systemName:"checkmark")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                }
                .foregroundColor(.white)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                }
                
                .padding()
                
                Button(action: {
                    
                    withAnimation {
                        self.currentViewShowing = "login"
                    }
                    
                }) {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                Spacer()
                
                Button {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print("Error creating user: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let authResult = authResult else { return }
                        
                        let newUserID = authResult.user.uid
                        userID = newUserID  // Save userID in AppStorage
                        
                        let db = Firestore.firestore()
                        db.collection("users").addDocument(data: [
                            "userID": newUserID,  // Store the auth user ID
                            "username": username,
                            "email": email,
                            "createdAt": Timestamp()
                        ]) { error in
                            if let error = error {
                                print("Error creating user document: \(error.localizedDescription)")
                            } else {
                                print("User document created successfully!")
                            }
                        }
                    }
                } label: {
                    Text("Create New Account")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                        }
                        .padding(.horizontal)
                }

            }
        }
    }
}
