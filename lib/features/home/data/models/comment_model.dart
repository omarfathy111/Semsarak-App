import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userName;
  final String userType;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.userName,
    required this.userType,
    required this.text,
    required this.createdAt,
  });

  // مسؤولية تحويل الكومنت من جيسون
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userName: json['userName'] ?? 'مستخدم مجهول',
      userType: json['userType'] ?? 'client',
      text: json['text'] ?? '',
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  // مسؤولية تحويل الكومنت إلى جيسون
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userType': userType,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}