import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject var userViewModel = UserViewModel()
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                headerView
                userInfoDetails
                //actionButtons
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Navigate back
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                            Text("")
                                .foregroundColor(.white)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                withAnimation {
                                    userID = ""
                                }
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                        }) {
                            Text("Sign Out")
                                .foregroundColor(.white)
                        }
                        
                        Button(role: .destructive, action: {
                            // Add account deletion logic here
                        }) {
                            HStack {
                                Text("Delete Account")
                                Image(systemName: "trash")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }

            }
        }
    }
}



extension ProfileView {
    var headerView: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image("thanos")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    )
                
                Button(action: {
                    // edit profile
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .offset(x: 30, y: 30)
            }
            .padding(.top, 0)
        }
    }
    
    var userInfoDetails: some View {
        VStack(spacing: 0) {
            Text("SigmaThanos")
                .font(.title.bold())
                .foregroundColor(.white)
            
            Text("@tanos")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Goofy Goober")
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.top, 6)
            
            HStack {
                Text("Followers")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.top, 6)
                
                Text("1.2M")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.top, 6)
                
                Spacer().frame(width: 40)
                
                Text("Following")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.top, 6)
                
                Text("10K")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.top, 6)
            }
        }
    }
}

#Preview {
    ProfileView()
}


//    var actionButtons: some View {
//        HStack() {
//            Button(action: {
//
//            }) {
//                Text("Edit Profile")
//                    .font(.subheadline.bold())
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 5)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(Color.gray, lineWidth: 1)
//                    )
//            }
//        }
//        .padding(.top, 5)
//    }
//}



//    @StateObject var userViewModel = UserViewModel()
//    @AppStorage("uid") var userID: String = ""
//    @Environment(\.presentationMode) var presentationMode // Allows navigation back
//
//    var body: some View {
//        ZStack {
//            Color.black.edgesIgnoringSafeArea(.all)
//
//            VStack {
//                Spacer().frame(height: 20) // Pushes the image down slightly
//
//                Image(systemName: "person.crop.circle.fill")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//
//                Text("\(userViewModel.username)")
//                    .foregroundColor(.white)
//                    .fontWeight(.bold)
//                    .font(.title2)
//                    .onAppear {
//                        userViewModel.fetchCurrentUser()
//                    }
//
//                Text("\(userViewModel.email)")
//                    .foregroundColor(.white)
//                    .fontWeight(.semibold)
//                    .font(.title3)
//
//                Spacer()
//
//                Text("Logged In!")
//                    .foregroundColor(.white)
//                    .font(.title2)
//
//                HStack {
//                    Button(action: {
//                        let firebaseAuth = Auth.auth()
//                        do {
//                            try firebaseAuth.signOut()
//                            withAnimation {
//                                userID = ""
//                            }
//                        } catch let signOutError as NSError {
//                            print("Error signing out: %@", signOutError)
//                        }
//                    }) {
//                        Text("Sign Out")
//                            .foregroundColor(.white)
//                    }
//                }
//                .foregroundColor(.black)
//                .padding()
//                .overlay {
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(lineWidth: 2)
//                        .foregroundColor(.white)
//                }
//
//                Spacer() // Keeps content balanced
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss() // Navigate back
//                }) {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.white)
//                        Text("")
//                            .foregroundColor(.white)
//                    }
//                }
//            }
//        }
//    }
