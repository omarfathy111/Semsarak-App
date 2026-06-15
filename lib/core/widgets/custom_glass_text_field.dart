import 'package:flutter/material.dart';

class CustomGlassTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final int maxLines; // 👈 زودنا دي عشان الطلبات الطويلة

  const CustomGlassTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.validator, // خليناه اختياري لمرونة التصميم
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1, // القيمة الافتراضية سطر واحد
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isPassword,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
      textDirection: TextDirection.rtl, // دعم كامل ومثالي للغة العربية
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30, fontFamily: 'Cairo', fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.all(15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
        ),
      ),
    );
  }
}