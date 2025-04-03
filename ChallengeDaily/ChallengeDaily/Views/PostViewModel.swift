import FirebaseFirestore
import FirebaseAuth
import Combine

class PostViewModel: ObservableObject {
    @Published var viewModelPosts: [Post] = []
    var userViewModel = UserViewModel()

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
                        
                        self.userViewModel.fetchCurrentUser()
                        
                        return Post(
                            username: self.userViewModel.username as? String ?? "No userID",
                            challengeName: data["challengeName"] as? String ?? "no challengeName",
                            image: data["image"] as? String ?? "no image",
                            createdAt: timestamp.dateValue()
                        )
                    } ?? []
                }
            }
    }
}
