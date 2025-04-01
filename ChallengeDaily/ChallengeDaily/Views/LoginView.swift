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
                Image("appBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    Spacer().frame(height: 120)
                    
                    Image(systemName: "target")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.white)
                    
                    Spacer().frame(height: 10)
                    
                    HStack(spacing: 0) {
                        Text("sign")
                            .font(.largeTitle)
                            .fontWeight(.light)
                            .foregroundColor(Color.white)
                        
                        Text("in")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }

                    Spacer().frame(height: 50)

                    VStack(spacing: 0) {
                        Spacer().frame(height: 10)
                        
                        VStack {
                            Text("Email")
                                .font(.footnote)
                                .fontWeight(.light)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.gray)
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
                            .padding(.horizontal)
                           // .padding(.top, -10)
                            .padding(.bottom, 1)
                            
                            // More visible divider
                            Divider()
                                .background(Color.white) // Make it more visible
                                .frame(height: 1) // Adjust thickness
                                .padding(.horizontal)
                        }
                        .background(Color.clear)
                        .padding()
                        .padding(.horizontal)

                        VStack {
                            Text("Password")
                                .font(.footnote)
                                .fontWeight(.light)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.gray)
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
                            .padding(.horizontal)
                            //.padding(.top, -10)
                            .padding(.bottom, 1)
                            
                            Divider()
                                .background(Color.white) // Make it more visible
                                .frame(height: 1) // Adjust thickness
                                .padding(.horizontal)
                        }
                        .background(Color.clear)
                        .padding()
                        .padding(.horizontal)

                        Button(action: {
                            // Forgot Password Action
                        }) {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .fontWeight(.light)
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, -10)
                        
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
                                .foregroundColor(Color.black).opacity(0.6)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(17)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.tealColor, Color.greenColor]),
                                                   startPoint: .leading, endPoint: .trailing)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.horizontal, 100)
                        }
                    }
                    
                    Spacer().frame(height: 100)
                    
                    Text("Don't have an account?")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        
                    }) {
                        Text("Create an Account.")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    

                    Spacer()
                }
            }
        }
    }
}
