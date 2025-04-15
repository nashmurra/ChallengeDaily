import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.7
    @State private var logoOpacity: Double = 0.0
    @State private var offsetY: CGFloat = 40
    @State private var taglineOpacity: Double = 0.0

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("TC.")
                        .font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .offset(y: offsetY)
                        .shadow(color: .white.opacity(0.2), radius: 10, x: 0, y: 5)

                    Text("Today's Challenge")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .opacity(taglineOpacity)
                        .transition(.opacity)
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 1.2)) {
                        logoScale = 1.0
                        logoOpacity = 1.0
                        offsetY = 0
                    }

                    // Tagline appears slightly after the main logo
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation(.easeIn(duration: 1.0)) {
                            taglineOpacity = 1.0
                        }
                    }

                    // Transition to ContentView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
