import 'package:semsarak/features/auth/presentation/widgets/custom_glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/property_model.dart';
import '../bloc/property_bloc.dart';
import '../bloc/property_event.dart';
import '../bloc/property_state.dart';
import 'package:semsarak/core/widgets/custom_glass_text_field.dart';
import '../widgets/image_upload_card.dart'; // كارت الصور الجديد

class AddPostScreen extends StatefulWidget {
  final String userType; 

  const AddPostScreen({super.key, required this.userType});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>(); // لإضافة حماية وتحقق من الحقول
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  final String _dummyImageUrl = 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914';

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isVendor = widget.userType == 'vendor';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isVendor ? "إضافة عقار جديد للبيع" : "نشر طلب شراء/إيجار",
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<PropertyBloc, PropertyState>(
        listener: (context, state) {
          if (state is PropertyAddSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم نشر بوستك بنجاح! 🎉", style: TextStyle(fontFamily: 'Cairo'))),
            );
            Navigator.pop(context); 
          }
          if (state is PropertyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("فشل النشر: ${state.errorMessage}", style: const TextStyle(fontFamily: 'Cairo'))),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // تغليف الفورم بالـ Key المخصص للـ validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📸 كارت رفع الصور الذكي: يظهر للفيندور ويختفي تماماً للعميل
                if (isVendor) ...[
                  ImageUploadCard(
                    selectedImagePath: _selectedImage?.path,
                    onTap: () async {
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() => _selectedImage = image);
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                ],

                Text(isVendor ? "عنوان العقار" : "ماذا تبحث عنه؟ (تفاصيل الطلب)", style: const TextStyle(color: Colors.white, fontFamily: 'Cairo')),
                const SizedBox(height: 10),
                CustomGlassTextField(
                  controller: _titleController,
                  hint: isVendor ? "مثال: فيلا دورين بالتجمع الخامس" : "مثال: مطلوب شقة غرفتين إيجار في زايد حتي 12 ألف ج.م",
                  icon: isVendor ? Icons.home_work_outlined : Icons.search_outlined,
                  maxLines: isVendor ? 1 : 3,
                  validator: (v) => (v == null || v.isEmpty) ? "برجاء ملء هذا الحقل" : null,
                ),
                const SizedBox(height: 20),

                const Text("الموقع / المدينة", style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
                const SizedBox(height: 10),
                CustomGlassTextField(
                  controller: _locationController,
                  hint: "مثال: القاهرة، الشيخ زايد، الياسمين",
                  icon: Icons.location_on_outlined,
                  validator: (v) => (v == null || v.isEmpty) ? "برجاء تحديد الموقع" : null,
                ),
                const SizedBox(height: 20),

                Text(isVendor ? "السعر المطلـوب (ج.م)" : "الميزانية المحددة (ج.م)", style: const TextStyle(color: Colors.white, fontFamily: 'Cairo')),
                const SizedBox(height: 10),
                CustomGlassTextField(
                  controller: _priceController,
                  hint: "مثال: 3,500,000",
                  icon: Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.isEmpty) ? "برجاء تحديد السعر" : null,
                ),
                const SizedBox(height: 40),

                // 🚀 زرار النشر الموحد الذكي المستورد من الـ Core
                BlocBuilder<PropertyBloc, PropertyState>(
                  builder: (context, state) {
                    return CustomGlassButton(
                      text: "انشر الآن لايف 🚀",
                      isLoading: state is PropertyLoading,
                      onPressed: () {
                        // تفعيل الـ validation الحقيقي للتأكد من تعبئة الداتا
                        if (_formKey.currentState!.validate()) {
                          final newPost = PropertyModel(
                            id: '', 
                            title: _titleController.text.trim(),
                            location: _locationController.text.trim(),
                            price: _priceController.text.trim(),
                            imageUrl: isVendor ? (_selectedImage?.path ?? _dummyImageUrl) : null, 
                            userId: FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
                            postType: isVendor ? 'offer' : 'request',
                          );
                          context.read<PropertyBloc>().add(AddPropertyRequested(newPost));
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}