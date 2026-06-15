import 'package:semsarak/features/auth/data/models/user_model.dart';
import 'package:semsarak/features/auth/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthRepositoryImpl implements AuthRepository {
 
  // استدعاء Instances من الفايربيز
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// 1. دالة تسجيل الدخول
  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,

  })async {
    
    final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password); //الـ credential ده هو اللي جواه الـ uId السحري

    // خطوة ب: جلب بيانات المستخدم الإضافية من الـ Firestore باستخدام الـ uId
    final doc = await _firestore.collection('users').doc(credential.user!.uid).get();

// خطوة ج: تحويل الـ Map اللي رجعت لـ UserModel Object عن طريق المترجم (fromJson)
    return UserModel.fromJson(doc.data()!);

  }
// 2. دالة إنشاء حساب جديد
  @override
  Future<UserModel> registerWithEmailAndPassword({
     required String name,
        required String email,
        required String phone,
        required String password,
         required String userType,
        
  }) async {

    // خطوة أ: إنشاء الحساب بالإيميل والباسورد في Firebase Auth
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);


     // خطوة ب: تجهيز الـ Object النظيف ببيانات المستخدم والـ uId الجديد
      final newUser = UserModel(uId: credential.user!.uid, name: name, email: email, phone: phone, userType: userType);

      // خطوة ج: تحويل الـ Object لـ Map بـ (toJson) وحفظه في الـ Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set(newUser.toJson());

      return newUser; // رجّع الـ UserModel الجديد بعد ما اتسجّل

    }

  @override
Future<void> sendPasswordResetEmail(String email) async {
  try {
    // السطر السحري من جوجل لإرسال إيميل إعادة التعيين
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } catch (e) {
    throw Exception(e.toString());
  }
}

// 3. دالة تسجيل الخروج
    @override
    Future<void> logout() async {
      await _firebaseAuth.signOut();
    }



}

  
