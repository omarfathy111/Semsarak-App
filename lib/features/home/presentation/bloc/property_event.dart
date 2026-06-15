import 'package:semsarak/features/home/data/models/comment_model.dart';

import '../models/../../data/models/property_model.dart';

abstract class PropertyEvent {}

// 1. إشارة لطلب تحميل البوستات واشتراك في الـ Stream (GET)
class LoadPropertiesRequested extends PropertyEvent {}

// 2. إشارة تحديث داخلي لما السيرفر يبعت داتا جديدة لحظياً
class PropertiesUpdated extends PropertyEvent {
  final List<PropertyModel> properties;
  PropertiesUpdated(this.properties);
}

// 3. إشارة لرفع بوست جديد (POST)
class AddPropertyRequested extends PropertyEvent {
  final PropertyModel property;
  AddPropertyRequested(this.property);
} 

class AddCommentRequested extends PropertyEvent {
  final String propertyId;
  final CommentModel comment;

  AddCommentRequested({required this.propertyId, required this.comment});
}