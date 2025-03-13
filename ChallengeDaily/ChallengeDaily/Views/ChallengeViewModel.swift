import FirebaseFirestore
import FirebaseAuth
import Combine

class ChallengeViewModel: ObservableObject {
    @Published var dailyChallenges: [Challenge] = []
    
    func fetchDailyChallenges() {
        let db = Firestore.firestore()
        db.collection("challenges")
            .whereField("challengeType", isEqualTo: "daily")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching challenges: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.dailyChallenges = snapshot?.documents.compactMap { doc in
                        let data = doc.data()
                        return Challenge(
                            id: doc.documentID,
                            challengeType: data["challengeType"] as? String ?? "No challenge type",
                            creator: data["creator"] as? String ?? "No creator",
                            title: data["title"] as? String ?? "No title",
                            instructions: data["instructions"] as? String ?? "No instructions",
                            hint: data["hint"] as? String ?? "No hint"
                        )
                    } ?? []
                }
            }
    }
}
