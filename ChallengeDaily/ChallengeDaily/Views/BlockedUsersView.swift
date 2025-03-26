//
//  BlockedUsersView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 3/24/25.
//

import SwiftUI

struct BlockedUsersView: View {
    @State private var blockedUsers: [String] = ["User1", "User2", "User3"] // Example data
    
    var body: some View {
        ZStack {
            Image("BackgroundScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                // Title
                Text("Blocked Users")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 60)
                
                if blockedUsers.isEmpty {
                    Text("No blocked users")
                        .foregroundColor(.white.opacity(0.6))
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(blockedUsers, id: \.self) { user in
                                HStack {
                                    Text(user)
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        unblockUser(user)
                                    }) {
                                        Text("Unblock")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white, lineWidth: 2)
                                            )
                                    }
                                }
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func unblockUser(_ user: String) {
        withAnimation {
            blockedUsers.removeAll { $0 == user }
        }
    }
}
