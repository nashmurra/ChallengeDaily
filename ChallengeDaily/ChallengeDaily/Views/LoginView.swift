import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @AppStorage("uid") var userID: String = ""
    
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isPresented: Bool
    
    // Added callback to switch to SignupView
    var onSwitchToSignup: () -> Void
    
    // Alert for password reset
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                        Text("Log")
                            .font(.largeTitle)
                            .fontWeight(.light)
                            .foregroundColor(Color.white)
                        
                        Text("In")
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
                                .foregroundColor(Color.white)
                                .padding(.top)
                                .padding(.leading)
                            
                            HStack {
                                TextField("Email", text: $email)
                                    .foregroundColor(Color.white)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                
                                Spacer()
                                
                                if !email.isEmpty {
                                    Image(systemName: "checkmark")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 1)
                            
                            Divider()
                                .background(Color.white)
                                .frame(height: 1)
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
                                .foregroundColor(Color.white)
                                .padding(.top)
                                .padding(.leading)
                            
                            HStack {
                                SecureField("Password", text: $password)
                                    .foregroundColor(Color.white)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                
                                Spacer()
                                
                                if !password.isEmpty {
                                    Image(systemName: "checkmark")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 1)
                            
                            Divider()
                                .background(Color.white)
                                .frame(height: 1)
                                .padding(.horizontal)
                        }
                        .background(Color.clear)
                        .padding()
                        .padding(.horizontal)
                        
                        Button(action: {
                            guard !email.isEmpty else {
                                alertMessage = "Please enter your email address first."
                                showAlert = true
                                return
                            }
                            
                            Auth.auth().sendPasswordReset(withEmail: email) { error in
                                if let error = error {
                                    alertMessage = error.localizedDescription
                                } else {
                                    alertMessage = "Password reset email sent! Check your inbox."
                                }
                                showAlert = true
                            }
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
                                    alertMessage = error.localizedDescription
                                    showAlert = true
                                    return
                                }
                                
                                if let authResult = authResult {
                                    print(authResult.user.uid)
                                    withAnimation {
                                        userID = authResult.user.uid
                                        isPresented = false
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
                        isPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onSwitchToSignup()
                        }
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
