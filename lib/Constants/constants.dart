import 'package:flutter/material.dart';

const kbuttonColour = Color(0xff0080FF);

class AppColors {
  AppColors._();

  static const primaryColor = Color.fromRGBO(0, 128, 255, 1);
  static const white = Color.fromRGBO(255, 255, 255, 1);
  static const black = Color.fromRGBO(0, 0, 0, 1);
  static const textGrey = Color.fromRGBO(33, 33, 33, 1);
  static const hintBlack = Color.fromRGBO(53, 56, 63, 1);
  static const greyBoxBg = Color.fromRGBO(241, 240, 240, 1);
  static const dividerGrey = Color.fromRGBO(190, 190, 190, 0.7);
  static const borderGrey = Color.fromRGBO(228, 228, 228, 1);
  static const chipBgGrey = Color.fromRGBO(231, 231, 231, 1);
  static const backgroundGrey = Color.fromRGBO(251, 254, 255, 1);
  static const inactiveGrey = Color.fromRGBO(202, 200, 200, 1);
  static const activeTextColor = Color.fromRGBO(4, 185, 109, 1);
  static const inactiveTextColor = Color.fromRGBO(213, 132, 24, 1);
  static const borderPink = Color.fromRGBO(220, 73, 27, 1);
  static const favouriteButtonRed = Color.fromRGBO(238, 14, 4, 1);
  static const labelColor = Color.fromRGBO(180, 180, 180, 1);
  static const onlineColor = Color.fromRGBO(20, 119, 78, 1);
  static const chatcolor = Color.fromRGBO(205, 217, 222, 1);
  static const replyColour = Color.fromRGBO(246, 248, 249, 1);
  static const overlayColor = Color.fromRGBO(117, 117, 117, 1);
  // gradient
  static const pinkTextGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(229, 5, 31, 1),
      Color.fromRGBO(220, 73, 27, 1),
      Color.fromRGBO(214, 44, 229, 1),
      Color.fromRGBO(229, 5, 31, 1),
      Color.fromRGBO(229, 159, 58, 1),
    ],
  );
}

const String baseImagePath = 'assets/';

// extension function to choose image file format
extension ImageExtension on String {
  String get svg => '$baseImagePath$this.svg';
  String get png => '$baseImagePath$this.png';
  String get jpeg => '$baseImagePath$this.jpeg';
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class AppImages {
  AppImages._();

  static final String logo = 'Vos-logo'.svg;
  static final String splashBg = 'splash_bg'.png;
  static final String buyerIcon = 'buyer_icon'.png;
  static final String sellerIcon = 'seller_icon'.png;
  static final String shoeImg = 'shoe_img'.png;
  static final String clotheImg = 'clothe_img'.png;
  static final String bagImg = 'bag_img'.png;
  static final String blueBagImg = 'blue_bag_img'.png;
  static final String shirtsImg = 'shirts_img'.png;
  static final String slidesImg = 'slides_img'.png;
  static final String sneakerImg = 'sneaker_img'.png;
  static final String trouserImg = 'trouser_img'.png;
  static final String sortIcon = 'sort_icon'.svg;
  static final String scanIcon = 'scan_icon'.svg;
  static final String closeIcon = 'close_Icon'.svg;
  static final String shippingIcon = 'shipping_icon'.svg;
  static final String shopBackArrow = 'arrow_back_icon'.svg;
  static final String sampleLadyInDress = 'lady_in_dress_img'.png;
  static final String productImg2 = 'product_img_2'.png;
  static final String productImg3 = 'product_img_3'.png;
  static final String productImg4 = 'product_img_4'.png;
  static final String errorImage = 'error_img'.png;
  static final String vosterLogoImg = 'voster_logo_img'.png;
  static final String sampleProfileImg = 'sample_profile_img'.png;
  static final String sendIcon = 'send'.svg;
  static final String saveIcon = 'Save'.svg;
  static final String pinIcon = 'Pin'.svg;
  static final String notificationsIcon = 'notification'.svg;

  static final String hideIcon = 'Hide'.svg;

  static final String avatar1 = 'avatar1'.png;
  static final String bell = 'bell'.svg;
  static final String menu = 'menu'.svg;
  static final String comment = 'comment'.svg;
  static final String love = 'love'.svg;
  static final String adimage1 = 'adimage1'.png;
  static final String woman1 = 'woman1'.png;
  static final String moneyman = 'moneyman'.jpeg;
  static final String home = 'icons8-home'.svg;
  static final String shop = 'shop'.svg;
  static final String search = 'search'.svg;
  static final String shareIcon = 'share_icon'.svg;
  static final String unfollowIcon = 'unfollow_icon'.svg;
  static final String addPost = 'add_post'.svg;
  static final String profile = 'profile'.svg;
  static final String camera = 'camera'.svg;
  static final String bigCameraIcon = 'big_camera_icon'.svg;
  static final String location = 'location'.svg;
  static final String cardIcon = 'card_icon'.svg;
  static final String editIcon = 'edit_icon'.svg;
  static final String masterCardIcon = 'master_card_logo'.svg;
  static final String visaCardIcon = 'visa_icon'.svg;
  static final String purchaseSuccessImg = 'purchase_success_img'.png;
  static final String purchaseFailedImg = 'purchase_failed_img'.png;
  static final String gallery = 'Gallery'.png;
  static final String newGallery = 'newGallery'.svg;
  static final String dummyimage = 'child'.jpeg;
  static final String edit = 'edit'.svg;
  static final String verified = 'verified-mark'.png;
  static final String doubleTick = 'doublecheck'.svg;
  static final String tick = 'check'.svg;
  static final String delete = 'delete'.svg;
  static final String forward = 'forwardd'.svg;
  static final String ellipse1 = 'Ellipse1'.png;
  static final String ellipse2 = 'Ellipse2'.png;
  static final String ellipse3 = 'Ellipse3'.png;
  static final String ellipse4 = 'Ellipse4'.png;
  static final String ellipse5 = 'Ellipse5'.png;
  static final String ellipse6 = 'Ellipse6'.png;
  static final String ellipse7 = 'Ellipse7'.png;
  static final String ellipse8 = 'Ellipse8'.png;
  static final String userFollow = 'user-follow'.svg;
  static final String rectangle1 = 'Rectangle1'.png;
  static final String rectangle2 = 'Rectangle2'.png;
  static final String rectangle3 = 'Rectangle3'.png;
  static final String rectangle4 = 'Rectangle4'.png;
  static final String rectangle5 = 'Rectangle5'.png;
  static final String rectangle6 = 'Rectangle6'.png;
  static final String voster = 'VOSTER'.svg;
  static final String profileAdd = 'profile-add'.svg;
  static final String moon = 'moon'.svg;
  static final String card = 'card'.svg;
  static final String profileCircle = 'profile-circle'.svg;
  static final String lock = 'lock'.svg;
  static final String shieldTick = 'shield-tick'.svg;
  static final String logout = 'logout'.svg;
}

class AppStrings {
  static const String appName = 'Voster';
  static const String iamBuyerText = "I’m a buyer";
  static const String iamSellerText = "I’m a seller";
  static const String discover = "Discover";
  static const String welcome = "Welcome";
  static const String discoverMore = "Discover more";
  static const String continueText = "Continue";
  static const String seeAll = "See All";
  static const String clothes = "Clothes";
  static const String addToCart = "Add to cart";
  static const String checkout = "Checkout";
  static const String change = "Change";
  static const String shipping = "Shipping";
  static const String payment = "Payment";
  static const String proceed = "Proceed";
  static const String review = "Review";
  static const String report = "Report";
  static const String save = "Save";
  static const String name = "Name";
  static const String edit = "Edit";
  static const String done = "Done";
  static const String block = "Block";
  static const String update = "Update";
  static const String comment = "Comment";
  static const String savePost = "Save Post";
  static const String pinPost = "Pin Post";
  static const String unfollow = "Unfollow";
  static const String editPost = "Edit Post";
  static const String deletePost = "Delete Post";
  static const String newMessage = "New Message";
  static const String hideFromProfile = "Hide from profile";
  static const String turnOffNotification =
      "Turn off notification for this post";
  static const String create = "Create";
  static const String follow = "Follow";
  static const String active = "Active";
  static const String inActive = "Inactive";
  static const String products = "Products";
  static const String sellingPrice = "Selling Price";
  static const String shareProfile = "Share Profile";
  static const String description = "Description";
  static const String expiryDate = "Expiry Date";
  static const String cardNumber = "Card Number";
  static const String selectCard = "Select Card";
  static const String addCard = "Add Card";
  static const String addProduct = "Add Product";
  static const String brandName = "Brand name";
  static const String contactAddress = "Contact Address";
  static const String selectCategory = "Select Category";
  static const String completeCheckout = "Complete Checkout";
  static const String paymentMethod = "Payment Method";
  static const String addNewAddress = "Add New Address";
  static const String sellersInformation = "Seller’s Information";
  static const String selectShippingAddress = "Select Shipping Address";
  static const String shopSearchHint = "What are you searching for?";
  static const String userSearchHint = 'Search';
  static const String whoCanComment = 'Who can comment?';
  static const String recommendedForYou = "Recommended for you";
  static const String regularPriceOptional = "Regular Price (Optional)";
  static const String shopWelcomeText = 'Welcome to Voster Ecommerce Store';
  static const String selectYourPositionText =
      'Kindly select your position before you can proceed.';
  static const String welcomeBack = "Welcome Back";
  static const String password = 'Password';
  static const String confirmPassword = "Confirm Password";
  static const String username = "Username";
  static const String forgotPassword = "Forget your Password";
  static const String connect = "Connnect with Voster today!";
  static const String rememberMe = "Remember Me";
  static const String noAccount = "Don't Have an account yet?";
  static const String paymentCollection = "payment";
  static const String savedCards = "savedCard";

}

shopItemBoxShadow(context) => BoxShadow(
    color: Theme.of(context).shadowColor,
    offset: const Offset(
      4,
      1,
    ),
    blurRadius: 2,
    spreadRadius: 1);

cameraIconBoxShadow(context) => BoxShadow(
      color: Theme.of(context).shadowColor,
      blurRadius: 3,
      spreadRadius: 5,
    );

const boxDecor = BoxDecoration(
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(20.0),
    bottomRight: Radius.circular(20.0),
  ),
  // image: DecorationImage(
  //   fit: BoxFit.fill,
  //   image: AssetImage('images/selfie2.webp'),
  // ),
);

// const boxDecore = BoxDecoration(
//   borderRadius: BorderRadius.circular(20),
//   // image: DecorationImage(
//   //   fit: BoxFit.fill,
//   //   image: AssetImage('images/selfie1.webp'),
//   // ),
// );
