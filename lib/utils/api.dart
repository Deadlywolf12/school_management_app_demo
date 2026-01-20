// import 'package:zameen_app/utils/constants.dart';

class Api {
  // static const signup = "${Constants.baseUrl}/user/auth/signup";
  // static const login = "${Constants.baseUrl}/user/auth/signin";
  // static String profileBase = "http://192.168.100.7:10000/uploads/";
  // String base = "http://192.168.0.117:1000/api/v1";

  String base = "http://192.168.100.8:2000/api/v1";
  String profileBase = "http://192.168.100.8:2000/public/";
  static User user = User();

}

class User {
  static Api api = Api();
  String googlesignup = "${api.base}/auth/google";
  String signup = "${api.base}/user/auth/signUp";
  String login = "${api.base}/user/auth/signIn";
  String verify = "${api.base}/user/auth/verify";
  String resend = "${api.base}/user/auth/resend";
  String forgot = "${api.base}/user/auth/forgot";
  String updatePassword = "${api.base}/user/auth/password";
  String updateProfile = "${api.base}/profile";
  String getprofile = "${api.base}/user//profile";
  String changePassowrd = "${api.base}/profile/password";
  String fcmNotification = "${api.base}/user/profile/fcm";
  String addWishlist = "${api.base}/app/wishlist";
  String getWishlist = "${api.base}/user/wishlist";
  String getProperty = "${api.base}/app/property";
  String userhome = "${api.base}/app/home";
  String propertyBooking = "${api.base}/app/property/booking";
  String getMyBooking = "${api.base}/user/booking";
  String getSellerDetail = "${api.base}/app/seller";
  String getUserNotification = "${api.base}/user/notification";
}

// class Seller {
//   static Api api = Api();
//   String signup = "${api.base}/seller/auth/signup";
//   String login = "${api.base}/seller/auth/signin";
//   String verify = "${api.base}/seller/auth/verify";
//   String resend = "${api.base}/seller/auth/resend";
//   String forgot = "${api.base}/seller/auth/forgot";
//   String updatePassword = "${api.base}/seller/auth/password";
//   String updateProfile = "${api.base}/seller/profile";
//   String sellerChangePass = "${api.base}/seller/profile/password";
//   String fcmNotification = "${api.base}/seller/profile/fcm";
//   String getprofile = "${api.base}/seller/profile";
//   String sellerproperty = "${api.base}/seller/property";
//   String getProperty = "${api.base}/seller/property";
//   String getSellerhome = "${api.base}/seller/home";
//   String getSellerBooking = "${api.base}/seller/property/booking";
//   String getSellerBookingStatus = "${api.base}/seller/property/booking/status";
//   String getSellerNotification = "${api.base}/seller/notification";
// }

// class Common {
//   static Api api = Api();

//   String state = "${api.base}/common?state=true";
//   String city = "${api.base}/common?city=true";
//   String type = "${api.base}/common?type=true";
//   String subtype = "${api.base}/common?subType=true";
//   String amenity = "${api.base}/common?amenity=true";
//   String unit = "${api.base}/common?unit=true";
// }
