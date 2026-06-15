// الكلاس الأساسي اللي بتورث منه كل الحالات
import 'package:semsarak/features/auth/data/models/user_model.dart';

abstract class AuthState{}

// 1. حالة البداية: الشاشة لسه بتفتح ومستنية العميل
class AuthInitial extends AuthState{}

// 2. حالة التحميل: الـ BLoC أخد الداتا ورايح للـ Repo والـ UI مستني ومطلع دائرة تحميل
class AuthLoading extends AuthState{}

// 3. حالة النجاح: الـ BLoC رجع من الـ Repo ومعاه الـ user النظيف
class AuthSuccess extends AuthState{

    final UserModel user;

    AuthSuccess({required this.user}); // بنباصي الـ user عشان الـ UI يعرف الـ userType ويوجه العميل صح
   

} 

// 4. حالة الفشل: الـ BLoC رجع من الـ Repo بس حصلت مشكلة (باسورد غلط مثلاً)
class AuthFailure extends AuthState{
  final String errorMessage;

  AuthFailure({required this.errorMessage}); // بنباصي الرسالة عشان الـ UI يعرضها في SnackBar
}

// حالة خاصة بنجاح إرسال إيميل استعادة الباسورد
class PasswordResetEmailSent extends AuthState {}