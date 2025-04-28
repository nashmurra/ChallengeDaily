import SwiftUI
import PhotosUI

struct MainView: View {
    @StateObject private var currentChallengeViewmodel = ChallengeViewModel()
    @StateObject private var postViewModel = PostViewModel()
    private let userViewModel = UserViewModel.shared
    
    @State private var timeRemaining = 0
    @State private var showCamera: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var navigateToPostView: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
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

                    // Current challenge
                    if let currentChallenge = currentChallengeViewmodel.currentChallenge {
                        ZStack {
                            Circle()
                                .stroke(Color.white, lineWidth: 9)
                                .frame(width: 140, height: 140)

                            Image(systemName: currentChallenge.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color.white)
                        }

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

                        VStack(alignment: .center, spacing: 12) {
                            Text(currentChallenge.instructions)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .italic()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
                        )
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                    }

                    Spacer()

                    // Now check if user has posted today
                    if let todaysPost = postViewModel.todaysPost {
                        // User has posted today
                        VStack(spacing: 20) {
                            Text("You Posted Today! 🎉")
                                .font(.headline)
                                .foregroundColor(.white)

                            if let imageData = Data(base64Encoded: todaysPost.image),
                               let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 300)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                            }

//                            Text(todaysPost.caption)
//                                .foregroundColor(.white.opacity(0.8))
//                                .italic()
//                                .padding(.horizontal)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.ultraThinMaterial)
                                .shadow(radius: 10)
                        )
                        .padding(.horizontal, 30)
                        .padding(.bottom, 40)

                    } else {
                        // User has NOT posted yet
                        Button(action: {
                            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                                print("❌ Camera not available.")
                                return
                            }
                            showCamera = true
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
                    }

                    Spacer()
                }
                .padding(.horizontal)
            }
            .sheet(isPresented: $showCamera) {
                CameraView(selectedImage: $selectedImage)
                    .onDisappear {
                        if selectedImage != nil {
                            navigateToPostView = true
                        }
                    }
            }
            .navigationDestination(isPresented: $navigateToPostView) {
                if let image = selectedImage {
                    PostView(image: image)
                } else {
                    Text("⚠️ No image available")
                }
            }
            .onAppear {
                currentChallengeViewmodel.fetchUserChallenges()
                postViewModel.fetchTodaysPost()
                updateCountdown()
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // New day detected
                    currentChallengeViewmodel.fetchUserChallenges()
                    postViewModel.fetchTodaysPost()
                    updateCountdown()
                }
            }
        }
    }
    
    func updateCountdown() {
        let now = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        
        components.hour = 0
        components.minute = 0
        components.second = 0

        let timezone = TimeZone(identifier: "America/New_York") ?? TimeZone.current
        let offset = timezone.secondsFromGMT()

        guard let todayReset = calendar.date(from: components) else {
            print("❌ Failed to calculate reset time.")
            return
        }

        var utcResetDate = todayReset.addingTimeInterval(TimeInterval(-offset))

        if utcResetDate < now {
            components.day! += 1
            guard let nextDayReset = calendar.date(from: components) else {
                print("❌ Failed to calculate next day reset.")
                return
            }
            utcResetDate = nextDayReset.addingTimeInterval(TimeInterval(-offset))
        }

        let timeDifference = utcResetDate.timeIntervalSince(now)
        timeRemaining = max(0, Int(timeDifference))
    }
}
