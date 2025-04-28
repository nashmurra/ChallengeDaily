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
    @StateObject private var viewModel: PrivacyViewModel
    
    init(userID: String) {
        _viewModel = StateObject(wrappedValue: PrivacyViewModel(userID: userID))
    }
    
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
                        Toggle(isOn: $viewModel.isPrivate) {
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
                        .onChange(of: viewModel.isPrivate) { _ in
                            viewModel.savePrivacySettings()
                        }
                    
                        Toggle(isOn: $viewModel.findFriendsWithContacts) {
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
                        .disabled(viewModel.isLoading)
                        .onChange(of: viewModel.findFriendsWithContacts) { newValue in
                            viewModel.handleContactsToggle(newValue: newValue)
                        }
                    }
                    
                    Spacer()
                }
                
                if viewModel.isLoading {
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
        .alert("Contacts Access Required", isPresented: $viewModel.showingContactsPermissionAlert) {
            Button("Cancel", role: .cancel) {
                viewModel.findFriendsWithContacts = false
                viewModel.savePrivacySettings()
            }
            Button("Open Settings") {
                viewModel.openAppSettings()
            }
        } message: {
            Text("To find friends from your contacts, please enable access in Settings.")
        }
        .alert("Contacts Access Denied", isPresented: $viewModel.contactsPermissionDenied) {
            Button("OK", role: .cancel) {
                viewModel.findFriendsWithContacts = false
                viewModel.savePrivacySettings()
            }
            Button("Settings", role: .none) {
                viewModel.openAppSettings()
            }
        } message: {
            Text("You've denied contacts access. You can enable it in Settings if you change your mind.")
        }
    }
}
