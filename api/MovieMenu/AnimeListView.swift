//
//  AnimeListView.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/14/25.
//

import SwiftUI

struct AnimeListView: View {
    @StateObject private var viewModel = AnimeViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.animeList) { anime in
                NavigationLink(destination: AnimeDetailView(anime: anime)) {
                    HStack(alignment: .top) {
                        if let imageURL = anime.images?.jpg.image_url,
                           let url = URL(string: imageURL) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 80, height: 110)
                            .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(anime.title)
                                .font(.headline)
                            
                            Text(anime.synopsis ?? "No description available")
                                .font(.subheadline)
                                .lineLimit(3)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .navigationTitle("Top Anime")
            }
            .onAppear {
                viewModel.loadAnime()
            }
        }
    }
}
