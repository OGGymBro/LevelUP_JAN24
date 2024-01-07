//
//  RootView.swift
//  LevelUP_JAN24
//
//  Created by Joaquim Menezes on 07/01/24.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false

    var body: some View {
        ZStack {
            if !showSignInView{
                NavigationStack {
                   SettingsView(showSignInView: $showSignInView)
                }
            }
           
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView, content: {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        })
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
