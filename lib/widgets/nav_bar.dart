// import 'package:flutter/material.dart';

// import 'package:go_router/go_router.dart';
// import 'package:khatabookn/route_structure/go_router.dart';


// class ResponsiveNavBar extends StatefulWidget {
//   final ScrollController scrollController;
//   final GlobalKey howItWorksKey;
//   final GlobalKey aboutKey;
//   final GlobalKey teamKey;

//   const ResponsiveNavBar({
//     super.key,
//     required this.scrollController,
//     required this.howItWorksKey,
//     required this.aboutKey,
//     required this.teamKey,
//   });

//   @override
//   State<ResponsiveNavBar> createState() => _ResponsiveNavBarState();
// }

// class _ResponsiveNavBarState extends State<ResponsiveNavBar> {
//   void _scrollTo(GlobalKey key) {
//     final context = key.currentContext;
//     if (context != null) {
//       Scrollable.ensureVisible(
//         context,
//         duration: const Duration(milliseconds: 700),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isMobile = MediaQuery.of(context).size.width < 800;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       color: const Color.fromARGB(255, 12, 12, 21),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'FraudGuard',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),

//           if (!isMobile) ...[
//             // 🧭 Desktop Navbar
//             Row(
//               children: [
//                 _navItem('Home', () => widget.scrollController.animateTo(
//                       0,
//                       duration: const Duration(milliseconds: 700),
//                       curve: Curves.easeInOut,
//                     )),
//                 _navItem('How It Works', () => _scrollTo(widget.howItWorksKey)),
//                 _navItem('About', () => _scrollTo(widget.aboutKey)),
//                 _navItem('Team', () => _scrollTo(widget.teamKey)),
//                 const SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     // context.goNamed(MyRouter.selectUser);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(255, 2, 184, 138),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text('Try'),
//                 ),
//               ],
//             ),
//           ] else ...[
//             // 🍔 Mobile - Hamburger Button
//             IconButton(
//               icon: const Icon(Icons.menu, color: Colors.white, size: 28),
//               onPressed: () {
//                 showModalBottomSheet(
//                   context: context,
//                   backgroundColor: AppTheme.backgroundColor,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                   ),
//                   builder: (_) => _buildMobileMenu(context),
//                 );
//               },
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _navItem(String title, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       hoverColor: Colors.transparent,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMobileMenu(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _mobileItem('Home', () {
//             widget.scrollController.animateTo(
//               0,
//               duration: const Duration(milliseconds: 700),
//               curve: Curves.easeInOut,
//             );
//             Navigator.pop(context);
//           }),
//           _mobileItem('How It Works', () {
//             _scrollTo(widget.howItWorksKey);
//             Navigator.pop(context);
//           }),
//           _mobileItem('About', () {
//             _scrollTo(widget.aboutKey);
//             Navigator.pop(context);
//           }),
//           _mobileItem('Team', () {
//             _scrollTo(widget.teamKey);
//             Navigator.pop(context);
//           }),
//           const Divider(color: Colors.white24),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.goNamed(MyRouter.selectUser);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color.fromARGB(255, 2, 184, 138),
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
//             ),
//             child: const Text('Try Now'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _mobileItem(String title, VoidCallback onTap) {
//     return ListTile(
//       title: Center(
//         child: Text(
//           title,
//           style: const TextStyle(color: Colors.white, fontSize: 18),
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
// }
