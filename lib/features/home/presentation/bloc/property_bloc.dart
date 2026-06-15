import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/property_repository.dart';
import 'property_event.dart';
import 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyRepository propertyRepository;
  StreamSubscription?
  _propertiesSubscription; // مراقب لخط المياه المفتوح (Stream)

  PropertyBloc({required this.propertyRepository}) : super(PropertyInitial()) {
    // 1. لما الشاشة تطلب تحميل البيانات
    on<LoadPropertiesRequested>((event, emit) {
      emit(PropertyLoading());
      // بنقفل أي مراقبة قديمة عشان مانستهلكش باقة
      _propertiesSubscription?.cancel();

      // بنفتح الحنفية ونراقب السيرفر لايف
      _propertiesSubscription = propertyRepository.getProperties().listen(
        (propertiesList) {
          // أول ما الفايربيز يرمي داتا جديدة، البلوك بيبعت إشارة لنفسه بالتحديث
          add(PropertiesUpdated(propertiesList));
        },
        onError: (error) {
          add(PropertiesUpdated([])); // لو حصل إيرور يصفر الشاشة
        },
      );
    });

    // 2. لما الداتا تجيلنا لايف من الـ Stream
    on<PropertiesUpdated>((event, emit) {
      emit(PropertyFetchSuccess(event.properties));
    });
    on<AddPropertyRequested>((event, emit) async {
      emit(PropertyLoading());
      try {
        await propertyRepository.addProperty(event.property);
        emit(PropertyAddSuccess());
        // 🔥 حقنة إشارة لإعادة تنشيط الـ Stream وجلب البيانات فوراً بعد النشر الناجح
        add(LoadPropertiesRequested());
      } catch (e) {
        emit(PropertyFailure(e.toString()));
      }
    });
    on<AddCommentRequested>((event, emit) async {
    try {
      // بنادي على الـ repository عشان يرفع الكومنت فوراً للفايربيز
      await propertyRepository.addComment(event.propertyId, event.comment);
      // ملحوظة: مش محتاجين نطلع State جديدة لأن الـ Stream (خط المياه) 
      // المفتوح في الهوم بيلقط التحديث من الفايربيز لايف ويحدث الشاشة تلقائياً
    } catch (e) {
      emit(PropertyFailure(e.toString()));
    }
  });
  }

  // ميزة أمنية: بنقفل خط المراقبة تماماً لو اليوزر قفل الصفحة عشان الموبايل ميهنجش
  @override
  Future<void> close() {
    _propertiesSubscription?.cancel();
    return super.close();
  }
}
