import 'package:semsarak/features/auth/presentation/bloc/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/models/property_model.dart';
import '../../data/models/comment_model.dart';
import '../bloc/property_bloc.dart';
import '../bloc/property_event.dart';
import '../widgets/comment_card.dart'; // استيراد كارت الكومنت النظيف

class PropertyDetailScreen extends StatefulWidget {
  final PropertyModel property;
  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. لقط بيانات اليوزر الحالي من الـ AuthBloc
    final authState = context.read<AuthBloc>().state;
    String currentUserType = 'client';
    String currentUserName = 'مستخدم جوار';
    if (authState is AuthSuccess) {
      currentUserType = authState.user.userType;
      currentUserName = authState.user.name;
    }

    bool isOffer = widget.property.postType == 'offer';
    bool isAllowedToComment = isOffer || (!isOffer && currentUserType == 'vendor');

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white), onPressed: () => Navigator.pop(context))),
      body: Column(
        children: [
          // 📜 تفاصيل العقار والكومنتات (سكرول)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // صورة العقار (تظهر لو عرض فقط)
                if (isOffer && widget.property.imageUrl != null && widget.property.imageUrl!.isNotEmpty)
                  ClipRRect(borderRadius: BorderRadius.circular(25), child: Image.network(widget.property.imageUrl!, height: 230, width: double.infinity, fit: BoxFit.cover)),
                const SizedBox(height: 20),
                
                // السعر والنوع
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.property.price, style: TextStyle(color: isOffer ? const Color(0xFF2196F3) : Colors.amber, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    Text(isOffer ? "عرض بيع" : "مطلوب عقار", style: TextStyle(color: isOffer ? Colors.blue : Colors.amber, fontSize: 14, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 15),
                Text(widget.property.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                const SizedBox(height: 10),
                Row(children: [const Icon(Icons.location_on_outlined, color: Colors.white38, size: 18), const SizedBox(width: 5), Text(widget.property.location, style: const TextStyle(color: Colors.white38, fontSize: 14, fontFamily: 'Cairo'))]),
                const Divider(color: Colors.white10, height: 40),
                
                // رأس التعليقات
                Text("التعليقات والردود (${widget.property.comments.length})", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                const SizedBox(height: 15),
                
                // لير رسم التعليقات النظيفة
                if (widget.property.comments.isEmpty)
                  const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text("لا توجد تعليقات حتى الآن..", style: TextStyle(color: Colors.white30, fontFamily: 'Cairo'))))
                else
                  ...widget.property.comments.map((comment) => CommentCard(comment: comment)).toList(), // 👈 الكارت النظيف بره!
              ],
            ),
          ),

          // 📥 صندوق التعليقات السفلي الذكي
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: MediaQuery.of(context).padding.bottom + 15),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), border: const Border(top: BorderSide(color: Colors.white10))),
            child: isAllowedToComment 
                ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
                          child: TextField(
                            controller: _commentController,
                            style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(hintText: isOffer ? "اكتب استفسارك..." : "اكتب عرضك للعميل (سيخصم 1 نقطة)", hintStyle: const TextStyle(color: Colors.white24, fontSize: 13, fontFamily: 'Cairo'), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor: const Color(0xFF2196F3),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                          onPressed: () {
                            if (_commentController.text.trim().isEmpty) return;
                            context.read<PropertyBloc>().add(AddCommentRequested(propertyId: widget.property.id, comment: CommentModel(userName: currentUserName, userType: currentUserType, text: _commentController.text.trim(), createdAt: DateTime.now())));
                            _commentController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ],
                  )
                : Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(15)), child: const Text("🔒 التعليق على طلبات العملاء متاح فقط لشركات التسويق والوسطاء.", style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Cairo', fontSize: 13), textAlign: TextAlign.center)),
          ),
        ],
      ),
    );
  }
}