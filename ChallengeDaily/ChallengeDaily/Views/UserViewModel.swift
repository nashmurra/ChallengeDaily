import FirebaseFirestore
import FirebaseAuth
import Combine
//import SwiftUI

class UserViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published private var currentChallengeViewmodel = ChallengeViewModel()
    
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
    
    func fetchUserChallengeID(completion: @escaping (String?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let document = snapshot, document.exists, let data = document.data() else {
                print("User document not found")
                completion(nil)
                return
            }

            let challengeID = data["currentChallengeID"] as? String
            completion(challengeID)
        }
    }

    
    
    

}
