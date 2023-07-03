import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final String senderEmail;
  final String senderId;
  final String recieverId;
  final Timestamp timestamp;

  MessageModel({
    required this.message,
    required this.senderEmail,
    required this.senderId,
    required this.recieverId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        "message": message,
        "senderEmail": senderEmail,
        "senderId": senderId,
        "recieverId": recieverId,
        "timestamp": timestamp,
      };

  static MessageModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MessageModel(
      message: snapshot['message'] ?? "",
      senderEmail: snapshot['senderEmail'] ?? "",
      senderId: snapshot['senderId'] ?? "",
      recieverId: snapshot['recieverId'] ?? "",
      timestamp: snapshot['timestamp'] ?? "",
    );
  }
}
