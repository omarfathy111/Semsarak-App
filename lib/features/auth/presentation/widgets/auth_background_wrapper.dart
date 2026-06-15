import 'dart:ui';
import 'package:flutter/material.dart';

class AuthBackgroundWrapper extends StatelessWidget {
  final Widget child; // هنا بنستقبل المحتوى اللي هيتحط جوه الزجاج (Login أو Signup)

  const AuthBackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. الخلفية العقارية الفخمة الثابتة
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.4)), // الطبقة الغامقة

          // 2. المحتوى الزجاجي (Glassmorphism)
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: child, // 👈 هنا السحر! بيفرش الفورم اللي باعتينه في النص
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}