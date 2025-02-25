import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject var userViewModel = UserViewModel()
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            headerView
            actionButtons
            userInfoDetails
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ProfileView {
    
    var headerView: some View {
        ZStack(alignment: .bottomLeading) {
            Color(.purple)
                .ignoresSafeArea()
            
            VStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .offset(x: 24, y: 12)
                }
                Circle()
                    .frame(width: 100, height: 100)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(y: 24)
                
            }
        }
        .frame(height: 96)
    }
    
    var actionButtons: some View {
        HStack {
            Spacer()
            
            Button {
                
            } label: {
                Text("Edit Profile")
                    .font(.subheadline.bold())
                    .frame(width: 120, height: 32)
                    .foregroundColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.75))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .offset(x: 0, y: 15)
            }
            
            Image(systemName: "bell.badge")
                .font(.title)
                .overlay(Circle().stroke(Color.gray, lineWidth: 0.75).padding(-3))
                .frame(maxWidth: .infinity, alignment: .topTrailing)
                .offset(x: -12, y: 15)
        }
    }
    
    var userInfoDetails: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Text("YoMama")
                    .font(.title.bold())
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Color(.systemBlue))
            }
            .offset(x: 10)
            
            Text("@JoeMama")
                .font(.subheadline)
                .foregroundColor(.white)
                .offset(x: -3)
            
            Text("He/Her flag")
                .font(.subheadline)
            
            HStack(spacing: 24) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    
                    Text("Moms house, OH")
                }
                
                HStack {
                    Image(systemName: "link")
                    
                    Text("www.yomamma.com")
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            HStack(spacing: 24) {
                HStack(spacing: 4) {
                    Text("307")
                        .font(.subheadline)
                        .bold()
                    
                    Text("Following")
                        .font(.caption)
                }
                
                HStack(spacing: 4) {
                    Text("6.9M")
                        .font(.subheadline)
                        .bold()
                    
                    Text("Followers")
                        .font(.caption)
                }
            }
            .padding(.vertical)
            
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal)
        
    }
}


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
