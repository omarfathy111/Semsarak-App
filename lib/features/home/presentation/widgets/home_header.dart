import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مرحباً بك في جوار 👋", 
              style: TextStyle(color: Colors.white60, fontSize: 14, fontFamily: 'Cairo'),
            ),
            Text(
              "استكشف السوق العقاري", 
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
          ],
        ),
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
        )
      ],
    );
  }
}