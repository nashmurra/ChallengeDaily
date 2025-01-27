//
//  Login.swift
//  TodaysChallenge
//
//  Created by Jonathan on 1/27/25.
//

import SwiftUI

struct Login: View {
    @State private var emailID: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Spacer(minLength: 0)
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text("Please sign in to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
        })
    }
}

#Preview {
    ContentView()
}
