import SwiftUI

struct AnimeListView: View {
    @StateObject private var viewModel = AnimeViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ZStack {
                AppBackground()

                VStack {
                    // Search bar
                    TextField("Search Anime...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding([.horizontal, .top])
                        .onChange(of: searchText) {
                            if searchText.isEmpty {
                                viewModel.loadAnime()
                            } else {
                                viewModel.search(query: searchText)
                            }
                        }

                    // Anime list
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.animeList) { anime in
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
                                                .foregroundColor(.white)

                                            Text(anime.synopsis ?? "No description available")
                                                .font(.subheadline)
                                                .lineLimit(3)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                }

                                Divider()
                                    .background(Color.white.opacity(0.2))
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                .navigationTitle("Top Anime")
                .foregroundColor(.white)
            }
        }
        .onAppear {
            viewModel.loadAnime()
        }
    }
}
