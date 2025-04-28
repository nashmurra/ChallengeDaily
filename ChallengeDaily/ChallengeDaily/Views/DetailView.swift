import SwiftUI

struct DetailView: View {
    @AppStorage("uid") var userID: String = ""

    // Example percentages
    let acceptedPercentage: Double = 25
    let completedPercentage: Double = 10
    
    var backgroundColor: Color  // New parameter for background color
    var currentChallenge: Challenge
    
    private let userViewModel = UserViewModel.shared
    
    @Environment(\.presentationMode) var presentationMode  // To control navigation back

    var body: some View {
        ZStack {
            Image("appBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer().frame(height: 60)

                ZStack {
                    Circle()
                        .stroke(backgroundColor, lineWidth: 9)
                        .frame(width: 140, height: 140)

                    Image(systemName: currentChallenge.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color.white)
                }

                Spacer().frame(height: 40)

                Text(currentChallenge.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                Spacer().frame(height: 10)

                Text(currentChallenge.instructions)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 55)
                
                Spacer().frame(height: 10)
                
                Text(currentChallenge.hint)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 60)
                
                Button {
                    
                    userViewModel.setCurrentChallenge(challenge: currentChallenge)
                    
                } label: {
                    Text("Accept Challenge")
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(17)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(backgroundColor)
                        )
                        .padding(.horizontal, 100)
                }

                Text("Warning: Once you accept, you can't cancel")
                    .font(.caption2)
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .padding(5)

                Spacer().frame(height: 30)

                // Dotted divider
                HStack(spacing: 15) {
                    ForEach(0..<15, id: \.self) { _ in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 7, height: 7)
                    }
                }
                .padding(.vertical, 20)
                
                Spacer().frame(height: 30)

                // HStack for circular gauges
                HStack(spacing: 50) {
                    CircularGauge(value: acceptedPercentage, label: "Accepted", color: backgroundColor)
                    CircularGauge(value: completedPercentage, label: "Completed", color: backgroundColor)
                }
                .padding(.bottom, 40)

                Spacer()
            }
        }
        .navigationTitle("Challenge")  // Set the navigation title
        .navigationBarTitleDisplayMode(.inline)  // Display title inline
        .navigationBarBackButtonHidden(true)  // Hide default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
            }
        }
    }
}


// Circular gauge view
struct CircularGauge: View {
    var value: Double
    var label: String
    var color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.darkBlueColor, lineWidth: 8) // Background circle

            Circle()
                .trim(from: 0, to: CGFloat(value / 100))
                .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90)) // Rotates to start from the top
                .animation(.easeOut(duration: 1), value: value)

            VStack {
                Text("\(Int(value))%")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .frame(width: 80, height: 80)
    }
}

