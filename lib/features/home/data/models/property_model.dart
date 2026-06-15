import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment_model.dart'; // 👈 السطر السحري: استيراد موديل الكومنت المستقل

class PropertyModel {
  final String id;
  final String title;
  final String location;
  final String price;
  final String? imageUrl;
  final String userId;
  final String postType;
  final DateTime? createdAt;
  final List<CommentModel> comments; // نادينها هنا بنظافة

  PropertyModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    this.imageUrl,
    required this.userId,
    required this.postType,
    this.createdAt,
    this.comments = const [],
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json, String docId) {
    var commentsList = json['comments'] as List<dynamic>? ?? [];
    
    // تحويل جيسون التعليقات باستخدام الموديل المستقل الجديد
    List<CommentModel> parsedComments = commentsList
        .map((c) => CommentModel.fromJson(c as Map<String, dynamic>))
        .toList();

    return PropertyModel(
      id: docId,
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['imageUrl'],
      userId: json['userId'] ?? '',
      postType: json['postType'] ?? 'offer',
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
      comments: parsedComments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': location,
      'price': price,
      'imageUrl': imageUrl,
      'userId': userId,
      'postType': postType,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      // بنلف على الكومنتات ونحولها لجيسون بنظافة
      'comments': comments.map((c) => c.toJson()).toList(), 
    };
  }
}