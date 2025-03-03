//
//  SettingsView.swift
//  ChallengeDaily
//
//  Created by HPro2 on 2/28/25.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @StateObject var userViewModel = UserViewModel()
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                List {
                    
                    Section(header: Text("Features")) {
                        Button {
                        } label: {
                            Text("Past Challenges")
                                .foregroundColor(.white)
                        }
                        
                        Button {
                        } label: {
                            Text("Achievements")
                                .foregroundColor(.white)
                        }
                    }
                    
                    Section(header: Text("Settings")) {
                        Button {
                        } label: {
                            Text("Privacy")
                                .foregroundColor(.white)
                        }
                        
                        Button {
                        } label: {
                            Text("Time Zone")
                                .foregroundColor(.white)
                        }
                        
                        Button {
                        } label: {
                            Text("Notifications")
                                .foregroundColor(.white)
                        }
                    }
                    
                    Section(header: Text("About")) {
                        Button {
                        } label: {
                            Text("Share")
                                .foregroundColor(.white)
                        }
                        
                        Button {
                        } label: {
                            Text("About")
                                .foregroundColor(.white)
                        }
                        
                        Button {
                        } label: {
                            Text("Rate")
                                .foregroundColor(.white)
                        }
                        
                        Button {
                        } label: {
                            Text("Help")
                                .foregroundColor(.white)
                        }
                    }
                    
                    Section() {
                        Button(action: {
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                withAnimation {
                                    userID = ""
                                }
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                        }) {
                            Text("LOG OUT")
                                .foregroundColor(.red)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("Settings")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                        Text("")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
