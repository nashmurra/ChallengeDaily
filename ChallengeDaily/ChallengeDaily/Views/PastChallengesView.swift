//
//  PastChallengesView.swift
//  ChallengeDaily
//
//  Created by HPro2 on 3/4/25.
//

import SwiftUI

struct PastChallengesView: View {
    @Namespace var namespace
    @State var show = false
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                Text("Past Challenges")
                    .font(.title.bold())
                ChallengeItem(namespace: namespace, show: $show)
            }
            .frame(maxHeight: .infinity, alignment: .top)
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
    PastChallengesView()
        .preferredColorScheme(.dark)
}
