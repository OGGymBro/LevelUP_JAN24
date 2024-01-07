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
    
    func signIn(){
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email or Password found.")
            return
        }
        
        Task{
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Error : \(error)")
            }
        }
    }
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    
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
                viewModel.signIn()
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
        SignInEmailView()
    }
}
