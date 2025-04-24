import FirebaseFirestore
import FirebaseAuth
import Combine

class PostViewModel: ObservableObject {
    @Published var viewModelPosts: [Post] = []
    var userViewModel = UserViewModel()

    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("feed")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching feed: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                var posts: [Post] = []
                let dispatchGroup = DispatchGroup()

                for doc in documents {
                    let data = doc.data()
                    let timestamp = data["createdAt"] as? Timestamp ?? Timestamp()
                    let userID = data["userID"] as? String ?? "No userID"

                    dispatchGroup.enter()
                    self.userViewModel.fetchUserByID(userID: userID) { user in
                        let username = user?.username ?? "Unknown User"

                        let post = Post(
                            username: username,
                            challengeName: data["challengeName"] as? String ?? "no challengeName",
                            image: data["image"] as? String ?? "no image",
                            createdAt: timestamp.dateValue()
                        )

                        posts.append(post)
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.viewModelPosts = posts
                }
            }
    }
    
    

    func fetchPostsForUser(userID: String) {
        let db = Firestore.firestore()
        db.collection("feed")
            .whereField("userID", isEqualTo: userID)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user's posts: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                var posts: [Post] = []
                let dispatchGroup = DispatchGroup()

                for doc in documents {
                    let data = doc.data()
                    let timestamp = data["createdAt"] as? Timestamp ?? Timestamp()

                    dispatchGroup.enter()
                    self.userViewModel.fetchUserByID(userID: userID) { user in
                        let username = user?.username ?? "Unknown User"

                        let post = Post(
                            username: username,
                            challengeName: data["challengeName"] as? String ?? "no challengeName",
                            image: data["image"] as? String ?? "no image",
                            createdAt: timestamp.dateValue()
                        )

                        posts.append(post)
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.viewModelPosts = posts
                }
            }
    }
}
