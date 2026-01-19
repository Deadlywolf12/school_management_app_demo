// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shimmer/shimmer.dart';

// class CustomCirleAvatar extends StatelessWidget {
//   String? url;
//   double height;
//   double width;
//   String errorImage;
//   CustomCirleAvatar(
//       {super.key,
//       this.url = "",
//       this.errorImage = "",
//       this.height = 50,
//       this.width = 50});

//   @override
//   Widget build(BuildContext context) {
//     return CachedNetworkImage(
//       height: height,
//       width: width,
//       fit: BoxFit.cover,
//       imageUrl: url ?? "",
//       imageBuilder: (context, imageProvider) => Container(
//         height: height,
//         width: width,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
//         ),
//       ),
//       placeholder: (context, url) => Shimmer.fromColors(
//         baseColor: Colors.grey.shade100,
//         highlightColor: Colors.grey.shade200,
//         child: Container(
//           height: height,
//           width: width,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.grey.shade500,
//           ),
//         ),
//       ),
//       errorWidget: (context, url, error) => Container(
//         height: height,
//         width: width,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.grey.shade500,
//           image: DecorationImage(
//             image: AssetImage(
//               errorImage == "" ? "" : errorImage,
//             ),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CustomCachedImage extends StatelessWidget {
//   final String? url;
//   final double height;
//   final double width;
//   final String errorimage;
//   final BorderRadius borderRadius;
//   final bool fullview;
//   final dynamic onTap;
//   final bool opacity;

//   const CustomCachedImage({
//     super.key,
//     this.url = "",
//     this.height = 50,
//     this.width = 50,
//     this.errorimage = "",
//     this.borderRadius = const BorderRadius.all(Radius.circular(10)),
//     this.fullview = true,
//     this.opacity = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return fullview
//         ? InkWell(
//             onTap: onTap ??
//                 () {
//                   if (fullview && url != "") {
//                     //  RouteNavigator.route(context, FullIm)
//                   }
//                 },
//             child: CachedNetworkImage(
//               height: height,
//               width: width,
//               fit: BoxFit.cover,
//               imageUrl: url ?? "",
//               imageBuilder: (context, imageProvider) => Container(
//                 height: height,
//                 width: width,
//                 decoration: BoxDecoration(
//                   borderRadius: borderRadius,
//                   image:
//                       DecorationImage(image: imageProvider, fit: BoxFit.cover),
//                 ),
//                 child: opacity ? opicityWidget() : Container(),
//               ),
//               placeholder: (context, url) => Shimmer.fromColors(
//                 baseColor: Colors.grey.shade100,
//                 highlightColor: Colors.grey.shade200,
//                 child: Container(
//                   height: height,
//                   width: width,
//                   decoration: BoxDecoration(
//                     borderRadius: borderRadius,
//                     color: Colors.grey.shade500,
//                   ),
//                 ),
//               ),
//               errorWidget: (context, url, error) => Container(
//                 height: height,
//                 width: width,
//                 decoration: BoxDecoration(
//                   borderRadius: borderRadius,
//                   image: DecorationImage(
//                       image: AssetImage(
//                         errorimage == ""
//                             ? "assets/images/png/error-image.png"
//                             : errorimage,
//                       ),
//                       fit: BoxFit.cover),
//                 ),
//               ),
//             ),
//           )
//         : CachedNetworkImage(
//             height: height,
//             width: width,
//             fit: BoxFit.cover,
//             imageUrl: url ?? "",
//             imageBuilder: (context, imageProvider) => Container(
//               height: height,
//               width: width,
//               decoration: BoxDecoration(
//                 borderRadius: borderRadius,
//                 image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
//               ),
//               child: opacity ? opicityWidget() : Container(),
//             ),
//             placeholder: (context, url) => Shimmer.fromColors(
//               baseColor: Colors.grey.shade100,
//               highlightColor: Colors.grey.shade200,
//               child: Container(
//                 height: height,
//                 width: width,
//                 decoration: BoxDecoration(
//                   borderRadius: borderRadius,
//                   color: Colors.grey.shade500,
//                 ),
//               ),
//             ),
//             errorWidget: (context, url, error) => Container(
//               height: height,
//               width: width,
//               decoration: BoxDecoration(
//                 borderRadius: borderRadius,
//                 image: DecorationImage(
//                     image: AssetImage(
//                       errorimage == ""
//                           ? "assets/images/png/error-image.png"
//                           : errorimage,
//                     ),
//                     fit: BoxFit.cover),
//               ),
//             ),
//           );
//   }

//   Widget opicityWidget() {
//     return Container(
//         // padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//             // gradient: LinearGradient(
//             //   colors: [
//             //     themeblackcolor.withOpacity(0.5),
//             //     themeblackcolor.withOpacity(0.5),
//             //     themeblackcolor.withOpacity(0.5),
//             //     themeblackcolor.withOpacity(0.5),
//             //   ],
//             //   begin: Alignment.topCenter,
//             //   end: Alignment.bottomCenter,
//             // ),
//             ));
//   }
// }
