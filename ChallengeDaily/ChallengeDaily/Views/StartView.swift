import SwiftUI

struct StartView: View {
    
    @State private var showingLoginView = false
    @State private var showingSignUpView = false
    @AppStorage("uid") var userID: String = ""  // Tracks if user is logged in
    
    var body: some View {
        ZStack {
            // Background image covering the entire screen
            Image("BackgroundScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

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
                    self.showingLoginView.toggle()
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
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.secondaryAccent))
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

