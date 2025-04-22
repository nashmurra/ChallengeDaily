import SwiftUI
import FirebaseFirestore

struct Post: Identifiable, Codable {
    var id = UUID()
    let username: String
    let challengeName: String
    let image: String
    let createdAt: Date
}
