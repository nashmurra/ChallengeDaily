//
//  PrivacyViewModel.swift
//  ChallengeDaily
//
//  Created by HPro2 on 4/28/25.
//

import SwiftUI
import FirebaseFirestore
import Contacts

class PrivacyViewModel: ObservableObject {
    @Published var isPrivate: Bool = false
    @Published var findFriendsWithContacts: Bool = false
    @Published var isLoading: Bool = false
    @Published var showingContactsPermissionAlert = false
    @Published var contactsPermissionDenied = false
    
    private var listener: ListenerRegistration?
    private let userID: String
    private let contactStore = CNContactStore()

    init(userID: String) {
        self.userID = userID
        setupFirestoreListener()
    }
    
    deinit {
        listener?.remove()
    }
    
    private func setupFirestoreListener() {
        let db = Firestore.firestore()
        listener = db.collection("users").document(userID).addSnapshotListener { [weak self] document, _ in
            guard let self = self else { return }
            guard let document = document, document.exists else { return }
            let data = document.data() ?? [:]
            
            DispatchQueue.main.async {
                self.isPrivate = data["isPrivate"] as? Bool ?? false
                let storedContactsValue = data["findFriendsWithContacts"] as? Bool ?? false
                if self.findFriendsWithContacts != storedContactsValue {
                    self.findFriendsWithContacts = storedContactsValue
                }
            }
        }
    }
    
    func savePrivacySettings() {
        let db = Firestore.firestore()
        db.collection("users").document(userID).setData([
            "isPrivate": isPrivate,
            "findFriendsWithContacts": findFriendsWithContacts
        ], merge: true)
    }
    
    func handleContactsToggle(newValue: Bool) {
        if newValue {
            requestContactsAccess()
        } else {
            savePrivacySettings()
        }
    }
    
    private func requestContactsAccess() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        if status == .authorized {
            savePrivacySettings()
        } else if status == .notDetermined {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            contactStore.requestAccess(for: .contacts) { [weak self] granted, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isLoading = false
                    if granted {
                        self.savePrivacySettings()
                    } else {
                        self.findFriendsWithContacts = false
                        self.showingContactsPermissionAlert = true
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.findFriendsWithContacts = false
                self.contactsPermissionDenied = true
            }
        }
    }
    
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
}
