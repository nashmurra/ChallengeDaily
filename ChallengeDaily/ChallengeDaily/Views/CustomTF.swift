//
//  CustomTF.swift
//  TodaysChallenge
//
//  Created by HPro2 on 1/27/25.
//

import SwiftUI

struct CustomTF: View {
    var sfIcon: String
    var iconTint: Color = .gray
    var hint: String
    var isPassword: Bool = false
    //Hides TextField
    @State private var showPassword: Bool = false
    @Binding var value: String
    var body: some View {
        HStack(alignment: .top, spacing: 8, content: {
            Image(systemName: sfIcon)
                .foregroundStyle(iconTint)
                .frame(width: 30)
                .offset(y: 2)
            
            VStack(alignment: .leading,spacing: 8, content: {
                if isPassword {
                    Group {
                        //Revealing Password when user wants
                        if showPassword {
                            TextField(hint, text: $value)
                        } else {
                            SecureField(hint, text: $value)
                        }
                    }
                } else {
                    TextField(hint, text: $value)
                }
                
                Divider()
            })
            .overlay(alignment: .trailing) {
                //Password Reveal Button
                if isPassword {
                    Button(action : {withAnimation {
                        showPassword.toggle()
                    }
                    }, label: {
                        Image(systemName: showPassword ? "eye.slah" : "eye")
                            .foregroundStyle(.gray)
                            .padding(10)
                            .contentShape(.rect)
                    })
                }
            }
        })
    }
}
