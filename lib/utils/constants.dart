import 'package:flutter/material.dart';

class AppStrings {
  AppStrings._();

  // App
  static const String appTitle = 'Aurora';
  static const String welcome = 'به Aurora خوش آمدید';
  static const String splashMessage = 'به شفافیت آب، به درخشندگی شفق';

  // Authentication Titles
  static const String loginTitle = 'ورود به حساب';
  static const String registerTitle = 'ثبت‌نام';
  static const String verifyEmailTitle = 'تأیید ایمیل';

  // Authentication Fields
  static const String emailHint = 'ایمیل خود را وارد کنید';
  static const String passwordHint = 'رمز خود را وارد کنید';

  // Authentication Actions
  static const String login = 'ورود';
  static const String register = 'ثبت‌نام';
  static const String logout = 'خروج';
  static const String resendEmail = 'ارسال مجدد ایمیل تأیید';
  static const String goToRegister = 'حساب ندارید؟ ثبت‌نام کنید';

  // Authentication Messages
  static const String verifyEmailMessage =
      'یک ایمیل تأیید به آدرس شما ارسال شده است.\nلطفاً صندوق ورودی خود را بررسی کنید.';

  static const String emailVerificationSent =
      'ایمیل تأیید ارسال شد.\nلطفاً صندوق ورودی خود را چک کنید.';

  static const String emailNotReceived = 'ایمیل دریافت نکرده‌اید؟';

  // Dialogs
  static const String logoutDialogTitle = 'خروج از حساب';

  static const String logoutDialogContent =
      'آیا مطمئن هستید که می‌خواهید خارج شوید؟';

  static const String cancel = 'لغو';

  // General Errors
  static const String error = 'خطا';
  static const String genericError = 'خطایی رخ داده است.';
  static const String unknownError = 'خطای ناشناخته: ';
  static const String retry = 'تلاش مجدد';
  static const String okay = 'باشه';

  // Firebase/Auth Errors
  static const String userNotFound = 'کاربری با این ایمیل یافت نشد.';

  static const String wrongPassword = 'رمز عبور اشتباه است.';

  static const String invalidEmail = 'ایمیل معتبر وارد کنید.';

  static const String weakPassword =
      'رمز عبور باید حداقل ۶ کاراکتر داشته باشد.';

  static const String emailAlreadyExists = 'این ایمیل قبلاً ثبت شده است.';

  static const String authenticationError = 'خطای احراز هویت: ';

  static const String logoutError = 'خطا در خروج: ';

  // Network Errors
  static const String networkError = 'اتصال اینترنت خود را بررسی کنید.';

  static const String timeoutError = 'زمان ارتباط به پایان رسید.';

  static const String tooManyRequests =
      'تلاش بیش از حد. لطفاً چند دقیقه صبر کنید.';

  // Validation
  static const String requiredField = 'این فیلد الزامی است.';

  static const String invalidFormat = 'قالب داده نامعتبر است.';

  // Bottom Navigation
  static const String home = 'خانه';
  static const String library = 'کتابخانه';
  static const String favorites = 'علاقه‌مندی‌ها';
  static const String profile = 'پروفایل';

  // Drawer
  static const String menu = 'منو';
  static const String playlist = 'لیست پخش';
  static const String settings = 'تنظیمات';
  static const String about = 'درباره ما';

  // Music Player
  static const String nowPlaying = 'در حال پخش';
  static const String noSongPlaying = 'آهنگی در حال پخش نیست';
  static const String songsLoadError = 'خطا در دریافت لیست آهنگ‌ها';
}

class AppDurations {
  AppDurations._();

  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration emailVerificationCheck = Duration(seconds: 3);
  static const Duration snackBarDuration = Duration(seconds: 3);
}

class AppStyles {
  AppStyles._();

  static const TextStyle baseStyle = TextStyle(
    color: Color(0xFF607D8B),
    fontSize: 16,
    fontFamily: 'Vazir',
  );
}

class AppValidators {
  AppValidators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value.length < 6) {
      return AppStrings.weakPassword;
    }
    return null;
  }
}
