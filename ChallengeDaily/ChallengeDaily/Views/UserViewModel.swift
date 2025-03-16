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

    
    
    func randomizeUserDailyChallenges() {
        let db = Firestore.firestore()
        
        // Fetch daily challenges
        currentChallengeViewmodel.fetchDailyChallenges()
        
        // Wait for dailyChallenges to be populated
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self, !self.currentChallengeViewmodel.dailyChallenges.isEmpty else {
                print("No challenges available to assign.")
                return
            }
            
            db.collection("users").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                for document in documents {
                    let userID = document.documentID
                    
                    // Pick a random challenge
                    if let randomChallenge = self.currentChallengeViewmodel.dailyChallenges.randomElement() {
                        db.collection("users").document(userID).updateData(["currentChallengeID": randomChallenge.challengeID]) { error in
                            if let error = error {
                                print("Error updating challenge for user \(userID): \(error.localizedDescription)")
                            } else {
                                print("Successfully assigned challenge \(randomChallenge.challengeID) to user \(userID)")
                            }
                        }
                    }
                }
            }
        }
    }

}
