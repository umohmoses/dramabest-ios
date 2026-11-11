import 'package:flutter/material.dart';

abstract class AppColor {
  // Default Colors
  static const colorPrimary = Color(0xFFed3a57);
  static const colorSecondary = Color(0xfffa6f58);
  static const colorWhite = Color(0xFFFFFFFF);
  static const colorBlack = Color(0xFF000000);
  static const colorTransparent = Color(0x00000000);
  static const colorLightOrange = Color(0xffFFBA6F);
  static const colorLightYellow = Color(0xffF2CAA0);
  static const colorLightBlack = Color(0xff151515);

  // Needed Colors
  static const colorTextPlaceHolder = Color(0xFFAFB0B6);
  static const colorBorderGrey = Color(0xFFEEEEEE);
  static const colorTextGrey = Color(0xFF9EA6BE);
  static const colorTextLightGrey = Color(0xFF9EA2A7);
  static const colorTextDarkGrey = Color(0xFF8C8C8C);
  static const colorSecondaryTextGrey = Color(0xFF95969D);
  static const colorTextRed = Color(0xFFFF4444);
  static const colorButtonPink = Color(0xFFFF4D67);
  static const colorIconGrey = Color(0xFF5C5C5C);
  static const transparent = Color(0x00000000);
  static const shimmer = Color(0xFF2C2C2C);
  static const brownColor = Color(0xff362421);
  static const lightBlack = Color(0xff131213);
  static const shimmerBaseColor = Color(0xff151515);

  static const Color primaryColor = Color(0xFFed3a57);
  static const Color mostTrending1 = Colors.orangeAccent;
  static const Color mostTrending2 = Color(0xff64B5F6);
  static const Color mostTrending3 = Color(0xffEF9A9A);
  // ************** Grey Related Colors ***************.

  static const Color grey = Color(0xff9e9e9e);
  static const Color greyColor = Color(0xFF757575);
  static const Color bgGreyColor = Color(0xff060606);
  static const Color borderColor = Color(0xff302F2F);

  static const Color dotColor = Color(0xFFE0E0E0);

  static const Color lightGreen = Color(0xFFD7FFDD);
  static const Color lightGreen1 = Color(0xFF85FF97);
  static const Color darkGreen = Color(0xFF4AAF57);
  static const Color darkCemal = Color(0xFF4B360C);
  static const Color lightYellow = Color(0xFFFFD876);

  static const Color lightRed = Color(0xFFFFD7D7);
  static const Color lightRed1 = Color(0xFFFF8585);
  static const Color darkRed = Color(0xFFD72929);
  static const Color blue = Colors.blue;

  static const Color luxuryDarkBase = Color(0xff0D0B0A);
  static const Color luxuryDarkSurface = Color(0xff161210);
  static const Color luxuryCardSelected = Color(0xff1F1915);

  static const LinearGradient luxuryBackgroundGradient = LinearGradient(
    colors: [Color(0xff161210), Color(0xff0D0B0A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient goldBorderGradient = LinearGradient(
    colors: [
      AppColor.colorLightOrange.withValues(alpha: 0.6),
      AppColor.colorLightYellow.withValues(alpha: 0.15),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient unselectedBorderGradient = LinearGradient(
    colors: [
      AppColor.colorWhite.withValues(alpha: 0.08),
      AppColor.colorWhite.withValues(alpha: 0.03),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFF97A61), Color(0xffFD3F99)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient primaryReverseGradient = LinearGradient(
    colors: [
      Color(0xffFD3F99),
      Color(0xFFF97A61),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient lightBlackGradient = LinearGradient(
    colors: [AppColor.colorBlack.withAlpha(120), AppColor.colorBlack.withAlpha(120)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient vipGradient = LinearGradient(
    colors: [AppColor.colorLightOrange, AppColor.colorLightYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient subscribeGradient = LinearGradient(
    colors: [AppColor.colorLightYellow, AppColor.colorLightOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient viewsGradient = LinearGradient(
    colors: [Color(0xffFB7C61), Color(0xffFE3E9B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient linesGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.58, 1.0], // 0% → 58% → 100%
    colors: [
      Color(0x66FFFFFF), // 100% white
      // 40% opacity white → matches your 166 alpha
      Color(0xFFFFFFFF),
      Color(0x66FFFFFF), // 100% white again
    ],
  );
}
