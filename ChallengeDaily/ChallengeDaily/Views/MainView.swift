import SwiftUI

struct MainView: View {
    @State private var showProfile = false
    @State private var showSocial = false
    @State private var timeRemaining = 0
    @StateObject private var currentChallengeViewmodel = ChallengeViewModel()
    @Namespace var namespace
    @State var show = false

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

                        if !show {
                            if let currentChallenge = currentChallengeViewmodel.currentChallenge {
                                ChallengeItem(namespace: namespace, show: $show, currentChallange: currentChallenge)
                            }
                            
                        } else {
                            if let currentChallenge = currentChallengeViewmodel.currentChallenge {
                                ChallengeView(namespace: namespace, show: $show, currentChallange: currentChallenge)
                            }
                        }

                        VStack(spacing: 0) {
                            FeedView()
                            FeedView()
                            FeedView()
                            FeedView()
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize)

                VStack {
                    Spacer().frame(height: 80)
                    HStack {
                        Button(action: {
                            showSocial = true
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
                            showProfile = true
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
            }
            .ignoresSafeArea(edges: .top)
            .navigationDestination(isPresented: $showProfile) {
                ProfileView()
            }
            .navigationDestination(isPresented: $showSocial) {
                SocialView()
            }
            .onAppear {
                updateCountdown()
                currentChallengeViewmodel.fetchDailyChallenges()
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    updateCountdown()
                }
            }
            .onReceive(currentChallengeViewmodel.$currentChallenge) { _ in
                // Triggers UI update when challenge updates
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

        if let resetTime = utcResetDate, resetTime < now {
            components.day! += 1
        }

        if let nextReset = calendar.date(from: components) {
            timeRemaining = Int(nextReset.timeIntervalSince(now))
        }
    }

    func timeString(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
