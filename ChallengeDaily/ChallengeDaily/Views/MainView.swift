import SwiftUI

struct MainView: View {
    @State private var showProfile = false // Controls ProfileView navigation
    @State private var showSocial = false  // Controls SocialView navigation
    @State private var showChallenge = false
    @Namespace var namespace
    @State var show = false

    var body: some View {
        NavigationStack{
            ZStack(alignment: .top) { // Aligns overlay to the top
                
                Color.backgroundDark
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 80) // Space for the fixed header
                        
                        VStack {
                            Spacer()
                            
                            VStack {
                                Text("00:00")
                                    .font(.system(size: 50, weight: .heavy, design: .rounded)) // Custom size
                                
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .textCase(.uppercase)
                                    .padding(60)
                                    .offset(y: 130)
                                
                                Text("Daily Challenge Countdown")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .textCase(.uppercase)
                                    .padding(60)
                                    .offset(y: 0)
                            }
                            
                            
                            
                        }
                        .frame(height: 800)
                        .background(
                            RoundedRectangle(cornerRadius: 0, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.pinkColor, Color.redColor]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .padding(.top, -620)
                        
                        if !show {
                            ChallengeItem(namespace: namespace, show: $show)
                        } else {
                            ChallengeView(namespace: namespace, show: $show)
                        }
                        
                        VStack(spacing: 0) {
                            FeedView()
                            FeedView()
                            FeedView()
                            FeedView()
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize) // Less bouncy scrolling
                
                
                
                // Fixed header overlay
                VStack {
                    Spacer().frame(height:80)
                    HStack {
                        Button(action: {
                            showSocial = true // Navigate to SocialView
                        }) {
                            Image(systemName: "person.2.fill")
                                .resizable()
                                .frame(width: 35, height: 25)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("Today's Challenge")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                            .textCase(.uppercase)
                        Spacer()
                        Button(action: {
                            showProfile = true // Navigate to ProfileView
                        }) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 60)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .zIndex(1) // Ensures it stays on top
            }
            .ignoresSafeArea(edges: .top)
            .navigationDestination(isPresented: $showProfile) {
                ProfileView()
            }
            .navigationDestination(isPresented: $showSocial) {
                SocialView()
            }
        }
        
    }
}

#Preview {
    MainView()
        .preferredColorScheme(.dark)
}

            
            
            /*
             
             }
             }
             
             }
             */
