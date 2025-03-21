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
    @AppStorage("uid") var userID: String = ""

    var body: some View {
        ZStack {
            if userID == "" {
                StartView()
                /*
                if currentViewShowing == "login" {
                    LoginView(currentViewShowing: $currentViewShowing)
                        .transition(.move(edge: .top))
                        .preferredColorScheme(.dark)
                } else if currentViewShowing == "signup" {
                    SignupView(currentViewShowing: $currentViewShowing)
                        .preferredColorScheme(.dark)
                        .transition(.move(edge: .bottom))
                }
                 */
            } else {
                if currentViewShowing == "social" {
                    SocialView(currentViewShowing: $currentViewShowing)
                        .preferredColorScheme(.dark)
                        .transition(.move(edge: .bottom))
                } else if currentViewShowing == "profile" {
                    ProfileView(currentViewShowing: $currentViewShowing)
                        .preferredColorScheme(.dark)
                        .transition(.move(edge: .bottom))
                } else if currentViewShowing == "settings" {
                    SettingsView(currentViewShowing: $currentViewShowing)
                        .preferredColorScheme(.dark)
                        .transition(.move(edge: .bottom))
                } else {
                    MainView(currentViewShowing: $currentViewShowing)
                        .preferredColorScheme(.dark)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: currentViewShowing) // Ensure animation triggers on change
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AuthView()
}
