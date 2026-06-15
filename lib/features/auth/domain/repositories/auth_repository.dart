import 'package:semsarak/features/auth/data/models/user_model.dart';

// هذا هو الريبو الخاص بالـ Auth، اللي بيحتوي على كل الدوال اللي بتتعامل مع الـ Auth، زي تسجيل الدخول، إنشاء حساب جديد، وتسجيل الخروج

abstract class AuthRepository{

  // الشرط الأول: دالة تسجيل الدخول بالإيميل والباسورد، وترجع لنا UserModel
  Future <UserModel> loginWithEmailAndPassword({
    required String email,
    required String password
  });

    // الشرط الثاني: دالة إنشاء حساب جديد، وترجع لنا الـ UserModel بعد ما يتكّريت
    Future <UserModel> registerWithEmailAndPassword({
        required String name,
        required String email,
        required String phone,
        required String password,
         required String userType,
    });

    // الشرط الثالث: دالة تسجيل الخروج
    Future <void> logout();

    Future<void> sendPasswordResetEmail(String email);

}