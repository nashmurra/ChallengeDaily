//
//  FeedView.swift
//  DesignChallenge
//
//  Created by HPro2 on 2/27/25.
//

import SwiftUI

struct FeedView: View {
    var post: Post
    
    var body: some View {
        
        ZStack {
            
            VStack{
                
                HStack{
                    
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(Color.gray)
                        .frame(width: 30, height: 30)
                        //.foregroundColor(Color.whiteText)
                    
                    VStack{
                        HStack {
                            Text(post.username)
                                .font(.callout)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment:.leading)
                                .foregroundColor(Color.gray)
                            
                            Text(post.challengeName)
                                .font(.callout)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment:.leading)
                                .foregroundColor(Color.gray)
                        }

                        Text(relativeTime(post.createdAt))
                            .font(.footnote)
                            .fontWeight(.regular)
                            .frame(maxWidth: .infinity, alignment:.leading)
                            .foregroundColor(Color.gray)
                        
                        
                        
                    }
                    
                    Spacer()
                    
                    Image(systemName: "ellipsis")
                        .resizable()
                        .frame(width: 20, height: 5)
                        .foregroundColor(Color.gray)
                        
                    //.padding(.horizontal)
                    
                }
                .padding(.horizontal)
                
                
                VStack {
                    
                    if let uiImage = decodeBase64ToImage(post.image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .frame(width: 400, height: 400)
                    } else {
                        Text("Failed to load image")
                            .foregroundColor(.red)
                            .frame(height: 400)
                    }
                    

                }
                
                Spacer().frame(height: 15)
                
                Divider()
                
                Spacer().frame(height: 15)
                
                
                
            }
        }
        

    }
    
    func relativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }


    // Function to decode Base64 string to UIImage
    func decodeBase64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String),
              let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}
