import SwiftUI

struct NameView: View {
    
    @EnvironmentObject var signUpData: SignUpData
    @State private var navigate = false
    @Environment(\.dismiss) private var dismiss
    @AppStorage("uid") var userID: String = ""
    
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
                        
                        Text("Step 1 of 4")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer().frame(width: 20)
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer().frame(height: 40)
                
                // MARK: - First Name
                VStack(alignment: .leading, spacing: 12) {
                    Text("First Name")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .medium))
                    
                    TextField("First Name", text: $signUpData.firstName)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .focused($focusedField, equals: .firstName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .lastName
                            
                        }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                }
                
                // MARK: - Last Name
                VStack(alignment: .leading, spacing: 12) {
                    Text("Last Name")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .medium))
                    
                    TextField("Last Name", text: $signUpData.lastName)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .focused($focusedField, equals: .lastName)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = nil
                        }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                }
                
                Spacer()
                
                // MARK: - Footer
                VStack {
                    Text("By tapping “Agree and Continue”, you acknowledge that you have read the Privacy Policy and agree to the Terms of Service.")
                        .foregroundColor(.white)
                        .font(.system(size: 13, weight: .medium))
                        .multilineTextAlignment(.leading)
                    
                    Spacer().frame(height: 15)
                    
                    // 👇 NavigationLink to Username screen
                    Button(action: {
                                let first = signUpData.firstName.trimmingCharacters(in: .whitespacesAndNewlines)
                                let last = signUpData.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
                                let randomNumber = Int.random(in: 10...99)
                                signUpData.username = "\(first)_\(last)\(randomNumber)"
                                navigate = true
                            }) {
                                Text("Agree and Continue")
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
                            .disabled(signUpData.firstName.isEmpty || signUpData.lastName.isEmpty)
                            .padding(.bottom, 15)

                            NavigationLink(
                                destination: UsernameOneView(),
                                isActive: $navigate,
                                label: { EmptyView() }
                            )

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
        NameView()
            .environmentObject(SignUpData())
            .preferredColorScheme(.dark)
    }
}
