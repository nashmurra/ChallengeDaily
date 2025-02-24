import SwiftUI

struct MainView: View {
    @State private var showProfile = false // Controls ProfileView navigation
    @State private var showSocial = false  // Controls SocialView navigation

    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 10)

                HStack {
                    Button(action: {
                        showSocial = true // Navigate to SocialView
                    }) {
                        Image(systemName: "person.2.fill")
                            .resizable()
                            .frame(width: 35, height: 25)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Today's Challenge")
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.black)
                    Spacer()
                    Button(action: {
                        showProfile = true // Navigate to ProfileView
                    }) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)

                Spacer().frame(height: 20) // Adjust spacing

                VStack {
                    Text("Daily Challenge")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                //.padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )

                Spacer()
            }
            .navigationDestination(isPresented: $showProfile) {
                ProfileView()
            }
            .navigationDestination(isPresented: $showSocial) {
                SocialView()
            }
        }
    }
}
