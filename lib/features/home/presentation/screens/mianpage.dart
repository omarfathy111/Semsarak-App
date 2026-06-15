import 'dart:ui';
import 'package:semsarak/features/auth/data/models/user_model.dart';
import 'package:semsarak/features/auth/presentation/screens/profile_screen.dart';
import 'package:semsarak/features/home/presentation/screens/home_screen.dart';
import 'package:semsarak/features/home/data/repositories/property_repository_impl.dart';
import 'package:semsarak/features/home/presentation/bloc/property_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  final UserModel user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // قائمة الشاشات النظيفة
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // 🧹 شيلنا الـ BlocProvider من هنا عشان الفايل يبقى كلين تماماً والشاشات مستقلة
    _screens = [
      const HomeScreen(), 
      const Center(child: Text("شاشة البحث المتقدم", style: TextStyle(color: Colors.white, fontFamily: 'Cairo'))),
      const Center(child: Text("العقارات المفضلة", style: TextStyle(color: Colors.white, fontFamily: 'Cairo'))),
      const ProfileScreen(), // 👈 حطينا الشاشة الفخمة هنا مكان التكست القديم!
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 هنا السحر المعماري: حقنا الـ BlocProvider كـ جذر أساسي للـ MainPage بالكامل
    // بكدة الـ HomeScreen والـ DetailScreen والـ AddPost يقرأوا منه طلقة وبدون إيرورز
    return BlocProvider(
      create: (context) => PropertyBloc(propertyRepository: PropertyRepositoryImpl()),
      child: Scaffold(
        extendBody: true, 
        body: _screens[_selectedIndex],
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(20), 
          height: 70,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                backgroundColor: Colors.white.withOpacity(0.08),
                type: BottomNavigationBarType.fixed,
                selectedItemColor: const Color(0xFF2196F3), 
                unselectedItemColor: Colors.white54,
                selectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.horizontal_distribute_outlined), label: "الرئيسية"),
                  BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: "استكشف"),
                  BottomNavigationBarItem(icon: Icon(Icons.favorite_border_rounded), label: "المفضلة"),
                  BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: "حسابي"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}