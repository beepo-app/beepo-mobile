import 'package:flutter/material.dart';
import 'package:beepo/Constants/constants.dart';
import 'package:beepo/Utils/sizing.dart';

const kwelcomeTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const kRememberMeTextStyle = TextStyle(
  fontSize: 14,
);

const kForgotPasswordTextStyle = TextStyle(
  fontSize: 14,
  color: AppColors.borderPink,
);

const kconnectTextStyle = TextStyle(
  fontSize: 16,
);
const kusernameTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
TextStyle shopTitleTextStyle = TextStyle(
  fontSize: 18.sp,
  fontWeight: FontWeight.w600,
);
TextStyle shopSubTitleTextStyle = TextStyle(
  fontSize: 14.sp,
  fontWeight: FontWeight.w400,
);
TextStyle welcomeBoldTextStyle = TextStyle(
  fontSize: 28.sp,
  fontWeight: FontWeight.w700,
  color: Colors.black,
);
TextStyle itemTitleBoldTextStyle = TextStyle(
  fontSize: 12.sp,
  fontWeight: FontWeight.w700,
);
TextStyle shopSectionTitleTextStyle = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
  // color: AppColors.hintBlack,
);
TextStyle searchHintTextStyle(BuildContext context) => TextStyle(
      fontSize: 14.sp,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).primaryColorLight,
    );

TextStyle followersFollowingTextStyle = TextStyle(
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w500,
    fontSize: 12.sp);

final gradientBoxDecoration = BoxDecoration(
  gradient: AppColors.pinkTextGradient,
  borderRadius: BorderRadius.circular(20),
);

final greyBoxDecoration = BoxDecoration(
  color: Colors.transparent,
  border: Border.all(color: AppColors.borderGrey),
  borderRadius: BorderRadius.circular(20),
);
final greyFilledBoxDecoration = BoxDecoration(
  color: AppColors.greyBoxBg,
  border: Border.all(color: AppColors.borderGrey),
  borderRadius: BorderRadius.circular(4),
);

const kbuttonTextStyle = TextStyle(
  color: AppColors.white,
  fontSize: 16.0,
);

const kstoryTextStyle = TextStyle(
  fontSize: 10.0,
  fontWeight: FontWeight.w600,
);
const kpostNameStyle = TextStyle(
  fontSize: 16,
);

const ktimeAgoStyle = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w300,
);

const klikesStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
);

const chatAuthorTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);
