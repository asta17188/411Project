import FirebaseFirestore

struct FriendRequest {
    var senderUID: String
    var receiverUID: String
    var timestamp: Timestamp?
}
