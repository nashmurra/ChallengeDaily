import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @AppStorage("uid") var userID: String = ""
    
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isPresented: Bool  // <-- Add binding to control dismissal
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("BackgroundScreen")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    Spacer().frame(height: 20)

                    Text("Sign In")
                        .font(.system(size: 50, weight: .heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.whiteText)
                        .padding(.top, 50)
                        .padding()
                        .padding(.horizontal)

                    Spacer().frame(height: 50)

                    VStack {
                        VStack {
                            Text("Email")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.primaryAccent)
                                .padding(.top)
                                .padding(.leading)

                            HStack {
                                TextField("Email", text: $email)
                                    .foregroundColor(Color.white)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)

                                Spacer()

                                if email.count != 0 {
                                    Image(systemName: "checkmark")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.dark))
                            .padding(.horizontal)
                        }

                        VStack {
                            Text("Password")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.primaryAccent)
                                .padding(.top)
                                .padding(.leading)

                            HStack {
                                SecureField("Password", text: $password)
                                    .foregroundColor(Color.white)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)

                                Spacer()

                                if password.count != 0 {
                                    Image(systemName: "checkmark")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.dark))
                            .padding(.horizontal)
                        }

                        Button(action: {
                            // Forgot Password Action
                        }) {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .foregroundColor(Color.primaryAccent)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 30)

                        Spacer().frame(height: 40)

                        Button {
                            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    return
                                }

                                if let authResult = authResult {
                                    print(authResult.user.uid)
                                    withAnimation {
                                        userID = authResult.user.uid
                                        isPresented = false  // <-- Dismiss the sheet on successful login
                                    }
                                }
                            }
                        } label: {
                            Text("Sign In")
                                .foregroundColor(Color.white)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(17)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.secondaryAccent))
                                .padding(.horizontal, 25)
                        }
                    }
                }
            }
        }
    }
}
