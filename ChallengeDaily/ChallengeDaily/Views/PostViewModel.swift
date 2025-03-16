import FirebaseFirestore
import FirebaseAuth
import Combine

class PostViewModel: ObservableObject {
    @Published var viewModelPosts: [Post] = []
    //@Published var currentChallenge: Challenge? // This stores the active challenge

    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("feed")
            //.whereField("challengeType", isEqualTo: "daily")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching feed: \(error.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    self.viewModelPosts = snapshot?.documents.compactMap { doc in
                        let data = doc.data()
                        return Post(
                            username: data["userID"] as? String ?? "No userID",
                            image: data["image"] as? String ?? "no image"
                            
                            //id: String: data["creator"] as? String ?? "No creator"
                        )
                    } ?? []

                    // Pick a random challenge if available
                    //self.currentChallenge = self.dailyChallenges.randomElement()
                }
            }
    }
}
