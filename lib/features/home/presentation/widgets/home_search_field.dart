import 'package:flutter/material.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        decoration: InputDecoration(
          hintText: "ابحث عن شقة، فيلا، طلبات إيجار...",
          hintStyle: TextStyle(color: Colors.white38, fontFamily: 'Cairo', fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF2196F3)),
          suffixIcon: Icon(Icons.tune_rounded, color: Colors.white54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}