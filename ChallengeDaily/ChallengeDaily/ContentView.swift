//
//  ContentView.swift
//  TodaysChallenge
//
//  Created by HPro2 on 1/24/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var sfIcon: String
    var iconTint: Color = .gray
    var hint: String
    //Hides TextField
    var isPassword: Bool = false
    @Binding var value: String
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 8, content: {
            
        })
    }
}

#Preview {
    ContentView()
}
