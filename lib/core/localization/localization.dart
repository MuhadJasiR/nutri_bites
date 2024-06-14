import 'package:get/get_navigation/src/root/internacionalization.dart';

class Localization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "ar_AE": {
          "English": "عربي",
          "First name": "الاسم الأول",
          "Last name": "اسم العائلة",
          "Sign Up": "اشتراك",
          "Welcome to NutriPro": "مرحبا بكم في النظام الغذائي القيام به",
          "Continue": "يكمل",
          "Or Login with": "أو تسجيل الدخول باستخدام"
        },
        "en_US": {
          "English": "English",
          "First name": "First name",
          "Last name": "Last name",
          "Sign Up": "Sign Up",
          "Welcome to NutriPro": "Welcome to Diet NutriPro",
          "Continue": "Continue",
          "Or Login with": "Or Login with"
        }
      };
}
