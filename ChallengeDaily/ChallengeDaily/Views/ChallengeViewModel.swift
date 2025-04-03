import FirebaseFirestore
import FirebaseAuth
import Combine

class ChallengeViewModel: ObservableObject {
    @Published var dailyChallenges: [Challenge] = []
    @Published var currentChallenge: Challenge? // Stores the active challenge
    
    private let db = Firestore.firestore()
    
    func fetchUserChallenges() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user signed in.")
            return
        }

        let userRef = db.collection("users").document(userID)

        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data(),
                  let challengeIDs = data["challenges"] as? [String],
                  let lastUpdated = data["lastUpdated"] as? String else {
                print("No challenges found for user, assigning new ones...")
                self.assignNewChallenges(for: userRef)
                return
            }

            let today = self.getFormattedDate()
            if today != lastUpdated {
                print("New day detected, assigning new challenges...")
                self.assignNewChallenges(for: userRef)
            } else {
                self.fetchChallengesByIDs(challengeIDs)
            }
        }
    }

    private func assignNewChallenges(for userRef: DocumentReference) {
        db.collection("challenges").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching challenges: \(error.localizedDescription)")
                return
            }

            let allChallenges = snapshot?.documents.map { $0.documentID } ?? []
            let randomChallenges = allChallenges.shuffled().prefix(4) // Pick 4 random

            userRef.updateData([
                "challenges": Array(randomChallenges),
                "lastUpdated": self.getFormattedDate()
            ]) { error in
                if let error = error {
                    print("Error updating user challenges: \(error.localizedDescription)")
                    return
                }
                self.fetchChallengesByIDs(Array(randomChallenges))
            }
        }
    }

    private func fetchChallengesByIDs(_ challengeIDs: [String]) {
        let challengeRefs = challengeIDs.map { db.collection("challenges").document($0) }

        let group = DispatchGroup()
        var fetchedChallenges: [Challenge] = []

        for ref in challengeRefs {
            group.enter()
            ref.getDocument { snapshot, error in
                defer { group.leave() }
                guard let data = snapshot?.data() else { return }

                let challenge = Challenge(
                    id: snapshot?.documentID ?? "",
                    challengeID: snapshot?.documentID ?? "",
                    challengeType: data["challengeType"] as? String ?? "No challenge type",
                    creator: data["creator"] as? String ?? "No creator",
                    title: data["title"] as? String ?? "No title",
                    instructions: data["instructions"] as? String ?? "No instructions",
                    hint: data["hint"] as? String ?? "No hint",
                    icon: data["image"] as? String ?? "No image"
                    
                )

                fetchedChallenges.append(challenge)
            }
        }

        group.notify(queue: .main) {
            self.dailyChallenges = fetchedChallenges
            self.currentChallenge = fetchedChallenges.randomElement()
        }
    }
    
    func fetchChallengeByID(_ challengeID: String, completion: @escaping (Challenge?) -> Void) {
        let challengeRef = db.collection("challenges").document(challengeID)
        
        challengeRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching challenge: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = snapshot?.data() else {
                print("Challenge not found.")
                completion(nil)
                return
            }
            
            let challenge = Challenge(
                id: snapshot?.documentID ?? "",
                challengeID: snapshot?.documentID ?? "",
                challengeType: data["challengeType"] as? String ?? "No challenge type",
                creator: data["creator"] as? String ?? "No creator",
                title: data["title"] as? String ?? "No title",
                instructions: data["instructions"] as? String ?? "No instructions",
                hint: data["hint"] as? String ?? "No hint",
                icon: data["image"] as? String ?? "No image"
            )
            
            completion(challenge)
        }
    }


    private func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
