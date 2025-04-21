//
//  NotificationManager.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 4/18/25.
//

import Foundation
import FirebaseFirestore
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}

    func getUserNotificationSettings(for userId: String, completion: @escaping ([String: Bool]) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in
            guard let data = document?.data(),
                  let notifications = data["notifications"] as? [String: Bool],
                  error == nil else {
                print("DEBUG: Failed to fetch notifications settings")
                completion([:])
                return
            }
            completion(notifications)
        }
    }
    
    func triggerNotification(for key: String, userId: String) {
        getUserNotificationSettings(for: userId) { settings in
            guard settings[key] == true else {
                print("DEBUG: Notification for \(key) is disabled")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = "You have a new \(key)"
            content.body = "This is a notification about your \(key.lowercased())."
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "\(key)-\(UUID())", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("DEBUG: Failed to schedule notification: \(error.localizedDescription)")
                } else {
                    print("DEBUG: \(key) notification sent")
                }
            }
        }
    }
}
