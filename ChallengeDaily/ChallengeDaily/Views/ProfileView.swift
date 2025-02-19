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
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Spacer().frame(height: 20) // Pushes the image down slightly
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text("\(userViewModel.username)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.title2)
                    .onAppear() {
                        userViewModel.fetchCurrentUser()
                    }
                
                Text("\(userViewModel.email)")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .font(.title3)
                
                

                Spacer()
                
                Text("Logged In!")
                    .foregroundColor(.white)
                    .font(.title2)
                
                HStack{
                    Button(action: {
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            withAnimation {
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
                .foregroundColor(.black)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                }
                
                
                
                Spacer() // Keeps content balanced
            }
        }
    }
}


#Preview {
    ProfileView()
}
