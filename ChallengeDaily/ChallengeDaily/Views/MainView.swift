import SwiftUI
import PhotosUI

struct MainView: View {
    @State private var showProfile = false
    @State private var showSocial = false
    @State private var timeRemaining = 0
    @State var showCamera: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var navigateToPostView: Bool = false

    @State private var selectedView: String = "Dashboard"
    
    
    @StateObject private var currentChallengeViewmodel = ChallengeViewModel()
    @StateObject private var postViewModel = PostViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @State var currentChallenge: Challenge?

    @Namespace var namespace
    @State var show = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    // Top Bar
                    HStack {
                        Spacer()
                        Text("Today's Challenge")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .shadow(radius: 5)
                            )
                        Spacer()
                    }
                    .padding(.top, 60)

                    Spacer().frame(height: 40)

                    // Avatar centered
                    if let currentChallenge = currentChallenge {
                        Image(systemName: currentChallenge.icon)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.white)
                            .padding(12)
                            .aspectRatio(contentMode: .fit)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .shadow(radius: 5)
                            )
                        
                        
                        // Challenge title + type
                        VStack(spacing: 4) {
                            Text(currentChallenge.title)
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.white)
                            
                            Text("Daily Challenge")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.6))
                            
                            Divider().frame(width: 180).background(.white.opacity(0.2))
                        }
                        .padding(.top, 16)
                        
                        // Challenge card
                        VStack(alignment: .center, spacing: 12) {
                            //                        Text("Walk up to a stranger and say:")
                            //                            .font(.callout)
                            //                            .foregroundColor(.white.opacity(0.7))
                            
                            Text(currentChallenge.instructions)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .italic()
                            
                            //                        Text("Then walk away.")
                            //                            .font(.callout)
                            //                            .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.ultraThinMaterial)
                                .blur(radius: 0.5)
                                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
                        )
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                    }

                    // Post Button
                    Button(action: {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            // showCamera = true
                        } else {
                            print("Camera not available")
                        }
                    }) {
                        Text("Make a Post")
                            .foregroundColor(.black)
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(colors: [Color.white, Color.white.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            )
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal, 80)
                    .padding(.top, 30)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            .ignoresSafeArea(edges: .top)
            .sheet(isPresented: $showCamera) {
                CameraView(selectedImage: $selectedImage)
                    //.preferredColorScheme(.dark)
                    .onDisappear {
                        print("📸 selectedImage after camera: \(String(describing: selectedImage))")
                        if selectedImage != nil {
                            DispatchQueue.main.async {
                                navigateToPostView = true
                            }
                        }
                    }
            }
            .navigationDestination(isPresented: $navigateToPostView) {
                if let image = selectedImage {
                    PostView(image: image)
                        //.preferredColorScheme(.dark)
                } else {
                    Text("⚠️ No image available")
                }
            }
            .onAppear {
                updateCountdown()
                setCurrentChallenge()
                postViewModel.fetchPosts()
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    updateCountdown()
                }
            }
            .padding(.trailing, 30)
        }
    }
    
    func setCurrentChallenge() {
        userViewModel.fetchUserChallengeID { challengeID in
            if let challengeID = challengeID {
                print("User's current challenge ID: \(challengeID)")

                currentChallengeViewmodel.fetchChallengeByID(challengeID) { challenge in
                    if let challenge = challenge {
                        DispatchQueue.main.async {
                            self.currentChallenge = challenge
                        }
                        print("Fetched challenge: \(challenge.title)")
                    } else {
                        print("Challenge not found")
                    }
                }
            } else {
                print("User has no current challenge ID assigned.")
            }
        }
    }




    func updateCountdown() {
        let now = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: now)

        components.hour = 3
        components.minute = 0
        components.second = 0

        let timezone = TimeZone(identifier: "America/New_York") ?? TimeZone.current
        let offset = timezone.secondsFromGMT()
        let utcResetDate = calendar.date(from: components)?.addingTimeInterval(TimeInterval(-offset))

        // If the reset time has already passed today, calculate for the next day
        if let resetTime = utcResetDate, resetTime < now {
            components.day! += 1
        }

        if let nextReset = calendar.date(from: components) {
            let timeDifference = nextReset.timeIntervalSince(now)
            timeRemaining = max(0, Int(timeDifference)) // Ensure no negative value

            // Trigger the reset if the time remaining is 0 (i.e., reset time has passed)
            if timeRemaining == 0 {
                //onCountdownReset()
            }
        }
    }



    func timeString(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    MainView()
        .preferredColorScheme(.dark)
}
