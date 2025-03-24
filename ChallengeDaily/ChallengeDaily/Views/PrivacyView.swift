//
//  PrivacyView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 3/24/25.
//

import SwiftUI

struct PrivacyView: View {
    @Binding var isPrivate: Bool
    @State private var findFriendsWithContacts: Bool = false
    @State private var showBlockedUsers = false
    
    var body: some View {
        ZStack {
            Image("BackgroundScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 10)
                .overlay(Color.black.opacity(0.4))
            
            VStack {
                Spacer().frame(height: 20)
                
                Text("Privacy Settings")
                    .font(.system(size: 50, weight: .heavy))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.white)
                    .padding(.top, 50)
                    .padding()
                    .padding(.horizontal)
                
                Spacer().frame(height: 50)
                
                VStack(spacing: 20) {
                    Toggle(isOn: $isPrivate) {
                        Text("Private Account")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.dark)
                            .shadow(radius: 5)
                    )
                    .padding(.horizontal)
                    
                    Text("A private account means only approved followers can see your content.")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Toggle(isOn: $findFriendsWithContacts) {
                        Text("Find Friends with Contacts")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.dark)
                            .shadow(radius: 5)
                    )
                    .padding(.horizontal)
                    
                    Button(action: {
                        showBlockedUsers = true
                    }) {
                        Text("Blocked Users")
                            .foregroundColor(Color.white)
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.red)
                                    .shadow(radius: 5)
                            )
                            .padding(.horizontal, 25)
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    // Handle privacy setting confirmation
                }) {
                    Text("Save Settings")
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(17)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.secondaryAccent))
                        .padding(.horizontal, 25)
                }
                
                Spacer()
            }
            .navigationDestination(isPresented: $showBlockedUsers) {
                BlockedUsersView()
            }
        }
    }
}
