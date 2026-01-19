// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class CustomCircleAvatar extends StatelessWidget {
//   final String? url;
//   final double radius;
//   final String errorImage;
//   final Color? backgroundColor;
//   final bool isOnTap;

//   const CustomCircleAvatar({
//     Key? key,
//     this.url = "",
//     this.errorImage = "",
//     this.radius = 25,
//     this.backgroundColor,
//     this.isOnTap = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String? urlPreview = url?.isEmpty ?? true ? "" : url!;
//     return (urlPreview.isEmpty)
//         ? _buildErrorWidget()
//         : CachedNetworkImage(
//             height: radius * 2,
//             width: radius * 2,
//             fit: BoxFit.cover,
//             imageUrl: urlPreview,
//             imageBuilder: (context, imageProvider) => GestureDetector(
//               onTap: isOnTap
//                   ? () {
//                       if (urlPreview.isNotEmpty) {
//                         // Handle the image tap action
//                       }
//                     }
//                   : null,
//               child: Container(
//                 height: radius * 2,
//                 width: radius * 2,
//                 decoration: BoxDecoration(
//                   color: backgroundColor,
//                   shape: BoxShape.circle,
//                   image:
//                       DecorationImage(image: imageProvider, fit: BoxFit.cover),
//                 ),
//               ),
//             ),
//             placeholder: (context, url) => _buildShimmerEffect(),
//             errorWidget: (context, url, error) => _buildErrorWidget(),
//           );
//   }

//   Widget _buildErrorWidget() {
//     return Container(
//       height: radius * 2,
//       width: radius * 2,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: backgroundColor,
//         // image: DecorationImage(
//         //   image: AssetImage(
//         //     errorImage.isEmpty ? AssetsPath.profileAvatar : errorImage,
//         //   ),
//         //   fit: BoxFit.cover,
//         // ),
//       ),
//     );
//   }

//   Widget _buildShimmerEffect() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade100,
//       highlightColor: Colors.grey.shade200,
//       child: Container(
//         height: radius * 2,
//         width: radius * 2,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.grey.shade500,
//         ),
//       ),
//     );
//   }
// }

// class CustomCachedImage extends StatelessWidget {
//   final String? url;
//   final double? height;
//   final double? width;
//   final String errorimage;
//   final BorderRadius borderRadius;
//   final bool fullview;
//   final dynamic onTap;
//   final bool opacity;
//   final BoxFit fit;

//   const CustomCachedImage({
//     super.key,
//     this.url = "",
//     this.height,
//     this.width,
//     this.errorimage = "",
//     this.borderRadius = const BorderRadius.all(Radius.circular(10)),
//     this.fullview = true,
//     this.opacity = false,
//     this.onTap,
//     this.fit = BoxFit.cover,
//   });

//   @override
//   Widget build(BuildContext context) {
//     String? urlPreview = url?.isEmpty ?? true ? "" : url!;
//     return urlPreview.isEmpty
//         ? _buildErrorWidget()
//         : GestureDetector(
//             onTap: onTap ??
//                 () {
//                   if (fullview && urlPreview != "") {
//                     // Go.push(context, ImageFullView(id: url!));
//                   }
//                 },
//             child: CachedNetworkImage(
//               height: height,
//               width: width,
//               fit: fit,
//               imageUrl: urlPreview,
//               imageBuilder: (context, imageProvider) => Container(
//                 height: height,
//                 width: width,
//                 decoration: BoxDecoration(
//                   borderRadius: borderRadius,
//                   image: DecorationImage(image: imageProvider, fit: fit),
//                 ),
//                 child: opacity ? _opacityWidget() : Container(),
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
//               errorWidget: (context, url, error) => _buildErrorWidget(),
//             ),
//           );
//   }

//   // Widget for handling error cases
//   Widget _buildErrorWidget() {
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         borderRadius: borderRadius,
//         // image: DecorationImage(
//         //   image: AssetImage(
//         //     errorimage == "" ? AssetsPath.image : errorimage,
//         //   ),
//         //   fit: BoxFit.fill,
//         // ),
//       ),
//     );
//   }

//   Widget _opacityWidget() {
//     return Container();
//   }
// }
