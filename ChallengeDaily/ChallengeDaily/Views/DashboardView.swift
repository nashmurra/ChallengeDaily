import SwiftUI
import FirebaseAuth
import PhotosUI

struct DashboardView: View {
    
    @Binding var showCamera: Bool
    
    @State private var timeRemaining = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var currentChallange: Challenge
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {  // Align Center
//            Text(timeString(from: timeRemaining))
//                .font(.system(size: 50, weight: .heavy, design: .rounded))
//                .fontWeight(.bold)
//                .frame(maxWidth: .infinity)
//                .textCase(.uppercase)
//                .padding(60)
            
            Spacer().frame(height: 50)
            
            HStack {
                Image(systemName: "face.smiling")
                    .resizable()
                    .foregroundColor(Color.accentColor)
                    .frame(width: 90, height: 90, alignment: .leading)
                    
                
                Spacer()
            }
            .padding()
            .padding(.horizontal)
            
            

            Text(currentChallange.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.primaryAccent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.horizontal)
            
            Text("Daily Challenge")
                .font(.body)
                .fontWeight(.semibold)
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.horizontal)

            Divider()
            
//            HStack {
//                Spacer()
//                Image(systemName: "person.2.fill")
//                    .resizable()
//                    .frame(width: 36, height: 26)
//                    .cornerRadius(10)
//                    .padding(8)
//                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
//                Text("Idea by Jonathan Krolak")
//                    .font(.footnote)
//                Spacer()
//            }

            Text(currentChallange.instructions)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(0.6)
                .padding(.horizontal)
                .padding(.horizontal)

            Spacer() // Pushes content upwards

            Button {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    showCamera = true
                } else {
                    print("Camera not available")
                }
            } label: {
                Text("Make a Post")
                    .foregroundColor(Color.primaryAccent)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(17)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.primaryAccent, lineWidth: 3))
                    .padding(.horizontal, 80)
            }

            Spacer() // Ensures even spacing at the bottom
        }
        .padding(20)
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
