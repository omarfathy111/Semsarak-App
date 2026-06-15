import 'package:semsarak/core/widgets/custom_glass_text_field.dart';
import 'package:semsarak/features/auth/presentation/bloc/user_model.dart';
import 'package:semsarak/features/auth/presentation/widgets/auth_background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// البلوك والإيفنتات
import 'package:semsarak/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:semsarak/features/auth/presentation/bloc/auth_event.dart';

// الشاشات والـ Widgets المشتركة
import 'package:semsarak/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:semsarak/features/auth/presentation/screens/signup_screen.dart';
import 'package:semsarak/features/home/presentation/screens/mianpage.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
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
                  'تم تسجيل الدخول بنجاح! 👋',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: Color(0xFF1A5AD7),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(user: state.user),
              ),
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
                  Icons.lock_person_rounded,
                  size: 65,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const Text(
                  "مرحباً بك مجدداً في عالمك العقاري",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 35),

                /// 👤 البريد الإلكتروني
                CustomGlassTextField(
                  hint: "البريد الإلكتروني",
                  icon: Icons.person_outline_rounded,
                  controller: usernameController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value == null || value.isEmpty)
                      ? "برجاء كتابة البريد"
                      : null,
                ),
                const SizedBox(height: 20),

                /// 🔒 كلمة المرور
                CustomGlassTextField(
                  hint: "كلمة المرور",
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                  controller: passwordController,
                  validator: (value) =>
                      (value == null || value.isEmpty || value.length < 6)
                      ? "كلمة المرور قصيرة"
                      : null,
                ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "هل نسيت كلمة المرور؟",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// 🚀 الزرار الذكي
                state is AuthLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                LoginSubmitted(
                                  email: usernameController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A5AD7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            "دخول",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ليس لديك حساب؟ ",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(userType: 'user'),
                          ),
                        );
                      },
                      child: const Text(
                        "أنشئ حسابك الآن",
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
