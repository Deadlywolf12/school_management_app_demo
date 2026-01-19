import 'package:flutter/material.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/widgets/custom_button.dart';





class CustomDailog {
  // static loadingDailog(context) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) => WillPopScope(
  //       onWillPop: () async => true,
  //       child: const ProgressDialog(),
  //     ),
  //   );
  // }

  static yesNoDailog(
    context, {
    VoidCallback? onTapYes,
    VoidCallback? onTapNo,
    // DailogIconType iconType = DailogIconType.Warning,
    String title = "",
    String yes = "Yes",
    String no = "No",
  }) {
    final size = MediaQuery.of(context).size;
    return showDialog(
      barrierDismissible: true,

      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Container(
            decoration: BoxDecoration(
           
              borderRadius: BorderRadius.circular(20),
            ),
            height: 280,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.network(
                  //   iconType == DailogIconType.Warning
                  //       ? "https://cdn-icons-png.flaticon.com/512/8213/8213126.png"
                  //       : iconType == DailogIconType.Approve
                  //           ? "https://cdn-icons-png.flaticon.com/512/6785/6785304.png"
                  //           : "https://cdn-icons-png.flaticon.com/512/4315/4315482.png",
                  //   height: 80,
                  // ),
                  10.kH,
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  30.kH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomButton(
                          buttoncolor: AppTheme.grey,
                          onTap: onTapNo ?? () {Go.pop(context);},
                          child: Text(no),
                        ),
                      ),
                      20.kW,
                      Expanded(
                        child: CustomButton(
                          buttoncolor: AppTheme.primaryColor,
                          onTap: onTapYes ?? () {},
                          child: Text(
                            yes,
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static infoShow(
    context, {
    // DailogIconType iconType = DailogIconType.Warning,
    String title = "",
  }) {
    final size = MediaQuery.of(context).size;
    return showDialog(
      barrierDismissible: true,

      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(20),
            ),
            height: 280,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.network(
                  //   iconType == DailogIconType.Warning
                  //       ? "https://cdn-icons-png.flaticon.com/512/8213/8213126.png"
                  //       : iconType == DailogIconType.Approve
                  //           ? "https://cdn-icons-png.flaticon.com/512/6785/6785304.png"
                  //           : "https://cdn-icons-png.flaticon.com/512/4315/4315482.png",
                  //   height: 80,
                  // ),
                  10.kH,
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  10.kH,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class ProgressDialog extends StatelessWidget {
//   final double height;
//   final double width;
//   const ProgressDialog({this.height = 500, this.width = 500, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         height: height,
//         width: width,
//         // child: SpinKitFadingCircle(
//         //   color: Palette.themecolor,
//         // ),
//         child: const SpinKitDualRing(color: AppTheme.primaryColor),
//       ),
//     );
//   }
// }
