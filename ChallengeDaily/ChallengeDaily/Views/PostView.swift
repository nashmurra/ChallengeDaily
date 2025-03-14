import SwiftUI

struct PostView: View {
    var image: UIImage?

    var body: some View {
        VStack(spacing: 16) {
            Text("Today's Challenge")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 400)
                                .background(Color.gray.opacity(0.3)) // Debug background
                                .cornerRadius(10)
            } else {
                Text("❌ No Image Found")
                    .foregroundColor(.red)
                
            }
            
            
            Button(action: {
                // Action for posting
            }) {
                HStack {
                    Text("POST")
                        .fontWeight(.bold)
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
