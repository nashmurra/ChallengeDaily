//
//  ProfileView.swift
//  ChallengeDaily
//
//  Created by Jonathan on 2/18/25.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject var userViewModel = UserViewModel()
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)

                }
                .padding()
                .padding(.top)
                
                
                VStack {
                    Text("Username: \(userViewModel.username)")
                        .foregroundColor(.white)
                    Text("Email: \(userViewModel.email)")
                        .foregroundColor(.white)
                }
                .onAppear {
                    userViewModel.fetchCurrentUser()
                }
                Text("Logged In! \nYour user id is \(userID)")
                    .foregroundColor(.white)
                
                Button(action: {
                    
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        withAnimation{
                            userID = ""
                        }
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
                    
                }) {
                    Text("Sign Out")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
