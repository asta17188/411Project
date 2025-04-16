//
//  FirestoreService.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/15/25.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    private let db = Firestore.firestore()

    func addMovieToWatched(_ movie: Movie, notes: String, rating: Int, completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "No user logged in", code: 401, userInfo: nil))
            return
        }

        let movieData: [String: Any] = [
            "title": movie.title,
            "overview": movie.overview,
            "poster_path": movie.poster_path,
            "notes": notes,
            "rating": rating,
            "timestamp": Timestamp(date: Date())
        ]

        db.collection("users")
          .document(userID)
          .collection("watched_movies")
          .addDocument(data: movieData, completion: completion)
    }

    func addAnimeToWatched(_ anime: Anime, notes: String, rating: Int, completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "No user logged in", code: 401, userInfo: nil))
            return
        }

        let animeData: [String: Any] = [
            "title": anime.title,
            "synopsis": anime.synopsis ?? "",
            "poster_url": anime.images?.jpg.image_url ?? "",
            "rating": rating,
            "notes": notes,
            "timestamp": Timestamp(date: Date())
        ]

        db.collection("users")
          .document(userID)
          .collection("watched_anime")
          .addDocument(data: animeData, completion: completion)
    }
    
    func fetchWatchedMovies(completion: @escaping ([WatchedItem]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        db.collection("users")
          .document(userID)
          .collection("watched_movies")
          .order(by: "timestamp", descending: true)
          .getDocuments { snapshot, error in
              if let documents = snapshot?.documents {
                  let items = documents.compactMap { doc -> WatchedItem? in
                      let data = doc.data()
                      guard let title = data["title"] as? String,
                            let overview = data["overview"] as? String,
                            let poster = data["poster_path"] as? String,
                            let notes = data["notes"] as? String,
                            let rating = data["rating"] as? Int else {
                          return nil
                      }

                      return WatchedItem(title: title, description: overview, posterURL: "https://image.tmdb.org/t/p/w200\(poster)", notes: notes, rating: rating)
                  }
                  completion(items)
              } else {
                  completion([])
              }
          }
    }

    func fetchWatchedAnime(completion: @escaping ([WatchedItem]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        db.collection("users")
          .document(userID)
          .collection("watched_anime")
          .order(by: "timestamp", descending: true)
          .getDocuments { snapshot, error in
              if let documents = snapshot?.documents {
                  let items = documents.compactMap { doc -> WatchedItem? in
                      let data = doc.data()
                      guard let title = data["title"] as? String,
                            let synopsis = data["synopsis"] as? String,
                            let poster = data["poster_url"] as? String,
                            let notes = data["notes"] as? String,
                            let rating = data["rating"] as? Int else {
                          return nil
                      }

                      return WatchedItem(title: title, description: synopsis, posterURL: poster, notes: notes, rating: rating)
                  }
                  completion(items)
              } else {
                  completion([])
              }
          }
    }


}
