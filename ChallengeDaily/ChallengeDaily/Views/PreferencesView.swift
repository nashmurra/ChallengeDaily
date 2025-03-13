//
//  PreferencesView.swift
//  ChallengeDaily
//
//  Created by HPro2 on 3/11/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct PreferencesView: View {
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isDarkMode") private var isDarkMode = false

    @State private var privateAccount = false
    @State private var contentFilter = "Everyone"

    let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            ZStack {
                (isDarkMode ? Color.black : Color.white)
                    .edgesIgnoringSafeArea(.all)

                List {
                    Section(header: Text("Preferences")
                        .foregroundColor(isDarkMode ? .white : .black)
                        .font(.headline)
                    ) {
                        Toggle("Dark Mode", isOn: $isDarkMode)
                            .onChange(of: isDarkMode) { newValue in
                                savePreference(key: "darkMode", value: newValue)
                            }
                            .foregroundColor(isDarkMode ? .white : .black)
                            .listRowBackground(isDarkMode ? Color.gray.opacity(0.2) : Color.white)

                        Toggle("Private Account", isOn: $privateAccount)
                            .onChange(of: privateAccount) { newValue in
                                savePreference(key: "privateAccount", value: newValue)
                            }
                            .foregroundColor(isDarkMode ? .white : .black)
                            .listRowBackground(isDarkMode ? Color.gray.opacity(0.2) : Color.white)

                        Picker("Content Filter", selection: $contentFilter) {
                            Text("Everyone").tag("Everyone")
                            Text("Friends Only").tag("Friends")
                            Text("No One").tag("NoOne")
                        }
                        .onChange(of: contentFilter) { newValue in
                            savePreference(key: "contentFilter", value: newValue)
                        }
                        .foregroundColor(isDarkMode ? .white : .black)
                        .listRowBackground(isDarkMode ? Color.gray.opacity(0.2) : Color.white)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(isDarkMode ? Color.black : Color.white)
            }
            .navigationTitle("Preferences")
            .toolbarColorScheme(isDarkMode ? .dark : .light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Preferences")
                        .foregroundColor(isDarkMode ? .white : .black)
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(isDarkMode ? .white : .black)
                    }
                }
            }
            .onAppear(perform: loadPreferences)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }

    func savePreference(key: String, value: Any) {
        guard !userID.isEmpty else { return }
        db.collection("users").document(userID).setData([key: value], merge: true)
    }


    func loadPreferences() {
        guard !userID.isEmpty else { return }
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                isDarkMode = data["darkMode"] as? Bool ?? false
                privateAccount = data["privateAccount"] as? Bool ?? false
                contentFilter = data["contentFilter"] as? String ?? "Everyone"
            }
        }
    }
}

#Preview {
    PreferencesView()
        //.preferredColorScheme(.light)
}
