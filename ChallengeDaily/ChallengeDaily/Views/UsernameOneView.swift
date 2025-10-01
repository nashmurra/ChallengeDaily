import SwiftUI

struct UsernameOneView: View {
    
    @EnvironmentObject var signUpData: SignUpData
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case firstName
        case lastName
    }
    
    var body: some View {
        ZStack {
            Color(red: 24/255, green: 25/255, blue: 27/255)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 20) {
                
                // MARK: - Custom Back Button + Titles
                HStack(alignment: .top, spacing: 12) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Create Account")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Step 2 of 4")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer().frame(width: 20)
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer().frame(height: 110)
                
                // MARK: - Username Display
                VStack(alignment: .center, spacing: 10) {
                    Text("Your username is")
                        .foregroundColor(.gray)
                        .font(.system(size: 18, weight: .medium))
                    
                    Text(signUpData.username)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // 👇 NavigationLink to UsernameTwo
                    NavigationLink(destination: UsernameTwoView()) {
                        Text("Change my username")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 87/255, green: 200/255, blue: 255/255))
                    }
                    
                    Text("You will be able to change this later in settings")
                        .foregroundColor(.gray.opacity(0.9))
                        .font(.system(size: 12, weight: .medium))
                }
                
                Spacer()
                
                // MARK: - Footer
                VStack {
                    NavigationLink(destination: PasswordView()) {
                            Text("Continue")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor((signUpData.firstName.isEmpty || signUpData.lastName.isEmpty) ?
                                    .white :
                                    Color(red: 23/255, green: 25/255, blue: 26/255))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background((signUpData.firstName.isEmpty || signUpData.lastName.isEmpty) ?
                                            Color(red: 50/255, green: 50/255, blue: 50/255) :
                                            Color(red: 87/255, green: 200/255, blue: 255/255))
                                .frame(height: 45)
                                .cornerRadius(5)
                        }
                        .padding(.bottom, 15)
                        //.disabled(firstName.isEmpty || lastName.isEmpty) // stays disabled if empty
                }
            }
            .padding(.horizontal, 30)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                focusedField = .firstName
            }
        }
    }
}

#Preview {
    NavigationStack {
        UsernameOneView()
            .environmentObject(SignUpData())
            .preferredColorScheme(.dark)
    }
}

