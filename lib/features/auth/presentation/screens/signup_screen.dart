import 'package:semsarak/features/auth/presentation/bloc/user_model.dart';
import 'package:semsarak/features/auth/presentation/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semsarak/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:semsarak/features/auth/presentation/bloc/auth_event.dart';
import 'package:semsarak/core/widgets/custom_glass_text_field.dart';
import 'package:semsarak/features/auth/presentation/widgets/custom_glass_button.dart';
import 'package:semsarak/features/auth/presentation/widgets/auth_background_wrapper.dart';

class SignupScreen extends StatefulWidget {
  final String userType; // 👈 1. زود السطر ده عشان يستقبل النوع
  const SignupScreen({super.key, required this.userType});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundWrapper(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تم إنشاء الحساب بنجاح! 🎉',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: Color(0xFF1A5AD7),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Loginscreen()),
            );
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
                  Icons.person_add_alt_1_rounded,
                  size: 65,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  "إنشاء حساب جديد",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const Text(
                  "انضم إلينا وابدأ رحلتك العقارية",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 25),
                CustomGlassTextField(
                  hint: "الاسم بالكامل",
                  icon: Icons.person_outline,
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'برجاء إدخال الاسم';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomGlassTextField(
                  hint: "البريد الإلكتروني",
                  icon: Icons.email_outlined,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'برجاء إدخال البريد الإلكتروني';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'برجاء إدخال بريد إلكتروني صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomGlassTextField(
                  hint: "رقم الهاتف",
                  icon: Icons.phone_android_outlined,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'برجاء إدخال رقم الهاتف';
                    }
                    if (value.length < 11) {
                      return 'رقم الهاتف غير صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomGlassTextField(
                  hint: "كلمة المرور",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'برجاء إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف أو أكثر';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomGlassTextField(
                  hint: "تأكيد كلمة المرور",
                  icon: Icons.lock_reset_outlined,
                  isPassword: true,
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'برجاء تأكيد كلمة المرور';
                    }
                    if (value != passwordController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                CustomGlassButton(
                  text: "تسجيل حساب جديد",
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        RegisterSubmitted(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),
                          password: passwordController.text.trim(),
                          userType: widget.userType,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "لديك حساب بالفعل؟ ",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Loginscreen()),
                        );
                      },
                      child: const Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
