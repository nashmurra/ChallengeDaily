import SwiftUI

struct UsernameTwoView: View {
    
    @EnvironmentObject var signUpData: SignUpData
    @Environment(\.dismiss) private var dismiss
    
    // 👇 Add focus states for each textfield
    @FocusState private var focusedField: Field?
    
    enum Field {
        case firstName
        case lastName
    }
    
    var body: some View {
        ZStack {
            Color(red: 24/255, green: 25/255, blue: 27/255)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
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
                .padding(.top, 10) // move it down a bit from very top
                
                Spacer().frame(height: 110)
                
                // MARK: - First Name
                VStack(alignment: .leading, spacing: 12) {
                    Text("Username")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .medium))
                    
                    TextField("Your username", text: $signUpData.username)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                                .background(Color.clear)
                        )
                        .focused($focusedField, equals: .firstName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .lastName // jump to last name
                        }
                        .autocorrectionDisabled(true)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                        
                        Text("Username is available")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                    }
                }
                //.padding(.horizontal)
                
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
        .navigationBarBackButtonHidden(true) // hide the system nav bar back
        .onAppear {
            // 👇 Automatically focus the first name when screen loads
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                focusedField = .firstName
            }
        }
    }
}

#Preview {
    NavigationStack {
        UsernameTwoView()
            .environmentObject(SignUpData())
            .preferredColorScheme(.dark)
    }
}
