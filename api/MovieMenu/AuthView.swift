//
//  AuthView.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/15/25.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            Button(isLogin ? "Login" : "Sign Up") {
                if isLogin {
                    auth.signIn(email: email, password: password) { error in
                        errorMessage = error?.localizedDescription
                    }
                } else {
                    auth.signUp(email: email, password: password) { error in
                        errorMessage = error?.localizedDescription
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button(isLogin ? "Don't have an account? Sign up" : "Already have an account? Log in") {
                isLogin.toggle()
            }

            if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    AuthView()
}
