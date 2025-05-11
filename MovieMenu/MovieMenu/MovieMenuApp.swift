import SwiftUI
import Firebase

@main
struct MovieMenuApp: App {
    @StateObject private var auth = AuthViewModel()

    init() {
        FirebaseApp.configure()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
