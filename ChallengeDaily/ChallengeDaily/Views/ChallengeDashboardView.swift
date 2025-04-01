import SwiftUI

struct ChallengeDashboardView: View {
    @AppStorage("uid") var userID: String = ""

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
                            ExtractedView(backgroundColor: Color.purpleColor)
                                .padding(.leading, 40)
                            
                            Spacer()
                            
                            ExtractedView(backgroundColor: Color.pinkColor)
                                .padding(.trailing, 40)
                        }
                        
                        HStack {
                            ExtractedView(backgroundColor: Color.yellowColor)
                                .padding(.leading, 40)
                            
                            Spacer()
                            
                            ExtractedView(backgroundColor: Color.blueColor)
                                .padding(.trailing, 40)
                        }
                        
                        
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct ExtractedView: View {
    var backgroundColor: Color  // New parameter for background color

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

            Text("Unspoken Standoff")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)

            Text("25% of users")
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
