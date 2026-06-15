import 'package:semsarak/features/auth/presentation/bloc/auth_event.dart';
import 'package:semsarak/features/auth/presentation/bloc/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  @override
  void initState() {
    super.initState();
    // 🔥 حقنة إنعاش للذاكرة: أول ما اليوزر يدخل شاشة البروفايل، البلوك بيجري يجيب بياناته لايف من الفايرستور
   // context.read<AuthBloc>().add(LogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "الملف الشخصي",
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // 🏆 1. لو نجح في جلب البيانات من السيرفر (اعرض البروفايل فورا)
          if (state is AuthSuccess) {
            final user = state.user;
            bool isVendor = user.userType == 'vendor';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  
                  // 👤 الأفاتار الزجاجي المودرن
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: isVendor ? Colors.blue.withOpacity(0.2) : Colors.amber.withOpacity(0.2),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
                          ),
                        ),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: isVendor ? Colors.blue : Colors.amber,
                          child: Icon(
                            isVendor ? Icons.verified_user_rounded : Icons.person_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // اسم المستخدم ونوع الحساب
                  Text(
                    user.name,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: isVendor ? Colors.blue.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isVendor ? Colors.blue.withOpacity(0.2) : Colors.amber.withOpacity(0.2)),
                    ),
                    child: Text(
                      isVendor ? "حساب شركة / وسيط عقاري" : "حساب عميل باحث عن عقار",
                      style: TextStyle(color: isVendor ? Colors.blue : Colors.amber, fontSize: 12, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  // بطاقات البيانات الزجاجية
                  _buildProfileTile(icon: Icons.email_outlined, title: "البريد الإلكتروني", value: user.email),
                  _buildProfileTile(icon: Icons.fingerprint_rounded, title: "معرّف الحساب (UID)", value: user.uId.length > 12 ? "${user.uId.substring(0, 12)}..." : user.uId),
                  _buildProfileTile(icon: isVendor ? Icons.business_center_outlined : Icons.person_search_outlined, title: "طبيعة النشاط", value: isVendor ? "تسويق وعروض بيع" : "طلبات شراء وإيجار"),

                  const SizedBox(height: 50),

                  // زرار تسجيل الخروج
                  InkWell(
                    onTap: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                          SizedBox(width: 10),
                          Text("تسجيل الخروج من الحساب", style: TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
          }

          // ⚠️ 2. لو حصل فشل أو إيرور في جلب البيانات
          if (state is AuthFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "فشل تحميل البيانات: ${state.errorMessage}",
                  style: const TextStyle(color: Colors.redAccent, fontFamily: 'Cairo'),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // ⏳ 3. الحالة الافتراضية المؤقتة أثناء الفحص (Loading دائرية فخمة)
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF2196F3)),
                SizedBox(height: 15),
                Text("جاري استعادت بيانات حسابك...", style: TextStyle(color: Colors.white54, fontFamily: 'Cairo', fontSize: 13)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileTile({required IconData icon, required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundColor: Colors.white.withOpacity(0.05), child: Icon(icon, color: Colors.white70, size: 20)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'Cairo')),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Cairo', fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}