//
//  FeedView.swift
//  DesignChallenge
//
//  Created by HPro2 on 2/27/25.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        
        ZStack {
            Color.backgroundDark
                .ignoresSafeArea()
            
            VStack{
                
                HStack{
                    
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.whiteText)
                    
                    VStack{
                        Text("johnny_is_cool")
                            .font(.callout)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment:.leading)
                        
                        Text("Sylvania, United States - 47 minutes ago")
                            .font(.footnote)
                            .fontWeight(.regular)
                            .frame(maxWidth: .infinity, alignment:.leading)
                        
                        
                        
                    }
                    
                    Spacer()
                    
                    Image(systemName: "ellipsis")
                        .resizable()
                        .frame(width: 20, height: 5)
                        .foregroundColor(Color.whiteText)
                    //.padding(.horizontal)
                    
                }
                .padding(.horizontal)
                
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.backgroundLight) // Semi-transparent
                        .frame(height: 400) // Adjust height as needed
                        //.background()
                }
                
                Spacer().frame(height: 30)
                
                
                
            }
        }
        

    }
}

#Preview {
    FeedView()
        .preferredColorScheme(.dark)
}
