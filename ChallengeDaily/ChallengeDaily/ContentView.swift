//
//  ContentView.swift
//  TodaysChallenge
//
//  Created by HPro2 on 1/24/25.
//

import SwiftUI
import SwiftData
import FirebaseAuth

struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    
    // View Properities
    @State private var showSignup: Bool = false
    var body: some View {
        /*
        NavigationStack {
            Login(showSignup: $showSignup)
                .navigationDestination(isPresented: $showSignup) {
                    Signup(showSignup: $showSignup)
                }
        }
        .overlay {
            if #available(iOS 17, *) {
                CircleView()
                    .animation(.smooth(duration: 0.4, extraBounce: 0), value: showSignup)
            } else {
                CircleView()
                    .animation(.easeInOut(duration: 0.3), value: showSignup)
            }
        }
         */
        
        if userID == ""{
            AuthView()
        } else {
            Text("Logged In! \nYour user id is \(userID)")
            
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
            }
        }
        
    }
    
    // Moving Blurred Background
    @ViewBuilder
    func CircleView() -> some View {
        Circle()
            .fill(.linearGradient(colors: [.green, .blue, .red], startPoint: .top, endPoint: .bottom))
            .frame(width: 200, height: 200)
            .offset(x: showSignup ? 90 : -90, y: -90)
            .blur(radius: 15)
            .hSpacing(showSignup ? .trailing : .leading)
            .vSpacing(.top)
    }
}

#Preview {
    ContentView()
}
