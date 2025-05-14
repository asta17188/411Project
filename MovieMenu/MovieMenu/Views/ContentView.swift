//
//  ContentView.swift
//  MovieMenu
//
//  Created by csuftitan on 5/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var auth = AuthViewModel()

    var body: some View {
        TabView {
            MovieListView()
                .tabItem { Label("Movies", systemImage: "film") }

            AnimeListView()
                .tabItem { Label("Anime", systemImage: "tv") }

            if auth.user != nil {
                UserProfileView()
                    .tabItem { Label("Profile", systemImage: "person") }
            } else {
                AuthView()
                    .tabItem { Label("Login", systemImage: "person") }
            }
        }
        .environmentObject(auth)
    }
}

#Preview {
    ContentView()
}
