import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        ZStack(alignment: .topLeading) {
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)") {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 170, height: 260)
                .clipped()
                .cornerRadius(12)
            }

            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding([.horizontal, .bottom], 8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(6)
            }
            .frame(width: 170, height: 260, alignment: .bottomLeading)
        }
    }
}
