import 'package:semsarak/features/auth/domain/repositories/auth_repository.dart';
import 'package:semsarak/features/auth/presentation/bloc/auth_event.dart';
import 'package:semsarak/features/auth/presentation/bloc/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // 1. بنعرف العقد عشان الـ Bloc يعرف يكلمه
  final AuthRepository _authRepository;

  // 2. الـ Constructor وبنديله حالة البداية الفاضية AuthInitial
  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {


        // لقطة طلب تسجيل الدخول
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());

      try {
        final user = await _authRepository.loginWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthFailure(errorMessage: e.toString())); // بث حالة فشل
      }
    });
  // لقطة طلب إنشاء الحساب
    on<RegisterSubmitted>((event, emit) async {
      emit(AuthLoading());

      try {
        final user = await _authRepository.registerWithEmailAndPassword(
          name: event.name,
          email: event.email,
          phone: event.phone,
          password: event.password,
          userType: event.userType,
        );
        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthFailure(errorMessage: e.toString())); // بث حالة فشل
      }
    });

    // لقطة طلب تسجيل الخروج
    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        await _authRepository.logout();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(errorMessage: e.toString())); // بث حالة فشل
      }
    });
on<ForgotPasswordSubmitted>((event, emit) async {
  emit(AuthLoading()); 
  try {
    await authRepository.sendPasswordResetEmail(event.email);
    
    // المرة دي هنطلع الحالة الجديدة النظيفة دي ومن غير ما تطلب يوزر!
    emit(PasswordResetEmailSent()); 
    
  } catch (e) {
    emit(AuthFailure(errorMessage: e.toString()));
  }
});
  

  }

  

  
}
