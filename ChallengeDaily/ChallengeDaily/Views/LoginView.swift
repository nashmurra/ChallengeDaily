import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var currentViewShowing: String
    @AppStorage("uid") var userID: String = ""
    
    @State private var email: String = ""
    @State private var password: String = ""
    //@State private var showSignUp = false // Track whether to show SignUp

    private func isValidPassword(_ password: String) -> Bool {
        //minimum 6 characters long
        //1 uppercase character
        //1 special character
        
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ZStack {
            Color(red: 20/255, green: 28/255, blue: 30/255).edgesIgnoringSafeArea(.all)

            
            GeometryReader { geometry in
                    let icons = ["star.fill", "heart.fill", "bolt.fill", "flame.fill", "cloud.fill", "moon.fill", "sun.max.fill",
                                 "checkmark.circle.fill", "exclamationmark.triangle.fill"]
                    let spacing: CGFloat = 80 // Base spacing between icons
                    let jitter: CGFloat = 10 // How much each icon can shift
                    
                    ForEach(0..<Int(geometry.size.width / spacing) * Int(geometry.size.height / spacing), id: \.self) { index in
                        let row = index / Int(geometry.size.width / spacing)
                        let column = index % Int(geometry.size.width / spacing)
                        
                        let randomXOffset = 50 + CGFloat.random(in: -jitter...jitter)
                        let randomYOffset = CGFloat.random(in: -jitter...jitter)
                        
                        Image(systemName: icons.randomElement()!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white.opacity(0.2)) // Faded effect
                            .position(
                                x: CGFloat(column) * spacing + randomXOffset,
                                y: CGFloat(row) * spacing + randomYOffset
                            )
                    }
                }
            
            VStack {
                Spacer().frame(height: 50)
                
                Image(systemName: "plus.app.fill")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.bold)
                    .foregroundColor(Color.redColor)
                    .frame(width: 100, height: 100)

                Spacer().frame(height: 70)
                
                VStack {
                    Spacer().frame(height: 70)
                    
                    Text("Login")
                        .font(.system(size: 50, weight: .heavy))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 90)
                        .foregroundColor(Color.whiteText)
                    
                    Spacer().frame(height: 10)
                    
                    Text("Sign in to continue.")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 90)
                        .foregroundColor(.white.opacity(0.7))
                    
                    VStack {
                        Spacer().frame(height: 10)
                        
                        Text("EMAIL")
                            .font(.caption)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 150)
                            .foregroundColor(.white.opacity(0.7))
                        
                        HStack {
                            TextField("Email", text: $email)
                                .foregroundColor(Color.whiteText)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)

                            Spacer()
                            
                            if email.count != 0 {
                                Image(systemName: email.isValidEmail() ?  "checkmark" : "xmark")
                                    .fontWeight(.bold)
                                    .foregroundColor(email.isValidEmail() ? .green : .red)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 2)
                                .fill(.white.opacity(0.7))
                        )
                        .padding()
                        .padding(.top, -15)
                        .padding(.leading, 130)
                        .padding(.trailing, 40)
                    }
                    
                    VStack {
                        Spacer().frame(height: 10)
                        
                        Text("PASSWORD")
                            .font(.caption)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 150)
                            .foregroundColor(.white.opacity(0.7))
                        
                        HStack {
                            SecureField("Password", text: $password)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)

                            Spacer()
                            
                            if password.count != 0 {
                                Image(systemName: isValidPassword(password) ?  "checkmark" : "xmark")
                                    .fontWeight(.bold)
                                    .foregroundColor(isValidPassword(password) ? .green : .red)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 2)
                                .fill(.white.opacity(0.7))
                        )
                        .padding()
                        .padding(.top, -15)
                        .padding(.leading, 130)
                        .padding(.trailing, 40)
                    }
                    
                    Button {
                        // Placeholder for login action
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                print(error)
                                return
                            }
                            
                            if let authResult = authResult {
                                print(authResult.user.uid)
                                withAnimation{
                                    userID = authResult.user.uid
                                }
                            }
                            
                            withAnimation {
                                self.currentViewShowing = "home"
                            }
                        }
                    } label: {
                        Text("Sign In")
                            .foregroundColor(Color.whiteText)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.backgroundDark)
                            )
                            .padding(.horizontal)
                    }
                    .padding(.leading, 140)
                    .padding(.trailing, 50)
                    
                    Button(action: {
                        withAnimation {
                            withAnimation {
                                self.currentViewShowing = "signup"
                            }
                        }
                    }) {
                        Text("Don't have an account?")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.leading, 90)
                    .padding(.top, 60)

                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 90)
                        .fill(Color.backgroundLight)
                )
                .padding(.leading, -90)
                .padding(.bottom, -100)
                .ignoresSafeArea()
            }
        }
    }
}

