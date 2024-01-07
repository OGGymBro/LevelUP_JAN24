//
//  AuthenticationView.swift
//  LevelUP_JAN24
//
//  Created by Joaquim Menezes on 07/01/24.
//

import SwiftUI

struct AuthenticationView: View {
    
    @State private var isSignInEmailViewActive = false
    
    var body: some View {
        VStack{
            
            NavigationLink{
                SignInEmailView()
               
            } 
        label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height :55)
                    .frame(maxWidth: 350)
                    .background(Color.blue)
                    .cornerRadius(10)
//                    .onTapGesture {
//                        //UIImpactFeedbackGenerator(style: .soft).impactOccurred()
//                    }
                    
            }
            Spacer()
            
        }
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack{
        AuthenticationView()
    }
}
