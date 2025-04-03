import SwiftUI

struct ChallengeDashboardView: View {
    @AppStorage("uid") var userID: String = ""
    @StateObject private var challengeViewModel = ChallengeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                ScrollView {
                    VStack {
                        Spacer().frame(height: 80)

                        VStack(spacing: 20) {
                            let challenges = challengeViewModel.dailyChallenges
                            
                            if challenges.count >= 1 {
                                HStack {
                                    if challenges.indices.contains(0) {
                                        NavigationLink(destination: DetailView(backgroundColor: Color.purpleColor, currentChallenge: challenges[0])) {
                                            ChallengeItem(backgroundColor: Color.purpleColor, currentChallenge: challenges[0])
                                        }
                                        .padding(.leading, 40)
                                    }

                                    Spacer()

                                    if challenges.indices.contains(1) {
                                        NavigationLink(destination: DetailView(backgroundColor: Color.pinkColor, currentChallenge: challenges[1])) {
                                            ChallengeItem(backgroundColor: Color.pinkColor, currentChallenge: challenges[1])
                                        }
                                        .padding(.trailing, 40)
                                    }
                                }

                                HStack {
                                    if challenges.indices.contains(2) {
                                        NavigationLink(destination: DetailView(backgroundColor: Color.yellowColor, currentChallenge: challenges[2])) {
                                            ChallengeItem(backgroundColor: Color.yellowColor, currentChallenge: challenges[2])
                                        }
                                        .padding(.leading, 40)
                                    }

                                    Spacer()

                                    if challenges.indices.contains(3) {
                                        NavigationLink(destination: DetailView(backgroundColor: Color.blueColor, currentChallenge: challenges[3])) {
                                            ChallengeItem(backgroundColor: Color.blueColor, currentChallenge: challenges[3])
                                        }
                                        .padding(.trailing, 40)
                                    }
                                }
                            }
                        }

                        Spacer()
                    }
                }
            }
            .onAppear {
                challengeViewModel.fetchUserChallenges()
            }
        }
    }
}

struct ChallengeItem: View {
    var backgroundColor: Color  // New parameter for background color
    var currentChallenge: Challenge

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "ellipsis")
                    .resizable()
                    .rotationEffect(.degrees(90))  // Rotates the image 90 degrees to make it vertical
                    .frame(width: 20, height: 4)  // Adjusted aspect ratio for a vertical ellipsis
                    .foregroundColor(Color.black.opacity(0.5))
                    .padding(.leading, 140)
            }

            Image(systemName: currentChallenge.icon)
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(Color.white)

            Text(currentChallenge.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)

            Text(currentChallenge.creator)
                .font(.subheadline)
                .fontWeight(.regular)
                .foregroundColor(Color.white)
        }
        .frame(width: 170, height: 190)
        .padding(0)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)  // Use the passed color
        )
    }
}
