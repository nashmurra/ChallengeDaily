import SwiftUI

struct MainView: View {
    @State private var showProfile = false // Controls ProfileView navigation
    @State private var showSocial = false  // Controls SocialView navigation

    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 10)

                ZStack {
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
                    }
                    .padding(.horizontal)

                    Text("Today's Challenge")
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.black)

                    HStack {
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
                }
                
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
