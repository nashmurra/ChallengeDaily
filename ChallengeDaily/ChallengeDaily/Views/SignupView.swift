import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @AppStorage("uid") var userID: String = ""

    @StateObject private var currentChallengeViewmodel = ChallengeViewModel()

    @Binding var currentViewShowing: String

    // Controls the transition
    @State private var showInfoView = false

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }

    var body: some View {
        ZStack {
            if showInfoView {
                InfoView(email: $email, password: $password, currentViewShowing: $currentViewShowing)
                    .transition(.move(edge: .leading)) // Slides in from the left
            } else {
                signupContent
                    .transition(.move(edge: .trailing)) // Slides out to the right
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showInfoView)
    }

    var signupContent: some View {
        ZStack {
            Color(red: 20/255, green: 28/255, blue: 30/255).edgesIgnoringSafeArea(.all)

            VStack {
                VStack {
                    Spacer().frame(height: 150)

                    Text("Sign Up")
                        .font(.system(size: 50, weight: .heavy, design: .default))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 90)
                        .foregroundColor(Color.whiteText)

                    Spacer().frame(height: 10)

                    Text("Create Account")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 90)
                        .foregroundColor(.white.opacity((0.7)))

                    emailField
                    passwordField

                    Button {
                        showInfoView = true
                    } label: {
                        Text("Create Account")
                            .foregroundColor(Color.whiteText)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.backgroundDark)
                            }
                            .padding(.horizontal)
                    }
                    .padding(.leading, 140)
                    .padding(.trailing, 50)

                    Button(action: {
                        withAnimation {
                            self.currentViewShowing = "login"
                        }
                    }) {
                        Text("Already have an account?")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.leading, 90)
                    .padding(.top, 60)

                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 90, style: .continuous)
                        .fill(Color.backgroundLight)
                )
                .padding(.leading, -90)
                .padding(.top, -50)
                .ignoresSafeArea()

                Spacer().frame(height: 70)

                Image(systemName: "plus.app.fill")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.bold)
                    .foregroundColor(Color.pinkColor)
                    .frame(width: 100, height: 100)

                Spacer().frame(height: 50)
            }
        }
        .onAppear {
            currentChallengeViewmodel.fetchDailyChallenges()
            print("Fetched the challenges")
        }
    }

    var emailField: some View {
        VStack {
            Spacer().frame(height: 10)
            
            Text("EMAIL")
                .font(.caption)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 150)
                .foregroundColor(.white.opacity((0.7)))

            HStack {
                TextField("Email", text: $email)
                    .foregroundColor(Color.whiteText)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)

                Spacer()

                if email.count != 0 {
                    Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(email.isValidEmail() ? .green : .red)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 2)
                    .fill(.white.opacity(0.7))
            }
            .padding()
            .padding(.top, -15)
            .padding(.leading, 130)
            .padding(.trailing, 40)
        }
    }

    var passwordField: some View {
        VStack {
            Spacer().frame(height: 10)

            Text("PASSWORD")
                .font(.caption)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 150)
                .foregroundColor(.white.opacity((0.7)))

            HStack {
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)

                Spacer()

                if password.count != 0 {
                    Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(isValidPassword(password) ? .green : .red)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 2)
                    .fill(.white.opacity(0.7))
            }
            .padding()
            .padding(.top, -15)
            .padding(.leading, 130)
            .padding(.trailing, 40)
        }
    }
}
