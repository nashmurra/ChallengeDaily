//
//  Item.swift
//  ChallengeDaily
//
//  Created by HPro2 on 1/27/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
