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

                ZStack {
                    AnimatedImage(
                        imageName: "image2",
                        frame: CGSize(width: 130, height: 130 / 3 * 4),
                        offset: CGSize(width: -140, height: -160),
                        delay: 0.0
                    )
                    AnimatedImage(
                        imageName: "image3",
                        frame: CGSize(width: 130, height: 130 / 3 * 4),
                        offset: CGSize(width: -140, height: 110),
                        delay: 0.5
                    )
                    AnimatedImage(
                        imageName: "image1",
                        frame: CGSize(width: 90, height: 90),
                        offset: CGSize(width: 100, height: 0),
                        delay: 1.2
                    )
                    AnimatedImage(
                        imageName: "image4",
                        frame: CGSize(width: 100, height: 100),
                        offset: CGSize(width: 170, height: 140),
                        delay: 0.8
                    )
                    AnimatedImage(
                        imageName: "image6",
                        frame: CGSize(width: 130, height: 130),
                        offset: CGSize(width: 140, height: -200),
                        delay: 1.7
                    )
                    AnimatedImage(
                        imageName: "image5",
                        frame: CGSize(width: 180, height: 240),
                        offset: CGSize(width: 0, height: 0),
                        delay: 1.0
                    )
                }

                .frame(height: 150)  // Container height for the image cluster
                .padding(.bottom, 30)

                Spacer().frame(height: 50)

                Image(systemName: "target")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.white)
                    .offset(y:55)
                

                Spacer().frame(height: 50)

                Text("Everyone’s watching. You in?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .offset(y:55)
                    .multilineTextAlignment(.center)

                    
                
 
                Spacer().frame(height: 30)

                // Sign In Button (Filled Gradient)
                Button {
                    self.showingSignUpView.toggle()
                } label: {
                    Text("Sign up")
                        .foregroundColor(Color.black).opacity(0.6)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.tealColor, Color.greenColor,
                                ]),
                                startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 75)
                }
                .offset(y:75)
                .sheet(isPresented: $showingSignUpView) {
                    SignupView()
                }

                Spacer().frame(height: 30)

                // Create Account Button (Outlined Gradient)
                Button {
                    self.showingLoginView.toggle()
                } label: {
                    Text("Log in")
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.tealColor, Color.greenColor,
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing),
                                    lineWidth: 2
                                )
                        )
                        .padding(.horizontal, 75)
                }
                .sheet(isPresented: $showingLoginView) {
                    LoginView(
                        isPresented: $showingLoginView,
                        onSwitchToSignup: {
                            // This runs after the login view is dismissed
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.showingSignUpView = true
                            }
                        }
                    )
                }
                .offset(y:55)
                
                Text("By continuing, you agree to TC's Terms of Service and acknowlege you've read our Privacy Policy. Notice at collection")
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .offset(y:88)
                    .multilineTextAlignment(.center)
                    .frame(width: 350)
                
            }
        }
        .fullScreenCover(isPresented: .constant(userID != ""), content: {
            MainView() // Automatically transition to MainView when logged in
        })
    }
}

struct AnimatedImage: View {
    let imageName: String
    let frame: CGSize
    let offset: CGSize
    let delay: Double

    @State private var scale: CGFloat = 1.0

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(3 / 3, contentMode: .fill)
            .frame(width: frame.width, height: frame.height)
            .cornerRadius(12)
            .clipped()
            .offset(x: offset.width, y: offset.height)
            .scaleEffect(scale)
            .onAppear {
                animate()
            }
    }

    func animate() {
        Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            while true {
                withAnimation(.easeInOut(duration: 3)) {
                    scale = 0.9
                }
                try? await Task.sleep(nanoseconds: 3_000_000_000)

                withAnimation(.easeInOut(duration: 3)) {
                    scale = 1.0
                }
                try? await Task.sleep(nanoseconds: 3_000_000_000)
            }
        }
    }
}
