//
//  HomeView.swift
//  MovieMenu
//
//  Created by csuftitan on 5/8/25.
//


import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Movies", systemImage: "magnifyingglass")
                }

            AnimeListView()
                .tabItem {
                    Label("Anime", systemImage: "tv")
                }

            UserProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
