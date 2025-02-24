//
//  AuthView.swift
//  ChallengeDaily
//
//  Created by Jonathan on 2/11/25.
//

import SwiftUI
import Firebase

struct AuthView: View {
    @State private var currentViewShowing: String = "login" // login or signup

    var body: some View {
        if currentViewShowing == "login" {
            LoginView(currentViewShowing: $currentViewShowing)
                .preferredColorScheme(.light)
        } else {
            SignupView(currentViewShowing: $currentViewShowing)
                .preferredColorScheme(.dark)
                .transition(.move(edge: .bottom))
        }
    }
}

#Preview {
    AuthView()
}
