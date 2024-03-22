//
//  AuthenticationView.swift
//  LevelUP_JAN24
//
//  Created by Joaquim Menezes on 07/01/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift


@MainActor
final class AuthenticationViewModel :ObservableObject{
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
}

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    @State private var isSignInEmailViewActive = false
    
    var body: some View {
        VStack{
            
            Image("LUP")
                .resizable()
                .frame(width: 150, height: 150)
                .cornerRadius(75) // Half of the width/height to make it a circle
                .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 2) // Add a shadow
                .overlay(Circle().stroke(Color.white, lineWidth: 4)) // Add a white border
                .padding(.vertical)
            
            
            NavigationLink{
                SignInEmailView(showSignInView: $showSignInView)
               
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height :55)
                    .frame(maxWidth: 350)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }
            .frame(height :55)
            .frame(width:350)
            .cornerRadius(10)
            
            
            Spacer()
//
        }
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack{
        AuthenticationView(showSignInView: .constant(false))
    }
}
