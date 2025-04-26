//
//  PrivacyView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 3/24/25.
//

import SwiftUI
import FirebaseFirestore
import Contacts

struct PrivacyView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isPrivate: Bool = false
    @State private var findFriendsWithContacts: Bool = false
    @State private var showingContactsPermissionAlert = false
    @State private var contactsPermissionDenied = false
    @State private var isLoading: Bool = false
    var userID: String
    
    private let contactStore = CNContactStore()
    
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
                        Toggle(isOn: $isPrivate) {
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
                        .onChange(of: isPrivate) { _ in
                            savePrivacySettings()
                        }
                    
                        Toggle(isOn: $findFriendsWithContacts) {
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
                        .disabled(isLoading)
                        .onChange(of: findFriendsWithContacts) { newValue in
                            handleContactsToggle(newValue: newValue)
                        }
                    }
                    
                    Spacer()
                }
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
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
                        Text("Back")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .alert("Contacts Access Required", isPresented: $showingContactsPermissionAlert) {
            Button("Cancel", role: .cancel) {
                findFriendsWithContacts = false
            }
            Button("Open Settings") {
                openAppSettings()
            }
        } message: {
            Text("To find friends from your contacts, please enable access in Settings.")
        }
        .alert("Contacts Access Denied", isPresented: $contactsPermissionDenied) {
            Button("OK", role: .cancel) {
                findFriendsWithContacts = false
            }
            Button("Settings", role: .none) {
                openAppSettings()
            }
        } message: {
            Text("You've denied contacts access. You can enable it in Settings if you change your mind.")
        }
        .onAppear {
            loadPrivacySettings()
        }
    }
    
    private func handleContactsToggle(newValue: Bool) {
        if newValue {
            requestContactsAccess()
        } else {
            savePrivacySettings()
        }
    }
    
    private func requestContactsAccess() {
        isLoading = true
        
        contactStore.requestAccess(for: .contacts) { [self] granted, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if granted {
                    savePrivacySettings()
                } else {
                    findFriendsWithContacts = false
                    let status = CNContactStore.authorizationStatus(for: .contacts)
                    
                    if status == .denied || status == .restricted {
                        contactsPermissionDenied = true
                    } else {
                        showingContactsPermissionAlert = true
                    }
                }
            }
        }
    }
    
    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else {
            return
        }
        
        UIApplication.shared.open(settingsUrl)
    }
    
    private func loadPrivacySettings() {
        isLoading = true
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { [self] document, error in
            isLoading = false
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                return
            }
            
            isPrivate = data["isPrivate"] as? Bool ?? false
            let contactsEnabled = data["findFriendsWithContacts"] as? Bool ?? false
            if contactsEnabled {
                checkContactsAuthorization { authorized in
                    findFriendsWithContacts = authorized
                }
            } else {
                findFriendsWithContacts = false
            }
        }
    }
    
    private func checkContactsAuthorization(completion: @escaping (Bool) -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        completion(status == .authorized)
    }
    
    private func savePrivacySettings() {
        let db = Firestore.firestore()
        db.collection("users").document(userID).setData([
            "isPrivate": isPrivate,
            "findFriendsWithContacts": findFriendsWithContacts
        ], merge: true)
    }
}
