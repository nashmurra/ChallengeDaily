import SwiftUI

struct PasswordView: View {
    
    @EnvironmentObject var signUpData: SignUpData
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @State private var showPassword = false // ✅ state for toggling
    
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
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Create Account")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Step 3 of 4")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer().frame(width: 20)
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer().frame(height: 110)
                
                // MARK: - Password Field
                VStack(alignment: .leading, spacing: 12) {
                    Text("Set a password")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .medium))
                    
                    ZStack(alignment: .trailing) {
                        Group {
                            if showPassword {
                                TextField("Your password", text: $signUpData.password)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                            } else {
                                SecureField("Your password", text: $signUpData.password)
                            }
                        }
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .focused($focusedField, equals: .firstName)
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                                .padding(.trailing, 12)
                        }
                    }
                    
                    HStack(spacing: 5) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                        
                        Text("Password looks good")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                    }
                }
                
                Spacer()
                
                // MARK: - Footer
                VStack {
                    NavigationLink(destination: EmailView()) {
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
        PasswordView()
            .environmentObject(SignUpData())
            .preferredColorScheme(.dark)
    }
}
