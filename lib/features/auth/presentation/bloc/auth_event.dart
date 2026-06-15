// الكلاس الأساسي اللي بتورث منه كل الطلبات
abstract class AuthEvent {

}
// 1. طلب تسجيل الدخول (محتاجين إيميل وباسورد)
  class LoginSubmitted extends AuthEvent{

    final String email;
    final String password;

    LoginSubmitted({required this.email,required this.password});

  }

  // 2. طلب إنشاء الحساب (محتاجين كل بيانات البيزنس)
  class RegisterSubmitted extends AuthEvent{

      final String name;
      final String email; 
      final String phone; 
      final String password;
      final String userType;


    RegisterSubmitted({
      required this.name,
      required this.email,
      required this.phone,
      required this.password,
      required this.userType,
    });


  }

  

    // 3. طلب تسجيل الخروج (مش محتاج داتا)
    class LogoutRequested extends AuthEvent{}

    // إشارة طلب إعادة تعيين كلمة المرور
class ForgotPasswordSubmitted extends AuthEvent {
  final String email;

   ForgotPasswordSubmitted({required this.email});

 
}



