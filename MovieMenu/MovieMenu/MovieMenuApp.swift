import SwiftUI
import Firebase

@main
struct MovieMenuApp: App {
    @StateObject private var auth = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if auth.user != nil {
                HomeView()
                    .environmentObject(auth)
            } else {
                WelcomeScreen()
                    .environmentObject(auth)
            }
        }
    }
}
