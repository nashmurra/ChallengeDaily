//
//  ExploreView.swift
//  DesignChallenge
//
//  Created by HPro2 on 4/27/25.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var postViewModel = PostViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        ForEach(postViewModel.viewModelPosts) { post in
                            NavigationLink(destination: PostDetailView(post: post)) {
                                FeedPostCard(post: post)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                postViewModel.fetchPosts()
            }
        }
    }
}

// MARK: - Feed Post Card
struct FeedPostCard: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading) {
                    Text("\(post.username), \(post.challengeName)")
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(relativeTime(post.createdAt))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            if let uiImage = decodeBase64ToImage(post.image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(
                        Text("Failed to load image")
                            .foregroundColor(.red)
                    )
            }
            
            Divider()
        }
        .padding()
        .background(Color.black.opacity(0.4))
        .cornerRadius(15)
    }
    
    func relativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    func decodeBase64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String),
              let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }
}

#Preview {
    ExploreView()
}
