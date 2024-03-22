//
//  SignInEmailView.swift
//  LevelUP_JAN24
//
//  Created by Joaquim Menezes on 07/01/24.
//
import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var showErrorAlert = false // New state property for showing error alert
    
    var isFormValid: Bool {
        return isValidEmail(email) && isValidPassword(password)
    }

    func signUp() async {
        guard isValidEmail(email), isValidPassword(password) else {
            errorMessage = "Invalid email or password"
            showErrorAlert = true // Set showErrorAlert to true to trigger alert
            return
        }

        do {
            try await AuthenticationManager.shared.createUser(email: email, password: password)
        } catch {
            print(error)
            errorMessage = "Failed to sign up"
            showErrorAlert = true
        }
    }

    func signIn() async {
        guard isValidEmail(email), isValidPassword(password) else {
            errorMessage = "Invalid email or password"
            showErrorAlert = true
            return
        }

        do {
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
        } catch {
            print(error)
            errorMessage = "Failed to sign in"
            showErrorAlert = true
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        // Basic email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        // Password length validation
        return password.count >= 8
    }
}

struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        VStack {
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

            Button {
                Task {
                    await viewModel.signUp()
                    await viewModel.signIn()
                }
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: 350)
                    .background(viewModel.isFormValid ? Color.blue : Color.gray.opacity(0.5)) // Grey out when disabled
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(viewModel.isFormValid == false)
            
        }
        .padding()
        .navigationTitle("Sign In With Email")
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
        Spacer()
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}

