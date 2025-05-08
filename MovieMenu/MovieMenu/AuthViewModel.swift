//
//  AuthViewModel.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/15/25.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User?

    init() {
        self.user = Auth.auth().currentUser
    }

    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.user = result?.user
                completion(error)
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.user = result?.user
                completion(error)
            }
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        user = nil
    }
}
