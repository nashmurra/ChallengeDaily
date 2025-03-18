import SwiftUI

struct FeedView: View {
    var post: Post

    var body: some View {
        ZStack {
            Color.backgroundDark
                .ignoresSafeArea()

            VStack {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.whiteText)

                    VStack {
                        Text(post.username)
                            .font(.callout)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Just now")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Spacer()
                    Image(systemName: "ellipsis")
                        .resizable()
                        .frame(width: 20, height: 5)
                        .foregroundColor(Color.whiteText)
                }
                .padding(.horizontal)

                if let uiImage = decodeBase64ToImage(post.image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .frame(height: 400)
                } else {
                    Text("Failed to load image")
                        .foregroundColor(.red)
                        .frame(height: 400)
                }

                Spacer().frame(height: 30)
            }
        }
    }

    // Function to decode Base64 string to UIImage
    func decodeBase64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String),
              let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }
}
