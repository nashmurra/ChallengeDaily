import SwiftUI
import FirebaseAuth
import PhotosUI

struct MainView: View {
    @Binding var currentViewShowing: String
    
    @State private var showProfile = false
    @State private var showSocial = false
    @State private var timeRemaining = 0
    @State private var showCamera: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var navigateToPostView: Bool = false
    @StateObject private var currentChallengeViewmodel = ChallengeViewModel()
    @StateObject private var postViewModel = PostViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @Namespace var namespace
    @State var show = false
    @State var currentChallenge: Challenge?  // Make it optional

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.backgroundDark
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 80)

                        VStack {
                            Spacer()

                            VStack {
                                Text(timeString(from: timeRemaining))
                                    .font(.system(size: 50, weight: .heavy, design: .rounded))
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

                        if let challenge = currentChallenge {
                            if !show {
                                ChallengeItem(namespace: namespace, show: $show, currentChallange: challenge)
                            } else {
                                ChallengeView(namespace: namespace, show: $show, currentChallange: challenge)
                            }
                        }

                        VStack(spacing: 0) {
                            ForEach(postViewModel.viewModelPosts) { post in
                                FeedView(post: post)
                            }
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize)

                VStack {
                    Spacer().frame(height: 80)
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.currentViewShowing = "social"
                            }
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
                            .textCase(.uppercase)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.currentViewShowing = "profile"
                            }
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
                .zIndex(1)

                VStack {
                    Spacer()
                    Button(action: {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            showCamera = true
                        } else {
                            print("Camera not available")
                        }
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .offset(y: -20)
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationDestination(isPresented: $showProfile) {}
            .navigationDestination(isPresented: $showSocial) {}
            .sheet(isPresented: $showCamera) {
                CameraView(selectedImage: $selectedImage)
                    .preferredColorScheme(.dark)
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
                    PostView(image: image, currentViewShowing: $currentViewShowing)
                        .preferredColorScheme(.dark)
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
        }
    }

    
    func setCurrentChallenge() {
        userViewModel.fetchUserChallengeID { challengeID in
            if let challengeID = challengeID {
                print("User's current challenge ID: \(challengeID)")
                currentChallengeViewmodel.fetchCurrentChallenge(challengeID: challengeID) { challenge in
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

    func onCountdownReset() {
        userViewModel.randomizeUserDailyChallenges()
        setCurrentChallenge()
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
                onCountdownReset()
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
