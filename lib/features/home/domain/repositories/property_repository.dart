
import 'package:semsarak/features/home/data/models/comment_model.dart';
import 'package:semsarak/features/home/data/models/property_model.dart';

abstract class PropertyRepository {
  // العقد الأول: جلب قائمة العقارات من السيرفر (ترجع Stream عشان الداتا تتحدث لحظياً!)
  Stream<List<PropertyModel>> getProperties();

  // العقد الثاني: إضافة عقار جديد في الفايربيز
  Future<void> addProperty(PropertyModel property);

  Future<void> addComment(String propertyId, CommentModel comment);
}
