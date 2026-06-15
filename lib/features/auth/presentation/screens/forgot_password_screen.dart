import 'dart:ui';
import 'package:semsarak/features/auth/presentation/bloc/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semsarak/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:semsarak/features/auth/presentation/bloc/auth_event.dart';
import 'package:semsarak/core/widgets/custom_glass_text_field.dart';
import 'package:semsarak/features/auth/presentation/widgets/custom_glass_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية العقارية الموحدة للتطبيق
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
          Container(color: Colors.black.withOpacity(0.5)),

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
                      child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          // الشاشة دلوقتي بتراقب الحالة المخصصة ليها بالظبط
                          if (state is PasswordResetEmailSent) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'تم إرسال رابط إعادة التعيين! 📧',
                                ),
                              ),
                            );
                            Navigator.pop(
                              context,
                            ); // يرجعه لصفحة اللوجين بعد النجاح
                          }
                          if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  state.errorMessage,
                                  style: const TextStyle(fontFamily: 'Cairo'),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.lock_reset_rounded,
                                  size: 65,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "استعادة كلمة المرور",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور الخاصة بك.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                const SizedBox(height: 30),

                                /// حقل الإيميل النظيف
                                CustomGlassTextField(
                                  hint: "البريد الإلكتروني المسجل",
                                  icon: Icons.email_outlined,
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'برجاء إدخال البريد الإلكتروني';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 25),

                                /// الزرار الذكي المشترك
                                CustomGlassButton(
                                  text: "إرسال الرابط",
                                  isLoading: state is AuthLoading,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                        ForgotPasswordSubmitted(
                                          email: emailController.text.trim(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),

                                // زرار العودة
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "إلغاء والعودة",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontFamily: 'Cairo',
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
