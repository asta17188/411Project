//
//  FirestoreService.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/15/25.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    let db = Firestore.firestore()

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
    
    func fetchWatchedMovies(for userID: String, completion: @escaping ([WatchedItem]) -> Void) {
        db.collection("users")
          .document(userID)
          .collection("watched_movies")
          .order(by: "timestamp", descending: true)
          .getDocuments { snapshot, error in
              let items = snapshot?.documents.compactMap { doc -> WatchedItem? in
                  let data = doc.data()
                  guard let title = data["title"] as? String,
                        let overview = data["overview"] as? String,
                        let poster = data["poster_path"] as? String,
                        let notes = data["notes"] as? String,
                        let rating = data["rating"] as? Int else {
                      return nil
                  }
                  return WatchedItem(id: doc.documentID, title: title, description: overview, posterURL: "https://image.tmdb.org/t/p/w200\(poster)", notes: notes, rating: rating)
              } ?? []
              completion(items)
          }
    }

    func fetchWatchedAnime(for userID: String, completion: @escaping ([WatchedItem]) -> Void) {
        db.collection("users")
          .document(userID)
          .collection("watched_anime")
          .order(by: "timestamp", descending: true)
          .getDocuments { snapshot, error in
              let items = snapshot?.documents.compactMap { doc -> WatchedItem? in
                  let data = doc.data()
                  guard let title = data["title"] as? String,
                        let synopsis = data["synopsis"] as? String,
                        let poster = data["poster_url"] as? String,
                        let notes = data["notes"] as? String,
                        let rating = data["rating"] as? Int else {
                      return nil
                  }
                  return WatchedItem(id: doc.documentID, title: title, description: synopsis, posterURL: poster, notes: notes, rating: rating)
              } ?? []
              completion(items)
          }
    }
    
    func deleteWatchedMovie(id: String, completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "No user logged in", code: 401, userInfo: nil))
            return
        }

        db.collection("users")
          .document(userID)
          .collection("watched_movies")
          .document(id)
          .delete(completion: completion)
    }

    func deleteWatchedAnime(id: String, completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "No user logged in", code: 401, userInfo: nil))
            return
        }

        db.collection("users")
          .document(userID)
          .collection("watched_anime")
          .document(id)
          .delete(completion: completion)
    }
    
    func addFriend(byEmail email: String, completion: @escaping (Error?) -> Void) {
        guard let currentUID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "No user logged in", code: 401, userInfo: nil))
            return
        }

        let usersRef = db.collection("users")
        usersRef.whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, let targetUser = documents.first else {
                completion(NSError(domain: "User not found", code: 404, userInfo: nil))
                return
            }

            let targetUID = targetUser.documentID
            let request = ["from": currentUID, "to": targetUID, "timestamp": Timestamp(date: Date())]

            self.db.collection("friend_requests").addDocument(data: request, completion: completion)
        }
    }

    func fetchFriends(completion: @escaping ([Friend]) -> Void) {
        guard let currentUID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        db.collection("users")
            .document(currentUID)
            .collection("friends")
            .getDocuments { snapshot, error in
                let friends = snapshot?.documents.compactMap { doc -> Friend? in
                    let data = doc.data()
                    guard let email = data["email"] as? String,
                          let uid = data["uid"] as? String else {
                        return nil
                    }
                    return Friend(uid: uid, email: email)
                } ?? []
                completion(friends)
            }
    }
    
    func fetchSentRequests(for userID: String, completion: @escaping ([String]) -> Void) {
        db.collection("friend_requests")
            .whereField("from", isEqualTo: userID)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No sent friend requests found or error: \(error?.localizedDescription ?? "None")")
                    completion([])
                    return
                }

                let toUserIDs = documents.compactMap { $0.data()["to"] as? String }
                completion(toUserIDs)
            }
    }

    func fetchReceivedFriendRequests(for userID: String, completion: @escaping ([FriendRequest]) -> Void) {
        db.collection("friend_requests")
            .whereField("to", isEqualTo: userID) // Get requests where the current user is the receiver
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching received friend requests: \(error)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let requests = documents.compactMap { doc -> FriendRequest? in
                    guard let senderUID = doc["from"] as? String,
                          let timestamp = doc["timestamp"] as? Timestamp else { return nil }
                    return FriendRequest(senderUID: senderUID, receiverUID: userID, timestamp: timestamp)
                }

                completion(requests)
            }
    }
    
    func acceptFriendRequest(from senderUID: String, to receiverUID: String, completion: @escaping (Error?) -> Void) {
        let usersRef = db.collection("users")

        // Get sender's email
        usersRef.document(senderUID).getDocument { senderSnapshot, error in
            guard let senderData = senderSnapshot?.data(),
                  let senderEmail = senderData["email"] as? String else {
                completion(NSError(domain: "Sender not found", code: 404, userInfo: nil))
                return
            }

            // Get receiver's email
            usersRef.document(receiverUID).getDocument { receiverSnapshot, error in
                guard let receiverData = receiverSnapshot?.data(),
                      let receiverEmail = receiverData["email"] as? String else {
                    completion(NSError(domain: "Receiver not found", code: 404, userInfo: nil))
                    return
                }

                let senderFriendData = ["uid": senderUID, "email": senderEmail]
                let receiverFriendData = ["uid": receiverUID, "email": receiverEmail]

                let batch = self.db.batch()

                // Add sender to receiver's friend list
                let receiverFriendRef = usersRef.document(receiverUID).collection("friends").document(senderUID)
                batch.setData(senderFriendData, forDocument: receiverFriendRef)

                // Add receiver to sender's friend list
                let senderFriendRef = usersRef.document(senderUID).collection("friends").document(receiverUID)
                batch.setData(receiverFriendData, forDocument: senderFriendRef)

                self.db.collection("friend_requests")
                    .whereField("from", isEqualTo: senderUID)
                    .whereField("to", isEqualTo: receiverUID)
                    .getDocuments { snapshot, _ in
                        if let doc = snapshot?.documents.first {
                            batch.deleteDocument(doc.reference)
                        }

                        batch.commit(completion: completion)
                    }
            }
        }
    }

}
