//
//  AuthView.swift
//  ChallengeDaily
//
//  Created by Jonathan on 2/11/25.
//

import SwiftUI

struct AuthView: View {
    @State private var currentViewShowing: String = "login" // login or signup
    
    var body: some View {
        
        if currentViewShowing == "login" {
            LoginView(currentViewShowing: $currentViewShowing)
                .preferredColorScheme(.light)
        } else {
            SignupView(currentViewShowing: $currentViewShowing)
                .preferredColorScheme(.dark)
        }
        
    }
}

#Preview {
    AuthView()
}
