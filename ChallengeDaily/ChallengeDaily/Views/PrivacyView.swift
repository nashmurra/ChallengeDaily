//
//  PrivacyView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 3/24/25.
//

import SwiftUI
import FirebaseFirestore

struct PrivacyView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isPrivate: Bool = false
    @State private var findFriendsWithContacts: Bool = false
    var userID: String

    var body: some View {
        NavigationStack {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Privacy")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 60)
                    
                    VStack(spacing: 15) {
                        Toggle(isOn: Binding(
                            get: { self.isPrivate },
                            set: { newValue in
                                self.isPrivate = newValue
                                savePrivacySettings()
                            }
                        )) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Private Account")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                Text("Only friends can see your content.")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        Toggle(isOn: Binding(
                            get: { self.findFriendsWithContacts },
                            set: { newValue in
                                self.findFriendsWithContacts = newValue
                                savePrivacySettings()
                            }
                        )) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Find Friends with Contacts")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                Text("Find and connect with friends using your contacts.")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
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
        .onAppear {
            loadPrivacySettings()
        }
    }
    

    func savePrivacySettings() {
        let db = Firestore.firestore()
        db.collection("users").document(userID).setData([
            "isPrivate": isPrivate,
            "findFriendsWithContacts": findFriendsWithContacts
        ], merge: true) { error in
            if let error = error {
                print("DEBUG: Failed to save privacy settings: \(error.localizedDescription)")
            } else {
                print("DEBUG: Privacy settings saved successfully")
            }
        }
    }

    
    func loadPrivacySettings() {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                DispatchQueue.main.async {
                    self.isPrivate = data["isPrivate"] as? Bool ?? false
                    self.findFriendsWithContacts = data["findFriendsWithContacts"] as? Bool ?? false
                }
            }
        }
    }
}


