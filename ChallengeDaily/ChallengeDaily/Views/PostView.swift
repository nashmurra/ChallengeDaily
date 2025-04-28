import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct PostView: View {
    var image: UIImage?
    @Environment(\.dismiss) private var dismiss  // To dismiss the view
    @State private var animateImage = false
    @State private var animateButton = false
    @State private var animateXmark = false
    
    @StateObject private var currentChallengeViewmodel = ChallengeViewModel()
    private let userViewModel = UserViewModel.shared
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("appBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Today's Challenge")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .opacity(animateImage ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.1), value: animateImage)
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 320, maxHeight: 400)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .offset(y: animateImage ? 0 : 100)
                        .opacity(animateImage ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: animateImage)
                } else {
                    Text("❌ No Image Found")
                        .foregroundColor(.red)
                }

                Spacer()

                Button(action: postImage) {
                    HStack {
                        Text("POST")
                            .fontWeight(.bold)
                            .padding(.vertical, 12)
                        Image(systemName: "arrow.right")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    )
                    .foregroundColor(.black)
                }
                .padding(.horizontal, 40)
                .scaleEffect(animateButton ? 1 : 0.8)
                .opacity(animateButton ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.5), value: animateButton)

                Spacer()
            }
            .padding()

            // Xmark dismiss button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .scaleEffect(animateXmark ? 1 : 0.5)
                    .opacity(animateXmark ? 1 : 0)
                    .animation(.easeOut(duration: 0.3).delay(0.1), value: animateXmark)
            }
            .padding(.leading, 20)
            .padding(.top, 60)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            animateImage = true
            animateButton = true
            animateXmark = true
        }
    }
    
    private func postImage() {
        guard let image = image, let base64String = encodeImageToBase64(image: image) else {
            print("Failed to encode image")
            return
        }
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        userViewModel.fetchUserChallengeID { challengeID in
            if let challengeID = challengeID {
                currentChallengeViewmodel.fetchChallengeByID(challengeID) { challenge in
                    let challengeNameFromDatabase = challenge?.title ?? "No Challenge Name Found"
                    
                    let db = Firestore.firestore()
                    db.collection("feed").document(UUID().uuidString).setData([
                        "caption": "caption here",
                        "challengeID": challengeID,
                        "image": base64String,
                        "createdAt": Timestamp(),
                        "likes": 4,
                        "userID": userID,
                        "challengeName": challengeNameFromDatabase
                    ], merge: true) { error in
                        if let error = error {
                            print("Error creating feed document: \(error.localizedDescription)")
                        } else {
                            print("✅ Feed document created successfully!")
                            dismiss()
                        }
                    }
                }
            } else {
                print("User has no current challenge ID assigned.")
            }
        }
    }
    
    private func encodeImageToBase64(image: UIImage) -> String? {
        if let imageData = image.jpegData(compressionQuality: 0.7) {
            return imageData.base64EncodedString()
        }
        return nil
    }
}
