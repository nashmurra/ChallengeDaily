import SwiftUI

struct StartView: View {
    
    @AppStorage("uid") var userID: String = ""  // Tracks if user is logged in
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(red: 24/255, green: 25/255, blue: 27/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer().frame(height: 180)
                    
                    // Title
                    Text("Welcome\nto Thriv")
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                    
                    // Buttons stack
                    VStack(spacing: 12) {
                        
                        // Log In
                        NavigationLink {
                              LoginView()
                        } label: {
                            Text("Log In")
                                .fontWeight(.medium)
                                .foregroundColor(Color(red: 23/255, green: 25/255, blue: 26/255))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 87/255, green: 200/255, blue: 255/255))
                                .frame(height: 42)
                                .cornerRadius(5)
                                .font(.system(size: 16, weight: .medium))
                        }
                        
                        NavigationLink {
                            NameView()// 👈 navigate to Name screen
                        } label: {
                            Text("Sign Up")
                                .fontWeight(.medium)
                                .foregroundColor(Color(red: 250/255, green: 250/255, blue: 250/255))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 39/255, green: 40/255, blue: 43/255))
                                .frame(height: 42)
                                .cornerRadius(5)
                                .font(.system(size: 16, weight: .medium))
                        }
                        
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    StartView()
        .preferredColorScheme(.dark)
}
