import SwiftUI
import FirebaseFirestore

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let image: String
    let createdAt: Date
}
