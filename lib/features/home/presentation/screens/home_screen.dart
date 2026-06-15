import 'package:semsarak/features/auth/presentation/bloc/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/property_bloc.dart';
import '../bloc/property_event.dart';
import '../bloc/property_state.dart';
import 'add_post_screen.dart';
import 'property_detail_screen.dart';

// 🔥 السحر هنا: استدعاء الـ Widgets المفصولة الجاهزة بره
import '../widgets/home_header.dart';
import '../widgets/home_search_field.dart';
import '../widgets/property_post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // تشغيل خط الـ Stream المفتوح لجلب البيانات لايف فوراً
    context.read<PropertyBloc>().add(LoadPropertiesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 140),
          children: [
            const SizedBox(height: 15),
            
            // 👋 1. الهيدر الترحيبي (مفصول بره)
            const HomeHeader(),
            const SizedBox(height: 25),

            // 🔍 2. شريط البحث الفخم (مفصول بره)
            const HomeSearchField(),
            const SizedBox(height: 30),

            // 🖼️ 3. جزء الإعلانات الحصرية الثابتة
            const Text(
              "أبرز العروض الحصرية", 
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 15),
            _buildBannersList(), // تركتها هنا لأنها بنرات ثابتة مؤقتة وقصيرة جداً
            const SizedBox(height: 30),

            // 🏢 4. جزء البوستات والطلبات لايف من السيرفر
            const Text(
              "أحدث العقارات والطلبات", 
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 10),
            
            BlocBuilder<PropertyBloc, PropertyState>(
              builder: (context, state) {
                if (state is PropertyLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(color: Color(0xFF2196F3)),
                    ),
                  );
                }
                
                if (state is PropertyFetchSuccess) {
                  if (state.properties.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Text(
                          "لا توجد عقارات أو طلبات مضافة حالياً.\nأنشئ أول بوست في التطبيق! 👇", 
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54, fontFamily: 'Cairo', fontSize: 14, height: 1.5),
                        ),
                      ),
                    );
                  }
                  
                  // 🚀 رسم البوستات باستدعاء كارت الـ PropertyPostCard المفصّل بره
                  return Column(
                    children: state.properties.map((property) {
                      return InkWell(
                        onTap: () {
                          // عند الضغط يطير لشاشة التفاصيل ويباصي الموديل بالكومنتات
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (childContext) => BlocProvider.value(
                                value: context.read<PropertyBloc>(),
                                child: PropertyDetailScreen(property: property),
                              ),
                            ),
                          );
                        },
                        child: PropertyPostCard(
                          title: property.title,
                          location: property.location,
                          price: property.price,
                          imageUrl: property.imageUrl ?? '',
                          postType: property.postType,
                        ),
                      );
                    }).toList(),
                  );
                }
                
                if (state is PropertyFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "حدث خطأ أثناء جلب البيانات: ${state.errorMessage}", 
                        style: const TextStyle(color: Colors.redAccent, fontFamily: 'Cairo'),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),

      // ➕ زرار إضافة بوست الذكي
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton.extended(
          onPressed: () {
            final authState = context.read<AuthBloc>().state;
            String currentUserType = 'client';

            if (authState is AuthSuccess) {
              currentUserType = authState.user.userType;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (childContext) => BlocProvider.value(
                  value: context.read<PropertyBloc>(), 
                  child: AddPostScreen(userType: currentUserType),
                ),
              ),
            );
          },
          backgroundColor: const Color(0xFF2196F3),
          icon: const Icon(Icons.add_home_work_rounded, color: Colors.white),
          label: const Text(
            "أضف عقارك/طلبك", 
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // ميثود فرعية البنرات الثابتة المؤقتة
  Widget _buildBannersList() {
    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildBannerCard('خصم 10% على كومباوند زايد', 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00'),
          _buildBannerCard('فيلات بمقدم 5% فقط في التجمع', 'https://images.unsplash.com/photo-1613490493576-7fde63acd811'),
        ],
      ),
    );
  }

  Widget _buildBannerCard(String title, String imageUrl) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomRight,
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
      ),
    );
  }
}