import FirebaseFirestore
import FirebaseAuth
import Combine

class UserViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    private var tempUserSession: FirebaseAuth.User?
    
    func fetchCurrentUser() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else { return }
            
            let data = document.data()
            DispatchQueue.main.async {
                self.username = data["username"] as? String ?? "Unknown"
                self.email = data["email"] as? String ?? "No Email"
            }
        }
    }
}
