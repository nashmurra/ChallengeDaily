//
//  ChallengeDailyApp.swift
//  ChallengeDaily
//
//  Created by HPro2 on 1/27/25.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct ChallengeDailyApp: App {
    
    init() {
        
        // #if !DEBUG
        FirebaseApp.configure()
        //#endif
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(sharedModelContainer)
    }
}
