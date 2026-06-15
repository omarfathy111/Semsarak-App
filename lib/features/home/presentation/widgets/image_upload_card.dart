import 'dart:io';
import 'package:flutter/material.dart';

class ImageUploadCard extends StatelessWidget {
  final String? selectedImagePath;
  final VoidCallback onTap;

  const ImageUploadCard({
    super.key,
    required this.selectedImagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          image: selectedImagePath != null 
              ? DecorationImage(image: FileImage(File(selectedImagePath!)), fit: BoxFit.cover)
              : null,
        ),
        child: selectedImagePath == null 
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_rounded, color: Color(0xFF2196F3), size: 40),
                  SizedBox(height: 10),
                  Text(
                    "اضغط هنا لاختيار صورة العقار 📸", 
                    style: TextStyle(color: Colors.white60, fontFamily: 'Cairo', fontSize: 13),
                  ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}