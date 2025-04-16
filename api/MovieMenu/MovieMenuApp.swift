//
//  MovieMenuApp.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/14/25.
//

import SwiftUI
import Firebase

@main
struct MovieMenuApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
