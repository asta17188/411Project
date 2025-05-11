import SwiftUI

enum SearchNavigation: Hashable {
    case profile
    case movie(Movie)
}

struct SearchView: View {
    @EnvironmentObject var auth: AuthViewModel
    @StateObject private var viewModel = MovieViewModel()
    @State private var path = NavigationPath()
    @State private var searchText: String = ""

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                AppBackground()

                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Button {
                            path.append(SearchNavigation.profile)
                        } label: {
                            Image(systemName: "person")
                                .font(.title)
                        }
                    }
                    .padding()

                    TextField("Search...", text: $searchText)
                        .onChange(of: searchText) {
                            if searchText.isEmpty {
                                print("🔎 Empty search — loading popular")
                                viewModel.loadMovies()
                            } else {
                                print("🔎 Searching for \(searchText)")
                                viewModel.search(query: searchText)
                            }
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    Text(searchText.isEmpty ? "🔥 Popular Movies" : "🔍 Results for \"\(searchText)\"")
                        .font(.headline)
                        .padding(.horizontal)
                        .foregroundColor(.white)

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.movies) { movie in
                                MovieCardView(movie: movie)
                                    .onTapGesture {
                                        path.append(SearchNavigation.movie(movie))
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationDestination(for: SearchNavigation.self) { route in
                switch route {
                case .profile:
                    UserProfileView().environmentObject(auth)
                case .movie(let movie):
                    MovieDetailCardView(movie: movie)
                }
            }
            .onAppear {
                viewModel.loadMovies()
            }
            .onChange(of: auth.user) {
                viewModel.loadMovies()
            }
        }
    }
}
