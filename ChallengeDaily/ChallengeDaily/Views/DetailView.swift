import SwiftUI

struct DetailView: View {
    @AppStorage("uid") var userID: String = ""

    // Example percentages
    let acceptedPercentage: Double = 25
    let completedPercentage: Double = 10

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
                        .stroke(Color.purpleColor, lineWidth: 9)
                        .frame(width: 140, height: 140)

                    Image(systemName: "timer")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color.white)
                }

                Spacer().frame(height: 40)

                Text("Unspoken Standoff")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                Spacer().frame(height: 10)
                    //.padding(.bottom)

                Text("Start a stopwatch and stare at someone intently without saying a single thing")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 55)
                
                Spacer().frame(height: 10)
                    
                    //.padding()
                
                Text("Take a picture of the stopwatch with the person as proof")
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    //.padding(.top)
                    
                
                Spacer().frame(height: 60)
                
                Button {
                    // Placeholder for accept challenge action
                } label: {
                    Text("Accept Challenge")
                        .foregroundColor(Color.white) // Match the stroke color
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(17)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color.purpleColor, lineWidth: 3) // Outline stroke
//                        )
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.purpleColor) // Outline stroke
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
                    CircularGauge(value: acceptedPercentage, label: "Accepted", color: Color.purpleColor)
                    CircularGauge(value: completedPercentage, label: "Completed", color: Color.purpleColor)
                }
                .padding(.bottom, 40)

                Spacer()
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

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
