import 'package:semsarak/features/home/data/models/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/property_repository.dart';
import '../models/property_model.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. جلب البوستات كلها لايف من السيرفر (Stream)
  @override
  Stream<List<PropertyModel>> getProperties() {
    return _firestore
        .collection('properties').orderBy('createdAt', descending: true)
        .snapshots() // بتعمل خط مياه مفتوح مع السيرفر لتحديث البيانات لحظياً
        .map((snapshot) {
          // بنلف على كل المستندات اللي في السيرفر ونحولها لـ PropertyModel
          return snapshot.docs.map((doc) {
            return PropertyModel.fromJson(doc.data(), doc.id);
          }).toList();
        });
  }

  // 2. إضافة بوست جديد (سواء عرض من فيندور بصورة أو طلب من كلاينت بنص)
  @override
  Future<void> addProperty(PropertyModel property) async {
    try {
      // بنفتح الفولدر اللي اسمه properties وبنرمي فيه الـ Map بتاعة الداتا
      await _firestore.collection('properties').add(property.toJson());
    } catch (e) {
      throw Exception("فشل في نشر البوست: ${e.toString()}");
    }
  }

  @override
  Future<void> addComment(String propertyId, CommentModel comment) async {
    // 🔥 كود الفايربيز السحري لزيادة عنصر داخل مصفوفة في مستند محدد
    await _firestore.collection('properties').doc(propertyId).update({
      'comments': FieldValue.arrayUnion([comment.toJson()])
    });
  }
}