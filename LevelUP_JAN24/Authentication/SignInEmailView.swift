//
//  SignInEmailView.swift
//  LevelUP_JAN24
//
//  Created by Joaquim Menezes on 07/01/24.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel : ObservableObject{  //view Model
    
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws{
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email or Password found.")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws{
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email or Password found.")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack{
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .frame(width: 350)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .frame(width: 350)
            
            Button{
                Task{
                    do {
                        try await viewModel.signUp()
                        showSignInView = false  //if sign up success ->home
                        return
                    } catch {
                        print(error)
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false //if sign in success ->home
                        return
                    } catch {
                        print(error)
                    }
                    
                }
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height :55)
                    .frame(maxWidth: 350)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
            
        }
        .padding()
        .navigationTitle("Sign In With Email")
        
    }
}


#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
