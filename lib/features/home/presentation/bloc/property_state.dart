import '../../data/models/property_model.dart';

abstract class PropertyState {}

class PropertyInitial extends PropertyState {}
class PropertyLoading extends PropertyState {} // ديرة بتلف وهي بتمهد للـ GET أو الـ POST

// حالة النجاح في جلب البوستات (ومعاها لستة العقارات لايف!)
class PropertyFetchSuccess extends PropertyState {
  final List<PropertyModel> properties;
  PropertyFetchSuccess(this.properties);
}

// حالة النجاح في رفع بوست جديد
class PropertyAddSuccess extends PropertyState {}

class PropertyFailure extends PropertyState {
  final String errorMessage;
  PropertyFailure(this.errorMessage);
}