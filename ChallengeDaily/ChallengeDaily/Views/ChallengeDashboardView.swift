import SwiftUI

struct ChallengeDashboardView: View {
    @AppStorage("uid") var userID: String = ""
    @StateObject private var currentChallengeViewmodel = ChallengeViewModel()

    var body: some View {
        ZStack {
            Image("appBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack {
                    
                    Spacer().frame(height: 80)
                    
                    VStack(spacing: 20) {
                        HStack {
                            ChallengeItem(backgroundColor: Color.purpleColor)
                                .padding(.leading, 40)
                            
                            Spacer()
                            
                            ChallengeItem(backgroundColor: Color.pinkColor)
                                .padding(.trailing, 40)
                        }
                        
                        HStack {
                            ChallengeItem(backgroundColor: Color.yellowColor)
                                .padding(.leading, 40)
                            
                            Spacer()
                            
                            ChallengeItem(backgroundColor: Color.blueColor)
                                .padding(.trailing, 40)
                        }
                        
                        
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            currentChallengeViewmodel.fetchDailyChallenges(for: Date())
        }
    }
}

struct ChallengeItem: View {
    var backgroundColor: Color  // New parameter for background color
    var challenge: Challenge

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

            Image(systemName: "timer")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(Color.white)

            Text(challenge.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)

            Text(challenge.creator)
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
