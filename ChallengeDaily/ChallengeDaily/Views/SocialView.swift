//
//  SocialView.swift
//  ChallengeDaily
//
//  Created by Jonathan on 2/20/25.
//

import SwiftUI

struct SocialView: View {
    @StateObject var userViewModel = UserViewModel()
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""

    let fakeProfiles = [
        "KongSun", "Bob Smith", "Charlie Brown",
        "Matthew Li", "Emma Watson", "Frank White"
    ]

    var filteredProfiles: [String] {
        if searchText.isEmpty {
            return fakeProfiles
        } else {
            return fakeProfiles.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer().frame(height: 20)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search...", text: $searchText)
                        .foregroundColor(.white)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)

                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
                
                Text("Recommened Friends")
                    .font(.title)
                    .foregroundColor(.white)
                    .font(Font.custom("Baskerville-Bold", size: 26))
                    .fontWeight(.bold)

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredProfiles, id: \.self) { profile in
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                
                                Text(profile)
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .medium))
                                    .padding(.leading, 10)

                                Spacer()

                                Button(action: {
                                    // Add friend action
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                }

                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
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
    SocialView()
}
