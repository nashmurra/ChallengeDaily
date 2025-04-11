//
//  PostDetailView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 4/10/25.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
                VStack(spacing: 0) {
                    // Image section
                    if let uiImage = decodeBase64ToImage(post.image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                    } else {
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            Text("Failed to load image")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.top, 8)
                        }
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                    
                    // Post details
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(post.challengeName)
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text(relativeTime(post.createdAt))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Divider()
                            .background(Color.gray.opacity(0.5))
                        
                        // Add any additional post details here
                        // For example: likes, comments, description, etc.
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold))
                }
            }
        }
    }
    
    private func relativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func decodeBase64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String),
              let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }
}
