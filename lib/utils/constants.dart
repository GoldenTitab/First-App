import 'package:flutter/material.dart';

class AppStrings {
  AppStrings._();

  // App Info
  static const String appTitle = 'Aurora';

  // Onboarding & Splash
  static const String welcomeMessage = 'به Aurora خوش آمدید';
  static const String welcomeSubtitle =
      'موسیقی را با شفافیت و زیبایی تجربه کنید';
  static const String getStarted = 'شروع کنید';
  static const String next = 'بعدی';
  static const String splashMessage = 'به شفافیت آب، به درخشندگی شفق';

  // Auth
  static const String loginTitle = 'ورود به حساب';
  static const String registerTitle = 'ثبت‌نام';
  static const String verifyEmailTitle = 'تأیید ایمیل';
  static const String emailHint = 'ایمیل خود را وارد کنید';
  static const String passwordHint = 'رمز خود را وارد کنید';
  static const String login = 'ورود';
  static const String register = 'ثبت‌نام';
  static const String logout = 'خروج';
  static const String resendEmail = 'ارسال مجدد ایمیل تأیید';
  static const String forgotPassword = 'رمز خود را فراموش کرده‌اید؟';
  static const String dontHaveAnAccount = 'حساب ندارید؟ همین حالا بسازید';
  static const String repeatPasswordHint = 'تکرار رمز عبور';
  static const String repeatedPasswordDifferentError =
      'رمز عبور با تکرار آن مطابقت ندارد.';

  // Email Verification
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
  static const String retry = 'تلاش مجدد';
  static const String okay = 'باشه';

  // Errors
  static const String error = 'خطا';
  static const String genericError = 'خطایی رخ داده است.';
  static const String unknownError = 'خطای ناشناخته: ';
  static const String playbackError = 'خطا در پخش: ';
  static const String fetchSongsErrorWithCode =
      'دریافت لیست آهنگ‌ها ناموفق بود (کد:';
  static const String fetchSongsError = 'خطا در دریافت آهنگ‌ها:';
  static const String fetchSongsListError = 'خطا در دریافت لیست آهنگ‌ها';
  static const String musicNotFound = 'هیچ آهنگی یافت نشد.';

  // Auth Errors
  static const String userNotFound = 'کاربری با این ایمیل یافت نشد.';
  static const String wrongPassword = 'رمز عبور اشتباه است.';
  static const String invalidEmail = 'ایمیل معتبر وارد کنید.';
  static const String weakPassword =
      'رمز عبور باید حداقل ۶ کاراکتر داشته باشد.';
  static const String emailAlreadyExists = 'این ایمیل قبلاً ثبت شده است.';
  static const String authenticationError = 'خطای احراز هویت: ';
  static const String logoutError = 'خطا در خروج: ';
  static const String networkError = 'اتصال اینترنت خود را بررسی کنید.';
  static const String timeoutError = 'زمان ارتباط به پایان رسید.';
  static const String tooManyRequests =
      'تلاش بیش از حد. لطفاً چند دقیقه صبر کنید.';
  static const String requiredField = 'این فیلد الزامی است.';
  static const String invalidFormat = 'قالب داده نامعتبر است.';

  // Navigation
  static const String home = 'خانه';
  static const String library = 'کتابخانه';
  static const String favorites = 'علاقه‌مندی‌ها';
  static const String profile = 'پروفایل';
  static const String menu = 'منو';
  static const String playlist = 'لیست پخش';
  static const String settings = 'تنظیمات';
  static const String about = 'درباره ما';
  static const String nowPlaying = 'در حال پخش';
  static const String noSongPlaying = 'آهنگی در حال پخش نیست';

  // Status
  static const String approved = 'تأیید شده';
  static const String notApproved = 'تأیید نشده';

  // Social Login
  static const String loginWaysText = 'با استفاده از روش‌های دیگر وارد شوید';
  static const String goToRegister = 'حساب ندارید؟ ثبت‌نام کنید';
}

class AppDurations {
  AppDurations._();

  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration emailVerificationCheck = Duration(seconds: 3);
  static const Duration snackBarDuration = Duration(seconds: 3);
}

class AppStyles {
  AppStyles._();

  static TextStyle baseStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    return null;
  }
}
