//
//  ChallengeView.swift
//  DesignChallenge
//
//  Created by Jonathan on 2/26/25.
//

import SwiftUI

struct ChallengeItem: View {
    
    var namespace: Namespace.ID
    @Binding var show: Bool
    var currentChallange: Challenge
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Daily Challenge")
                    .font(.callout.weight(.semibold))
                    .matchedGeometryEffect(id: "subtitle", in: namespace)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(currentChallange.title)
                    .font(.title.weight(.bold))
                    .matchedGeometryEffect(id: "title", in: namespace)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            .foregroundColor(Color.whiteText)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color.backgroundLight)
                    .matchedGeometryEffect(id: "background", in: namespace)
                
            )
            .mask {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .matchedGeometryEffect(id: "mask", in: namespace)
            }
            .overlay(
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        show.toggle()
                    }
                }) {
                    Image(systemName: "chevron.up.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(red: 115/255, green: 175/255, blue: 239/255))
                }
                    .matchedGeometryEffect(id: "chevron", in: namespace)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 40),
                alignment: .topTrailing
            )
            .padding(20)
        }

    }
}


