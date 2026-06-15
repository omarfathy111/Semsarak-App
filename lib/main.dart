import 'package:semsarak/features/auth/data/models/user_model.dart';
import 'package:semsarak/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:semsarak/features/home/presentation/screens/mianpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  // تفعيل محركات فلوتر الداخلية قبل بدايه التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  // ملحوظة: لو هتربط بالفايربيز حقيقي مستقبلاً، سطر الـ Firebase.initializeApp() بيتحط هنا
  // التعديل هنا: لازم تديله الـ Options عشان يعرف هو رايح لانهي سيرفر بالظبط
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCGflL9sjfYGlsIjwSnAr8V8nskxvQcQH0",
      appId: "1:785469973916:android:81e635b6b6db2972059459",
      messagingSenderId: "785469973916",
      projectId: "aqaarak-d09f1",
    ),
  );
  runApp(const JiwarApp());
}

class JiwarApp extends StatelessWidget {
  const JiwarApp({super.key});

  @override
  Widget build(BuildContext context) {
    // هنا بنحقن خط الإمداد بالـ BLoC فوق التطبيق كله
    return BlocProvider(
      // بنكريت الـ AuthBloc وبنديله الـ Implementation الفعلي بتاع الـ Repo
      create: (context) => AuthBloc(authRepository: AuthRepositoryImpl()),
      child: MaterialApp(
        title: 'جوار العقاري',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF0F2027),
          fontFamily: 'Cairo', // تثبيت الخط العربي الشيك للتطبيق كله
        ),
        home: FirebaseAuth.instance.currentUser != null
            ? MainPage(
                user: UserModel(
                  uId: FirebaseAuth.instance.currentUser!.uid,

                  name:
                      FirebaseAuth.instance.currentUser!.displayName ??
                      "مستخدم جوار",
                  email: FirebaseAuth.instance.currentUser!.email ?? "",
                  phone: FirebaseAuth.instance.currentUser!.phoneNumber ?? "",
                  userType: "client", // قيمة افتراضية عشان الديزاين يفتح
                ),
              )
            : const RoleSelectionScreen(),
      ),
    );
  }
}
