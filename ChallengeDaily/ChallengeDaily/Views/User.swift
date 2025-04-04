//
//  User.swift
//  ChallengeDaily
//
//  Created by HPro2 on 4/4/25.
//

import SwiftUI

class User {
    var username: String
    var email: String
    var darkMode: Bool
    var privateAccount: Bool
    var findFriendsWithContacts: Bool
    var contentFilter: String
    var profileImage: String
    var currentChallengeID: String
    var challenges: [String]
    var lastUpdated: String
    var notifications: [String: Bool]
    
    init(username: String, email: String, darkMode: Bool, privateAccount: Bool, findFriendsWithContacts: Bool, contentFilter: String, profileImage: String, currentChallengeID: String, challenges: [String], lastUpdated: String, notifications: [String: Bool]) {
        self.username = username
        self.email = email
        self.darkMode = darkMode
        self.privateAccount = privateAccount
        self.findFriendsWithContacts = findFriendsWithContacts
        self.contentFilter = contentFilter
        self.profileImage = profileImage
        self.currentChallengeID = currentChallengeID
        self.challenges = challenges
        self.lastUpdated = lastUpdated
        self.notifications = notifications
    }
}
