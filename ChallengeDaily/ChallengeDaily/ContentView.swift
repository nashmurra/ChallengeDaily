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
            MainView()
                .preferredColorScheme(.dark)
                .transition(.move(edge: .bottom))
        }
        
    }
    
}

#Preview {
    ContentView()
}
