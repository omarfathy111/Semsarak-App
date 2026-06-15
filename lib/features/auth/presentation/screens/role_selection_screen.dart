import 'package:flutter/material.dart';
import 'signup_screen.dart'; // تأكد من استيراد صفحة الـ Signup عندك

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // الخلفية الليلية الفخمة للأبلكيشن
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🏆 الشعار أو الكلمة الترحيبية
              const Text(
                "سمسارك",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF2196F3), fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 10),
              const Text(
                "اختر نوع حسابك للبدء في استكشاف السوق العقاري",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 14, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 50),

              // 👤 كارت الـ Client (الباحث عن عقار)
              _buildRoleCard(
                title: "أنا عميل (Client)",
                description: "ابحث عن شقة للشراء أو الإيجار، وانشر طلباتي العقارية مجاناً.",
                icon: Icons.person_outline_rounded,
                color: const Color(0xFF2196F3),
                onTap: () => _navigateToSignup(context, 'client'),
              ),
              
              const SizedBox(height: 20),

              // 🏢 كارت الـ Vendor (شركة تسويق / وسيط)
              _buildRoleCard(
                title: "أنا شركة / وسيط (Vendor)",
                description: "أعرض عقاراتي للبيع، وأتواصل مع العملاء الباحثين عن فرص استثمارية.",
                icon: Icons.storefront_outlined,
                color: Colors.amber,
                onTap: () => _navigateToSignup(context, 'vendor'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ميثود ذكية لبناء كروت الاختيار بتصميم زجاجي مودرن
  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'Cairo', height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            CircleAvatar(
              radius: 25,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  // دالة النقل والتنقل السلسة
  void _navigateToSignup(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupScreen(userType: role), // 👈 بنباصي الـ role أوتوماتيك للـ Signup!
      ),
    );
  }
}