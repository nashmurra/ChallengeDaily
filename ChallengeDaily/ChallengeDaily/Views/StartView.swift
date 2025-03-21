import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack {
            // Background image covering the entire screen
            Image("BackgroundScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Circles in the top-left corner
            VStack {
                HStack {
                    ZStack {
                        
                        Circle()
                            .frame(width: 100, height: 100)
                            .offset(x: 190, y: -130) // Moves it above the big circle
                            .foregroundColor(Color.primaryAccent)
                        
                        // Big Circle
                        Circle()
                            .frame(width: 300, height: 300)
                            .offset(x: 0, y: -130) // Moves it left & up
                            .foregroundColor(Color.secondaryAccent)
                        
                        // Small Circle 1 (Top Left)
                        
                        
                        // Small Circle 2 (Top Right)
                        Circle()
                            .frame(width: 50, height: 50)
                            .offset(x: 30, y: -60) // Adjusted position to be on the right
                            .foregroundColor(Color.primaryAccent)
                        
                        Circle()
                            .frame(width: 25, height: 25)
                            .offset(x: -40, y: -65) // Adjusted position to be on the right
                            .foregroundColor(Color.primaryAccent)
                        
                        Circle()
                            .frame(width: 100, height: 100)
                            .offset(x: 150, y: 670) // Moves it above the big circle
                            .foregroundColor(Color.secondaryAccent)
                        
                        Rectangle()
                            .frame(width: 100, height: 100)
                            .offset(x: 150, y: 720) // Moves it above the big circle
                            .foregroundColor(Color.secondaryAccent)
                        
                        Circle()
                            .frame(width: 18, height: 18)
                            .offset(x: 140, y: 675) // Adjusted position to be on the right
                            .foregroundColor(Color.primaryAccent)
                        
                        Circle()
                            .frame(width: 12, height: 12)
                            .offset(x: 165, y: 675) // Adjusted position to be on the right
                            .foregroundColor(Color.primaryAccent)
                    }
                    
                    Spacer()
                }
                Spacer().frame(height: 600)
            }
            .ignoresSafeArea() // Ensures circles extend beyond safe area
            
            VStack {
                Spacer().frame(height: 10)
                
                Text("TC.")
                    .font(.system(size: 100, weight: .bold, design: .default))
                    .foregroundColor(Color.white)
                
                Spacer().frame(height: 100)
                
                Text("Welcome!")
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .foregroundColor(Color.white)
                
                Spacer().frame(height: 30)
                
                Button {
                    // Placeholder for login action
                } label: {
                    Text("Sign In")
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(17)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.secondaryAccent, lineWidth: 2))
                        .padding(.horizontal, 55)
                }
                
                Spacer().frame(height: 30)
                
                Button {
                    // Placeholder for login action
                } label: {
                    Text("Create Account")
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(17)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.secondaryAccent))
                        .padding(.horizontal, 55)
                }
            }
        }
    }
}

#Preview {
    StartView()
}
