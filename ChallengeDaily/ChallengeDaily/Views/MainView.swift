import PhotosUI
import SwiftUI

struct MainView: View {
    //@Binding var currentViewShowing: String
    
    

    @State private var showProfile = false
    @State private var showSocial = false
    @State private var timeRemaining = 0
    @State var showCamera: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var navigateToPostView: Bool = false

    @State private var selectedView: String = "Dashboard"
    
    //@State private var selectedImage: UIImage? = nil
    //@State private var navigateToPostView: Bool = false
    @StateObject private var currentChallengeViewmodel = ChallengeViewModel()
    @StateObject private var postViewModel = PostViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @State var currentChallenge: Challenge?  // Make it optional

    @Namespace var namespace
    @State var show = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                Rectangle()
                    .fill(.thinMaterial)
                                .ignoresSafeArea()
                //Color.creamColor
                    //.ignoresSafeArea()

                VStack {
                    
                    Spacer().frame(height: 90)
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button(action: { selectedView = "Dashboard" }) {
                                Text("Dashboard")
                                    .fontWeight(.semibold)
                                    .foregroundColor(
                                        selectedView == "Dashboard"
                                        ? Color.red : Color.red.opacity(0.3)
                                    )
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    .background(
                                        Color.clear
                                    )
                                    .cornerRadius(10)
                            }
                            
                            Spacer()

                            Button(action: { selectedView = "Timeline" }) {
                                Text("Timeline")
                                    .fontWeight(.semibold)
                                    .foregroundColor(
                                        selectedView == "Timeline"
                                            ? Color.red : Color.red.opacity(0.3)
                                    )
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    .background(
                                        Color.clear
                                    )
                                    .cornerRadius(10)
                            }
                            
                            Spacer()
                        }
                        //.padding()
                        
                        Divider()

                        Spacer()

                        if selectedView == "Dashboard" {
                            if let challenge = currentChallenge {
                                DashboardView(showCamera: $showCamera, currentChallange: challenge)
                            }
                        } else {
                            ScrollView {
                                VStack(spacing: 0) {
                                    ForEach(postViewModel.viewModelPosts) { post in
                                        FeedView(post: post)
                                    }
                                    
                                }
                            }
                            .scrollBounceBehavior(.basedOnSize)
                        }

                        Spacer()
                    }
                    //.safeAreaInset(edge: .top) { Color.clear.frame(height: 80) }
                    .background(.ultraThinMaterial)

                    
                }

                VStack {
                    Spacer().frame(height: 80)
                    HStack {
                        //                        Button(action: {
                        //                            withAnimation {
                        //                                //self.currentViewShowing = "social"
                        //                            }
                        //                        }) {
                        //                            Image(systemName: "person.2.fill")
                        //                                .resizable()
                        //                                .frame(width: 35, height: 25)
                        //                                .foregroundColor(.white)
                        //                        }
                        Spacer()
                        Text("TC.")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.red)
                            .textCase(.uppercase)
                        Spacer()
                        //                        Button(action: {
                        //                            withAnimation {
                        //                                //self.currentViewShowing = "profile"
                        //                            }
                        //                        }) {
                        //                            Image(systemName: "person.crop.circle.fill")
                        //                                .resizable()
                        //                                .frame(width: 30, height: 30)
                        //                                .foregroundColor(.white)
                        //                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 60)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .zIndex(1)

                VStack {
                    Spacer()
                    
                }
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
//        userViewModel.fetchUserChallengeID { challengeID in
//            if let challengeID = challengeID {
//                print("User's current challenge ID: \(challengeID)")
//                currentChallengeViewmodel.fetchCurrentChallenge(challengeID: challengeID) { challenge in
//                    if let challenge = challenge {
//                        DispatchQueue.main.async {
//                            self.currentChallenge = challenge
//                        }
//                        print("Fetched challenge: \(challenge.title)")
//                    } else {
//                        print("Challenge not found")
//                    }
//                }
//            } else {
//                print("User has no current challenge ID assigned.")
//            }
//        }
    }

    func onCountdownReset() {
        //userViewModel.randomizeUserDailyChallenges()
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



#Preview {
    ContentView()
        .preferredColorScheme(.light)
}
