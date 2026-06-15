import 'package:flutter/material.dart';
import '../../data/models/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    bool isVendor = comment.userType == 'vendor';
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isVendor ? Colors.blue.withOpacity(0.2) : Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(comment.userName, style: TextStyle(color: isVendor ? Colors.blue : Colors.white70, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              if (isVendor) const Icon(Icons.verified_rounded, color: Colors.blue, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment.text, style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Cairo', height: 1.4)),
        ],
      ),
    );
  }
}