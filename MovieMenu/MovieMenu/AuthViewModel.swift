import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var user: User?

    init() {
        self.user = Auth.auth().currentUser
    }

    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let user = result?.user {
                    self.user = user

                    let db = Firestore.firestore()
                    db.collection("users").document(user.uid).setData([
                        "email": email,
                        "createdAt": Timestamp(date: Date())
                    ]) { firestoreError in
                        completion(firestoreError ?? error)
                    }
                } else {
                    completion(error)
                }
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
