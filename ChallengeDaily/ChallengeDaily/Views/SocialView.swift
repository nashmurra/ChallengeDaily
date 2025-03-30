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
    
    //@Binding var currentViewShowing: String

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
            Color.backgroundDark.edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                let icons = ["star.fill", "heart.fill", "bolt.fill", "flame.fill", "cloud.fill", "moon.fill", "sun.max.fill",
                             "checkmark.circle.fill", "exclamationmark.triangle.fill"]
                let spacing: CGFloat = 80 // Base spacing between icons
                let jitter: CGFloat = 10 // How much each icon can shift

                let rows = Int(geometry.size.height / spacing) + 5
                let columns = Int(geometry.size.width / spacing) + 5

                ForEach(0..<rows, id: \.self) { row in
                    ForEach(0..<columns, id: \.self) { column in
                        let randomXOffset = CGFloat.random(in: -jitter...jitter)
                        let randomYOffset = CGFloat.random(in: -jitter...jitter)

                        Image(systemName: icons.randomElement()!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white.opacity(0.2)) // Faded effect
                            .position(
                                x: CGFloat(column) * spacing + randomXOffset,
                                y: CGFloat(row) * spacing + randomYOffset
                            )
                            .ignoresSafeArea(.all)
                    }
                }
            }
            .allowsHitTesting(false)

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
                .background(Color.backgroundLight)
                .cornerRadius(8)
                .padding(.horizontal)
                
                Text("Recommended Friends")
                    .font(.title)
                    .foregroundColor(.whiteText)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredProfiles, id: \ .self) { profile in
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                
                                Text(profile)
                                    .foregroundColor(.whiteText)
                                    .font(.system(size: 18, weight: .medium))
                                    .padding(.leading, 10)

                                Spacer()

                                Button(action: {
                                    // Add friend action
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(Color.pinkColor)
                                }
                            }
                            .padding()
                            .background(Color.backgroundLight)
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
                            .foregroundColor(.whiteText)
                        Text("")
                            .foregroundColor(.whiteText)
                    }
                }
            }
        }
    }
}


#Preview {
    //SocialView()
}
