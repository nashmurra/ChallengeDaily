import SwiftUI

struct StartView: View {
    
    @State private var showingLoginView = false
    @State private var showingSignUpView = false
    @AppStorage("uid") var userID: String = ""  // Tracks if user is logged in
    
    var body: some View {
        ZStack {
            // Background image covering the entire screen
            Image("appBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Image(systemName: "target")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(Color.white)
                
                Spacer().frame(height: 10)
                
                HStack(spacing: 0) {
                    Text("todays")
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .foregroundColor(Color.white)
                    
                    Text("challenge")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
                
                Spacer().frame(height: 100)

                Text("Welcome!")
                    .font(.title2)
                    .foregroundColor(Color.white)
                
                Spacer().frame(height: 30)

                Button {
                    self.showingLoginView.toggle()
                } label: {
                    Text("Sign In")
                        .foregroundColor(Color.black).opacity(0.6)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(17)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.tealColor, Color.greenColor]),
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 55)
                }
                .sheet(isPresented: $showingLoginView) {
                    LoginView(isPresented: $showingLoginView)  // Pass binding
                }

                Spacer().frame(height: 30)

                Button {
                    self.showingSignUpView.toggle()
                } label: {
                    Text("Create Account")
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(17)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color.tealColor, Color.greenColor]),
                                                   startPoint: .leading, endPoint: .trailing),
                                    lineWidth: 2
                                )
                        )
                        .padding(.horizontal, 55)
                }
                .sheet(isPresented: $showingSignUpView) {
                    SignupView()
                }
            }
        }
        .fullScreenCover(isPresented: .constant(userID != ""), content: {
            MainView() // Automatically transition to MainView when logged in
        })
    }
}

