//
//  AchievementsView.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 3/4/25.
//

import SwiftUI

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isUnlocked: Bool
    var progress: Double // 0.0 to 1.0
    let icon: String
    
    mutating func checkProgress(currentProgress: Double) {
        progress = currentProgress
        if progress >= 1.0 {
            isUnlocked = true
        }
    }
    
}

struct AchievementsView: View {
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var achievements: [Achievement] = [
        Achievement(title: "First Challenge", description: "Complete your first challenge!", isUnlocked: true, progress: 1.0, icon: "star.fill"),
        Achievement(title: "10 Challenges Completed", description: "Finish 10 total challenges.", isUnlocked: false, progress: 0.9, icon: "checkmark.circle.fill"),
        Achievement(title: "50 Challenges Completed", description: "Finish 50 total challenges.", isUnlocked: false, progress: 0.6, icon: "checkmark.circle"),
        Achievement(title: "100 Challenges Completed", description: "Finish 100 total challenges.", isUnlocked: false, progress: 0.7, icon: "checkmark.seal.fill"),
        Achievement(title: "7-Day Streak", description: "Complete challenges for 7 days in a row.", isUnlocked: false, progress: 0.8, icon: "calendar"),
        Achievement(title: "30-Day Streak", description: "Complete challenges for 30 days in a row.", isUnlocked: false, progress: 0.4, icon: "flame"),
        Achievement(title: "50-Day Streak", description: "Complete challenges for 50 days in a row.", isUnlocked: false, progress: 0.5, icon: "flame.fill"),
        Achievement(title: "100-Day Streak", description: "Complete challenges for 100 days in a row.", isUnlocked: false, progress: 0.3, icon: "flame"),
        Achievement(title: "Challenge Master", description: "Complete a challenge every day for an entire year.", isUnlocked: false, progress: 0.1, icon: "trophy.fill")
    ]
    
    func updateAchievements() {
        for index in achievements.indices {
            achievements[index].checkProgress(currentProgress: achievements[index].progress)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("BackgroundScreen")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(achievements) { achievement in
                            HStack {
                                Image(systemName: achievement.icon)
                                    .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                                    .font(.title)
                                    .frame(width: 50, height: 50)
                                    .background(Circle().fill(Color(.systemGray6)))
                                    .shadow(radius: 3)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(achievement.title)
                                        .font(.headline)
                                        .foregroundColor(achievement.isUnlocked ? .primary : .gray)
                                    Text(achievement.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    ProgressView(value: achievement.progress)
                                        .progressViewStyle(LinearProgressViewStyle())
                                }
                                .padding(.leading, 10)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemGray5)))
                            .shadow(radius: 3)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Achievements")
                .frame(maxWidth: .infinity, alignment: .center)
                .onAppear {
                    updateAchievements()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                            Text("")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
    
}
#Preview {
    AchievementsView()
        .preferredColorScheme(.dark)
}
