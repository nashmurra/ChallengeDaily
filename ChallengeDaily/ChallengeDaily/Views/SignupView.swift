//
//  LoginView.swift
//  ChallengeDaily
//
//  Created by Jonathan on 2/4/25.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore
//import FirebaseAuth

struct SignupView: View {
    //@Binding var currentViewShowing: String
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
            Color(red: 20/255, green: 28/255, blue: 30/255).edgesIgnoringSafeArea(.all)
                
                // Background icon pattern
            GeometryReader { geometry in
                    let icons = ["star.fill", "heart.fill", "bolt.fill", "flame.fill", "cloud.fill", "moon.fill", "sun.max.fill",
                                 "checkmark.circle.fill", "exclamationmark.triangle.fill"]
                    let spacing: CGFloat = 80 // Base spacing between icons
                    let jitter: CGFloat = 10 // How much each icon can shift
                    
                    ForEach(0..<Int(geometry.size.width / spacing) * Int(geometry.size.height / spacing), id: \.self) { index in
                        let row = index / Int(geometry.size.width / spacing)
                        let column = index % Int(geometry.size.width / spacing)
                        
                        let randomXOffset = 50 + CGFloat.random(in: -jitter...jitter)
                        let randomYOffset = 200 + CGFloat.random(in: -jitter...jitter)
                        
                        Image(systemName: icons.randomElement()!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white.opacity(0.2)) // Faded effect
                            .position(
                                x: CGFloat(column) * spacing + randomXOffset,
                                y: CGFloat(row) * spacing + randomYOffset
                            )
                    }
                }
            
            VStack{
                
                /*
                Spacer().frame(height: 50)
                
                Image(systemName: "plus.app.fill")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.bold)
                    .foregroundColor(Color.whiteText)
                    //.backgroundColor(Color.backgroundDark)
                    .frame(width: 100, height: 100)
                 */
                
                
                //Spacer()
                
                //Spacer().frame(height: 70)
                
                VStack{
                    
                    Spacer().frame(height: 150)
                    
                    Text("Sign Up")
                        .font(.system(size: 50, weight: .heavy, design: .default))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 90)
                        .foregroundColor(Color.whiteText)
                    
                    Spacer().frame(height: 10)
                    
                    Text("Create Account")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 90)
                        .foregroundColor(.white.opacity((0.7)))
                    
                   
                    
                    VStack{
                        
                        Spacer().frame(height: 10)
                        
                        Text("EMAIL")
                            .font(.caption)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 150)
                            .foregroundColor(.white.opacity((0.7)))
                        
                        HStack{
                            //Image(systemName: "mail")
                            TextField("Email", text: $email)
                                .foregroundColor(Color.whiteText)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                               
                            
                            Spacer()
                            
                            if (email.count != 0) {
                                Image(systemName: email.isValidEmail() ?  "checkmark" : "xmark")
                                    .fontWeight(.bold)
                                    .foregroundColor(email.isValidEmail() ? .green : .red)
                            }
                            
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 2)
                                .fill(.white.opacity((0.7)))
                                //.foregroundColor(Color.backgroundDark)
                        }
                        .padding()
                        .padding(.top, -15)
                        .padding(.leading, 130)
                        .padding(.trailing, 40)
                    }
                    
                    VStack {
                        
                        Spacer().frame(height: 10)
                        
                        Text("PASSWORD")
                            .font(.caption)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 150)
                            .foregroundColor(.white.opacity((0.7)))
                        
                        HStack{
                            //Image(systemName: "lock")
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
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 2)
                                .fill(.white.opacity((0.7)))
                            //.foregroundColor(Color.backgroundDark)
                        }
                        .padding()
                        .padding(.top, -15)
                        .padding(.leading, 130)
                        .padding(.trailing, 40)
                    }
                    
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
                        Text("Create Account")
                            .foregroundColor(Color.whiteText)
                            .font(.title3)
                            .bold()
                        
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                            .background{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.backgroundDark)
                            }
                            .padding(.horizontal)
                        
                    }
                    .padding(.leading, 140)
                    .padding(.trailing, 50)
                    
                    Button(action: {
                        
                        withAnimation {
                            self.currentViewShowing = "login"
                        }
                        
                    }) {
                        Text("Already have an account?")
                            .font(.footnote)
                            .foregroundColor(.white.opacity((0.7)))
                    }
                    .padding(.leading, 90)
                    .padding(.top, 60)
                    
                    //Spacer()
                    //Spacer()
                    
                   
                    
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 90, style: .continuous)
                        .fill(Color.backgroundLight)
                        //.matchedGeometryEffect(id: "background", in: namespace)
                    
                )
                .padding(.leading, -90)
                .padding(.top, -50)
                .ignoresSafeArea()
                //.offset(x: -99)
                
                Spacer().frame(height: 70)
                
                Image(systemName: "plus.app.fill")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.bold)
                    .foregroundColor(Color.pinkColor)
                    //.backgroundColor(Color.backgroundDark)
                    .frame(width: 100, height: 100)
                 
                
                
                //Spacer()
                
                Spacer().frame(height: 50)
            }
            
            
            
        }
        
        
        
    }
    
    
}



