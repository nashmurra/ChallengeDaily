//
//  BlockedUsersView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 3/24/25.
//

import SwiftUI

struct BlockedUsersView: View {
    @State private var blockedUsers: [String] = ["User1", "User2", "User3"] // Replace with actual blocked users data
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Text("Blocked Users")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                if blockedUsers.isEmpty {
                    Text("No blocked users")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(blockedUsers, id: \.self) { user in
                            HStack {
                                Text(user)
                                    .foregroundColor(.white)
                                    .font(.title3)
                                
                                Spacer()
                                
                                Button(action: {
                                    unblockUser(user)
                                }) {
                                    Text("Unblock")
                                        .foregroundColor(.red)
                                        .fontWeight(.bold)
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 2))
                                }
                            }
                            .padding(.vertical, 5)
                        }
                        .listRowBackground(Color.gray.opacity(0.2))
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func unblockUser(_ user: String) {
        withAnimation {
            blockedUsers.removeAll { $0 == user }
        }
    }
}
