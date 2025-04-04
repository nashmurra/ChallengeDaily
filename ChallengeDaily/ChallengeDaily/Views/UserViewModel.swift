import Combine
import FirebaseAuth
import FirebaseFirestore

//import SwiftUI

class UserViewModel: ObservableObject {

    @Published private var currentChallengeViewmodel = ChallengeViewModel()
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var darkMode: Bool = false
    @Published var privateAccount: Bool = false
    @Published var findFriendsWithContacts: Bool = false
    @Published var contentFilter: String = "Everyone"
    @Published var profileImage: String = ""
    @Published var currentChallengeID: String = ""
    @Published var challenges: [String] = []
    @Published var lastUpdated: String = ""
    @Published var notifications: [String: Bool] = [:]

    private var tempUserSession: FirebaseAuth.User?

    func fetchCurrentUser() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }

            guard let document = snapshot, document.exists,
                let data = document.data()
            else {
                print("User document not found")
                return
            }

            DispatchQueue.main.async {
                self.username = data["username"] as? String ?? "Unknown"
                self.email = data["email"] as? String ?? "No Email"
                self.darkMode = data["darkMode"] as? Bool ?? false
                self.privateAccount = data["privateAccount"] as? Bool ?? false
                self.findFriendsWithContacts =
                    data["findFriendsWithContacts"] as? Bool ?? false
                self.contentFilter =
                    data["contentFilter"] as? String ?? "Everyone"
                self.profileImage = data["profileImage"] as? String ?? ""
                self.currentChallengeID =
                    data["currentChallengeID"] as? String ?? ""
                self.challenges = data["challenges"] as? [String] ?? []
                self.lastUpdated = data["lastUpdated"] as? String ?? ""
                self.notifications =
                    data["notifications"] as? [String: Bool] ?? [:]
            }
        }
    }
    
    func fetchUserByID(userID: String, completion: @escaping (User?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let document = snapshot, document.exists,
                  let data = document.data()
            else {
                print("User document not found")
                completion(nil)
                return
            }
            
            let user = User(
                username: data["username"] as? String ?? "Unknown",
                email: data["email"] as? String ?? "No Email",
                darkMode: data["darkMode"] as? Bool ?? false,
                privateAccount: data["privateAccount"] as? Bool ?? false,
                findFriendsWithContacts: data["findFriendsWithContacts"]
                as? Bool ?? false,
                contentFilter: data["contentFilter"] as? String ?? "Everyone",
                profileImage: data["profileImage"] as? String ?? "",
                currentChallengeID: data["currentChallengeID"] as? String ?? "",
                challenges: data["challenges"] as? [String] ?? [],
                lastUpdated: data["lastUpdated"] as? String ?? "",
                notifications: data["notifications"] as? [String: Bool] ?? [:]
            )
            
            completion(user)
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

            guard let document = snapshot, document.exists,
                let data = document.data()
            else {
                print("User document not found")
                completion(nil)
                return
            }

            let challengeID = data["currentChallenge"] as? String
            completion(challengeID)
        }
    }

    func setCurrentChallenge(challenge: Challenge) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userID)
            .setData(
                [
                    "currentChallenge": challenge.challengeID

                ], merge: true
            ) { error in
                if let error = error {
                    print(
                        "Error setting user challenge: \(error.localizedDescription)"
                    )
                } else {
                    print(
                        "User challenge set successfully!"
                    )
                }
            }
    }

}
