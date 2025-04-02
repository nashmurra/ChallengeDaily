import FirebaseFirestore
import FirebaseAuth
import Combine

class ChallengeViewModel: ObservableObject {
    @Published var dailyChallenges: [Challenge] = []
        @Published var currentChallenge: Challenge? // This stores the active challenge
        //@Published var challengesOfTheDay: [Challenge] = []

    func fetchDailyChallenges(for date: Date) {
        let db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        db.collection("challenges")
            .whereField("challengeType", isEqualTo: "daily")
            .whereField("dates", arrayContains: dateString) // Check if the date exists in the array
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching challenges: \(error.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    self.dailyChallenges = snapshot?.documents.compactMap { doc in
                        let data = doc.data()
                        return Challenge(
                            id: "",
                            challengeID: doc.documentID,
                            challengeType: data["challengeType"] as? String ?? "No challenge type",
                            creator: data["creator"] as? String ?? "No creator",
                            title: data["title"] as? String ?? "No title",
                            instructions: data["instructions"] as? String ?? "No instructions",
                            hint: data["hint"] as? String ?? "No hint"
                        )
                    } ?? []

                    // Pick a random challenge if available
                    self.currentChallenge = self.dailyChallenges.randomElement()
                    
                }
            }
    }

    
    func fetchCurrentChallenge(challengeID: String, completion: @escaping (Challenge?) -> Void) {
        let db = Firestore.firestore()
        db.collection("challenges").document(challengeID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching challenge: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let document = snapshot, document.exists, let data = document.data() else {
                print("Challenge not found")
                completion(nil)
                return
            }
            
            let challenge = Challenge(
                id: document.documentID,
                challengeID: document.documentID,
                challengeType: data["challengeType"] as? String ?? "No challenge type",
                creator: data["creator"] as? String ?? "No creator",
                title: data["title"] as? String ?? "No title",
                instructions: data["instructions"] as? String ?? "No instructions",
                hint: data["hint"] as? String ?? "No hint"
            )
            
            DispatchQueue.main.async {
                completion(challenge)
            }
        }
    }

}
