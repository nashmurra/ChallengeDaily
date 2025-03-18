import FirebaseFirestore
import FirebaseAuth
import Combine

class PostViewModel: ObservableObject {
    @Published var viewModelPosts: [Post] = []

    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("feed")
            .order(by: "createdAt", descending: true) // Sort posts by newest first
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching feed: \(error.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    self.viewModelPosts = snapshot?.documents.compactMap { doc in
                        let data = doc.data()
                        let timestamp = data["createdAt"] as? Timestamp ?? Timestamp()
                        return Post(
                            username: data["userID"] as? String ?? "No userID",
                            image: data["image"] as? String ?? "no image",
                            createdAt: timestamp.dateValue()
                        )
                    } ?? []
                }
            }
    }
}
