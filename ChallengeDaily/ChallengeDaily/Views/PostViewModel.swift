import FirebaseFirestore
import FirebaseAuth
import Combine

class PostViewModel: ObservableObject {
    @Published var viewModelPosts: [Post] = []
    @Published var todaysPost: Post? = nil
    private let userViewModel = UserViewModel.shared

    // Fetch all posts for the feed
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

    // Fetch all posts for a specific user
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
    
    // Fetch the post made by the user today
    func fetchTodaysPost() {
            guard let uid = Auth.auth().currentUser?.uid else {
                print("❌ No user logged in")
                return
            }
            
            // Get the start of the current day (midnight)
            let startOfDay = Calendar.current.startOfDay(for: Date())
            print("🔍 Start of Day: \(startOfDay)")
            
            let db = Firestore.firestore()
            db.collection("feed")
                .whereField("userID", isEqualTo: uid)
                .whereField("createdAt", isGreaterThanOrEqualTo: Timestamp(date: startOfDay)) // Filtering by today's posts
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("❌ Error fetching today's post: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("❌ No posts found for today.")
                        self.todaysPost = nil
                        return
                    }
                    
                    // Check if there's a document from today
                    if let document = documents.first {
                        let data = document.data()
                        let timestamp = data["createdAt"] as? Timestamp ?? Timestamp()
                        print("🔍 Post Timestamp: \(timestamp.dateValue())")
                        
                        // Fetch the username and other post details
                        self.userViewModel.fetchUserByID(userID: uid) { user in
                            let username = user?.username ?? "Unknown User"

                            self.todaysPost = Post(
                                username: username,
                                challengeName: data["challengeName"] as? String ?? "No challenge",
                                image: data["image"] as? String ?? "No image",
                                createdAt: timestamp.dateValue()
                            )
                            print("📸 Today's Post: \(String(describing: self.todaysPost))")
                        }
                    } else {
                        print("❌ No post made today by the user.")
                        self.todaysPost = nil
                    }
                }
        }
}
