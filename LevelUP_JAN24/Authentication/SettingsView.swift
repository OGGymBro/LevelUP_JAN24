//
//  SettingsView.swift
//  LevelUP_JAN24
//
//  Created by Joaquim Menezes on 07/01/24.
//

import SwiftUI

@MainActor
final class SettingsViewModal: ObservableObject {
        
    
    func signOut() throws {
         try AuthenticationManager.shared.signOut()
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
                //
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
