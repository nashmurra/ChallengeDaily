//
//  Login.swift
//  TodaysChallenge
//
//  Created by Jonathan on 1/27/25.
//

import SwiftUI

struct Login: View {
    @Binding var showSignup: Bool
    // View Properties
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var showForgotPasswordView: Bool = false
    @State private var showResetView: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Spacer(minLength: 0)
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text("Please sign in to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                //Custom Text Fields
                CustomTF(sfIcon: "at", hint: "Email ID", value: $emailID)
                
                CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                    .padding(.top, 5)
                
                Button("Forgot Password") {
                    showForgotPasswordView.toggle()
                }
                .font(.callout)
                .fontWeight(.heavy)
                .tint(.teal)
                .hSpacing(.trailing)
                
                // Login Button
                GradientButton(title: "Login", icon: "arrow.right") {
                    
                }
                .hSpacing(.trailing)
                .disableWithOpacity(emailID.isEmpty || password.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                Text("Don't have an account?")
                    .foregroundStyle(.gray)
                Button("SignUp") {
                    showSignup.toggle()
                }
                .fontWeight(.bold)
                .tint(.teal)
            }
            .font(.callout)
            .hSpacing()
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showForgotPasswordView, content: {
            if #available(iOS 16.4, *) {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
        .sheet(isPresented: $showForgotPasswordView, content: {
            if #available(iOS 16.4, *) {
                PasswordResetView()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                PasswordResetView()
                    .presentationDetents([.height(350)])            }
        })
    }
}

#Preview {
    ContentView()
}
