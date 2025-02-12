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
    
}

#Preview {
    ContentView()
}
