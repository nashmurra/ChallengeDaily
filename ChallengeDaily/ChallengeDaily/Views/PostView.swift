import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct PostView: View {
    var image: UIImage?
    @State private var navigateToMain = false  // State to trigger navigation
    //@Binding var currentViewShowing: String

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
                if let image = image, let base64String = encodeImageToBase64(image: image) {
                    let db = Firestore.firestore()
                    db.collection("feed").document(UUID().uuidString).setData([
                        "caption": "caption here",
                        "challengeID": "challengeID",
                        "image": base64String,
                        "createdAt": Timestamp(),
                        "likes": 4,  // Default settings
                        "userID": "userID"
                    ], merge: true) { error in
                        if let error = error {
                            print("Error creating feed document: \(error.localizedDescription)")
                        } else {
                            print("Feed document created successfully!")
                            DispatchQueue.main.async {
                                navigateToMain = true  // Set state to trigger navigation
                                //self.currentViewShowing = "main"
                            }
                        }
                    }
                } else {
                    print("Failed to encode image")
                }
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
        .navigationDestination(isPresented: $navigateToMain) {
            MainView()  // Navigate to MainView after posting
        }
    }

    func encodeImageToBase64(image: UIImage) -> String? {
        if let imageData = image.jpegData(compressionQuality: 0.7) {
            return imageData.base64EncodedString()
        }
        return nil
    }
}
