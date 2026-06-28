// lib/utils/constants.dart
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  // در صورت نیاز مسیرهای دیگر
}

class AppStrings {
  static const String appTitle = 'Aurora';
  static const String loginTitle = 'صفحه ورود';
  static const String registerTitle = 'صفحه ثبت‌نام';
  static const String verifyEmailTitle = 'تأیید ایمیل';
  static const String homeTitle = 'خانه';

  static const String emailHint = 'ایمیل خود را وارد کنید.';
  static const String passwordHint = 'رمز خود را وارد کنید.';
  static const String loginButton = 'ورود';
  static const String registerButton = 'ثبت‌نام';
  static const String goToRegister = 'ثبت‌نام نکرده‌اید؟ ایجاد حساب جدید';
  static const String logoutDialogTitle = 'خروج از حساب';
  static const String logoutDialogContent =
      'آیا مطمئن هستید که می‌خواهید خارج شوید؟';
  static const String cancel = 'لغو';
  static const String logout = 'خروج';
  static const String welcome = 'به صفحه اصلی خوش آمدید';
  static const String verifyEmailMessage = 'لطفاً ایمیل خود را تأیید کنید.';
  static const String emailVerificationSent =
      'ایمیل تأیید ارسال شد. لطفاً صندوق ورودی خود را چک کنید.';

  // پیام‌های خطا
  static const String genericError = 'خطایی رخ داده است.';
  static const String userNotFound = 'کاربری با این ایمیل یافت نشد.';
  static const String wrongPassword = 'رمز عبور اشتباه است.';
  static const String invalidEmail = 'فرمت ایمیل صحیح نیست.';
  static const String weakPassword = 'رمز عبور بسیار ضعیف است.';
  static const String emailInUse = 'این ایمیل قبلاً ثبت شده است.';
  static const String unknownError = 'خطای ناشناخته: ';
  static const String registerError = 'خطا در ثبت‌نام.';
}

class AppDurations {
  static const Duration emailVerificationCheck = Duration(seconds: 3);
}
