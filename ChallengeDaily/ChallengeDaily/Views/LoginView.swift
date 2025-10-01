import FirebaseAuth
import SwiftUI

struct LoginView: View {

    @AppStorage("uid") var userID: String = ""

    @State private var email: String = ""
    @State private var password: String = ""
    //@Binding var isPresented: Bool

    // Added callback to switch to SignupView
    //var onSwitchToSignup: () -> Void
    
    /*
     .alert(isPresented: $showAlert) {
         Alert(
             title: Text("Notice"), message: Text(alertMessage),
             dismissButton: .default(Text("OK")))
     }
     */
    
    
    // PASSWORD RESET
    /*
     guard !email.isEmpty else {
         alertMessage =
             "Please enter your email address first."
         showAlert = true
         return
     }

     Auth.auth().sendPasswordReset(withEmail: email) {
         error in
         if let error = error {
             alertMessage = error.localizedDescription
         } else {
             alertMessage =
                 "Password reset email sent! Check your inbox."
         }
         showAlert = true
     }
     */
    
    // SIGN IN
    /*
     
     */

    // Alert for password reset
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private var canSignIn: Bool {
        return !email.isEmpty && email.contains("@") && isValidPassword(password)
    }


    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(
            format: "SELF MATCHES %@",
            "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }


    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case password
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
                    
                }
                .padding(.top, 10)
                
                Spacer().frame(height: 20)
                
                // MARK: - First Name
                VStack {
                    
                    
                    Text("Log In")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .semibold))
                    
                    Spacer().frame(height: 35)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("USERNAME, EMAIL, OR PHONE")
                            .foregroundColor(.gray)
                            .font(.system(size: 14, weight: .medium))
                        
                        TextField("", text: $email)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .password
                            }
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray).opacity(0.7)
                    }
                    .padding(.horizontal)

                }
                
                // MARK: - Last Name
                VStack(alignment: .leading, spacing: 1) {
                    Text("PASSWORD")
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .medium))
                    
                    TextField("", text: $password)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = nil
                        }
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray).opacity(0.7)
                }
                .padding(.horizontal)
                
                HStack{
                    Image(systemName: "checkmark.square")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Save Login Info on your iCloud devices")
                        .foregroundColor(.white)
                        .font(.system(size: 13, weight: .regular))
                }
                .padding(.horizontal)
                
                HStack{
                    
                    Spacer()
                    
                    Text("Forgot your password?")
                        .foregroundColor(Color(red: 87/255, green: 200/255, blue: 255/255))
                        .font(.system(size: 13, weight: .medium))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(10)
                
                // MARK: - Footer
                VStack {
                    
                    // 👇 NavigationLink to Username screen
                    Button(action:
                            {
                            Auth.auth().signIn(
                        withEmail: email, password: password
                            ) { authResult, error in
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
                                        //isPresented = false
                                    }
                                    dismiss()
                                }
                            }
                    },label: {
                            Text("Log In")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor((email.isEmpty || password.isEmpty) ?
                                    .white :
                                    Color(red: 23/255, green: 25/255, blue: 26/255))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background((email.isEmpty || password.isEmpty) ?
                                            Color(red: 50/255, green: 50/255, blue: 50/255) :
                                            Color(red: 87/255, green: 200/255, blue: 255/255))
                                .frame(height: 45)
                                .cornerRadius(5)
                                .padding(.horizontal, 40)
                        }
                    )
                    .padding(.bottom, 15)
                    .disabled(email.isEmpty || password.isEmpty)
                    //.padding(.horizontal)
                }
                .padding(.top, 50)
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                focusedField = .email
            }
        }
    }
}

