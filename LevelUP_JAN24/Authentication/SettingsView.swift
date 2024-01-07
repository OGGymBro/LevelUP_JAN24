//
//  SettingsView.swift
//  LevelUP_JAN24
//
//  Created by Joaquim Menezes on 07/01/24.
//

import SwiftUI

@MainActor
final class SettingsViewModal: ObservableObject {
        
    //load users email in SettingsViewModeal to reset pwd
    
    
    
    func signOut() throws {
         try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "hello123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
        // gotta implemenent a changeEmail modal screen for this
    }
    
    func updatePassword() async throws {
        let password = "password"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModal()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List{
            Button("Log Out"){
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
            
            emailSection
           
            
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}


extension SettingsView {
    private var emailSection :some View {
        Section{
            Button("Reset Password"){
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET!!")
                    } catch {
                        print(error)
                    }
                    
                }
                //
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
            
            Button("dev :Update Password (password)"){
                //may sometimes require a RECENT SIGNIN so implement UI for that
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("PASSWORD Updated!!")
                    } catch {
                        print(error)
                    }
                    
                }
                //
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
            
            Button("dev :Update email (email@gmail.com)"){
                
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Email Updated!!")
                    } catch {
                        print(error)
                    }
                    
                }
                //
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        } header: {
            Text("Email Functions")
        }
    }
}
