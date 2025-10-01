import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class SignUpData: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    
    @AppStorage("uid") var userID: String = ""
    
    func finishSignUp(completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid, let self = self else {
                completion(.failure(NSError(domain: "SignUp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing UID"])))
                return
            }
            
            // Save user info to Firestore
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "firstName": self.firstName,
                "lastName": self.lastName,
                "username": self.username,
                "email": self.email,
                "createdAt": Timestamp(date: Date())
            ]) { err in
                if let err = err {
                    completion(.failure(err))
                } else {
                    self.userID = uid
                    completion(.success(()))
                }
            }
        }
    }
}
