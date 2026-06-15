
// هذا هو موديل المستخدم، اللي بيحتوي على كل البيانات اللي بتخص المستخدم، زي الـ uId، الاسم، البريد الإلكتروني، رقم الهاتف، ونوع المستخدم
class UserModel {
  final String uId;
  final String name;
  final String email;
  final String phone;
  final String userType;

  UserModel({
    required this.uId,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) { // تحويل الـ Map اللي جاي من الفايربيز لـ Object فلوتر بيفهمه
    return UserModel(
      uId: json['uId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['userType'] ?? 'client',
    );
  }

  Map<String, dynamic> toJson(){ // . تحويل الـ Object لـ Map عشان الفايربيز يرضى يخزنه
    return {
     'uId': uId,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
    };
  }
}
