// import 'package:zameen_app/theme/colors.dart';
// import 'package:zameen_app/theme/font_structures.dart';
// import 'package:zameen_app/theme/spacing.dart';
// import 'package:zameen_app/widgets/custom_button.dart';
// import 'package:zameen_app/widgets/custom_icon_button.dart';
// import 'package:flutter/material.dart';
// import 'package:zameen_app/widgets/custom_text_button.dart';

// int limitValue = 0;
// int changeColor = 0;
// int sortByValue = 0;

// List<String> typeItems = [
//   'Property Type',
//   'Appartment',
//   'Commercial',
//   'Commercial Villa',
//   'Office',
//   'Shop',
//   'Warehouse',
//   'Duplex',
//   'Farmhouse',
//   'HA',
//   'Mansion',
//   'Penthouse',
//   'Rental',
//   'Hotel Apartment',
//   'Residential FLoor',
//   'Residential Building',
//   'Retail',
//   'Sales',
//   'Studio',
//   'Town House',
//   'Villa',
// ];
// String? selectedItemType = 'Property Type';

// String? selectedItemcategory = 'Category Type';
// List<String> categoryitems = [
//   'Category Type',
//   'Purpose',
//   'Buy',
//   'Commercial Buy',
//   'Commercial Rent',
//   'Rent',
//   'Sale',
// ];
// String? selectedItemStates = 'States';
// List<String> stateitems = [
//   'States',
//   'Dubai',
//   'Paramount Tower & Hotel & Residence',
// ];
// String? selectItemCities = 'Abu Dhabi';
// List<String> cities = [
//   "Abu Dhabi",
//   "Al Barsha South Forth",
//   "Al Furjan",
//   "Al Jaddaf",
//   "Al Qouz",
//   "Arabian Ranches 2",
//   "Arjan",
//   "Business Bay",
//   "Damac Hills 2",
//   "Discovery Gardens",
//   "Downtown",
//   "Dubai",
//   "Dubai Creek Harbour",
//   "Dubai Harbour",
//   "Dubai Industrial Park",
//   "Dubai Land",
//   "Dubai Marina",
//   "Dubai Production City IMPZ",
//   "Dubai Residence Complex",
//   "Dubai Science Park",
//   "Dubai Sports City",
//   "Jebel Ali",
//   "JLT",
//   "Jumeirah Village Circle",
//   "Liwan",
//   "Meydan City",
//   "Meydan One",
//   "Mohammed Bin Rashid",
//   "Sharjah",
//   "The Greens"
// ];
// String? selectItemAreas = 'Downtown Dubai';
// List<String> areas = [
//   "Downtown Dubai",
//   "Area",
//   "1227",
//   "796",
//   "Airport Road",
//   "Akoya Oxygen",
//   "Al Badaa",
//   "Al Barsha",
//   "Al Furjan",
//   "Al Ghadeer",
//   "Al Hudaiba",
//   "Al Jaddaf",
//   "Al Khan",
//   "Al Mamzar",
//   "Al Mina",
//   "Al Muhaisnah",
//   "Al Qusais",
//   "Al Raha Beach",
//   "Al Reem Island",
//   "Al Safa",
//   "Al Sufouh",
//   "Al Tai",
//   "Al Warsan",
//   "Al Wasl",
//   "Arabian Ranches",
//   "Arabian Ranches 2",
//   "Arabian Ranches 3",
//   "Arjaan",
//   "Arjan",
//   "Azizi Roy",
//   "Bayz Tower",
//   "Bluewaters Island",
//   "Bukadra",
//   "Bur Dubai",
//   "Capital Bay Tower",
//   "DAMAC Hills",
//   "Damac Hills 2",
//   "DAMAC Hills 2 (Akoya By DAMAC)",
//   "Damac Lagoons",
//   "DIFC",
//   "Discovery Gardens",
//   "Disctrict 10",
//   "Downtown Jebel Ali",
//   "Dubai Creek Harbour",
//   "Dubai Creek Harbour (The Lagoons)",
//   "Dubai Harbour",
//   "Dubai Hills Estate",
//   "Dubai Industrial Park",
//   "Dubai Internet City",
//   "Dubai Investment Park",
//   "Dubai Land",
//   "Dubai Marina",
//   "Dubai Maritime City",
//   "Dubai Media City",
//   "Dubai Production City (IMPZ)",
//   "Dubai Residence Complex",
//   "Dubai Science Park",
//   "Dubai Silicon Oasis",
//   "Dubai South",
//   "Dubai South (Dubai World Central)",
//   "Dubai Sports City",
//   "Dubai Studio City",
//   "Dubai Waterfront",
//   "Dubai World Central",
//   "Dubailand",
//   "Elite Sports Residence",
//   "Elite Sports Residence 10",
//   "Falcon City Of Wonders",
//   "Golf City",
//   "International City",
//   "Jebel Ali",
//   "Jumeirah",
//   "Jumeirah Beach Residence",
//   "Jumeirah Beach Residence (JBR)",
//   "Jumeirah Golf Estates",
//   "Jumeirah Lake Towers",
//   "Jumeirah Lake Towers (JLT)",
//   "Jumeirah Village Circle",
//   "Jumeirah Village Circle (JVC)",
//   "Jumeirah Village Triangle",
//   "Jumeirah Village Triangle (JVT)",
//   "JVC District 10",
//   "Khalifa City A",
//   "Liwan",
//   "Majan",
//   "Meydan",
//   "Meydan City",
//   "Mirdif",
//   "Mogul Cluster",
//   "Mohammed Bin Rashid City",
//   "Motor City",
//   "Mudon",
//   "Muhaisnah",
//   "Muroor Area",
//   "Nad Al Sheba",
//   "Nadd Al Sheba",
//   "ORCHID RESIDENCE",
//   "Palm Jumeirah",
//   "Park Island",
//   "Quepoint",
//   "Reem",
//   "Remraam",
//   "Scala Tower",
//   "Sheikh Zayed Road",
//   "Sobha Hartland",
//   "Sobha Seahaven Tower B",
//   "The Gardens",
//   "The Greens",
//   "The Hills",
//   "The Lagoons",
//   "The Lakes",
//   "The Meadows",
//   "The Springs",
//   "The Valley",
//   "The Views",
//   "The Villa",
//   "The World Islands",
//   "Tilal Al Ghaf",
//   "Town Square",
//   "Umm Suqeim",
//   "Wadi Al Safa 2",
//   "Za'abeel"
// ];
// String? selectSorting = 'Default';
// List<String> sortingOptions = [
//   "Default",
//   "Price High to Low",
//   "Price Low to High",
//   "Newest first",
//   "Oldest first",
//   "Newest Edited",
//   "Oldest Edited",
//   "Bedrooms High to Low",
//   "Bedrooms Low to High",
//   "Bathrooms High to Low",
//   "Bathrooms Low to High"
// ];

// List selectBedroom = [];
// List selectBath = [];

// List<String> bedrooms = [
//   "Studio",
//   "1",
//   "2",
//   "3",
//   "4",
//   "5",
//   "6",
//   "7",
//   "8+",
// ];

// List<String> bathrooms = [
//   "1",
//   "2",
//   "3",
//   "4",
//   "5",
//   "6+",
// ];
// filters(size, context) {
//   RangeValues values = const RangeValues(0, 100);
//   return showModalBottomSheet(
//     backgroundColor: themeblackcolor,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(20),
//         topRight: Radius.circular(20),
//       ),
//     ),
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Container(
//             height: size.height / 100 * 80,
//             width: size.width,
//             decoration: const BoxDecoration(
//               color: themeblackcolor,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: Container(
//                         height: 5,
//                         width: 50,
//                         decoration: BoxDecoration(
//                           color: themegreycolor,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             "Filters",
//                             style: TextStyle(
//                               fontSize: largefontsize6,
//                               fontWeight: boldfontweight,
//                               color: themewhitecolor,
//                             ),
//                           ),
//                           CustomIconButton(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Icon(Icons.close),
//                           ),
//                         ],
//                       ),
//                     ),
//                     10.kH,
//                     const Divider(
//                       height: 0,
//                     ),
//                     // Spacing.v(20),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                             top: 20,
//                             bottom: 75,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                 ),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       child: DropdownButtonFormField(
//                                         decoration: InputDecoration(
//                                           border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                             borderSide: const BorderSide(
//                                               color: Palette.themecolor,
//                                             ),
//                                           ),
//                                           contentPadding:
//                                               const EdgeInsets.all(8),
//                                         ),
//                                         value: selectedItemType,
//                                         menuMaxHeight: 200,
//                                         isDense: true,
//                                         dropdownColor: themeblackcolor,
//                                         items: typeItems
//                                             .map(
//                                               (item) => DropdownMenuItem(
//                                                 value: item,
//                                                 child: Text(
//                                                   item,
//                                                   style: const TextStyle(
//                                                     fontSize: 12,
//                                                     color: themewhitecolor,
//                                                   ),
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             )
//                                             .toList(),
//                                         onChanged: (item) => setState(
//                                             () => selectedItemType != item),
//                                       ),
//                                     ),
//                                     10.kW,
//                                     Expanded(
//                                       child: DropdownButtonFormField(
//                                         decoration: InputDecoration(
//                                           border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                             borderSide: const BorderSide(
//                                               color: Palette.themecolor,
//                                             ),
//                                           ),
//                                           contentPadding:
//                                               const EdgeInsets.all(8),
//                                         ),
//                                         value: selectedItemcategory,
//                                         menuMaxHeight: 200,
//                                         dropdownColor: themeblackcolor,
//                                         isDense: true,
//                                         items: categoryitems
//                                             .map(
//                                               (item) => DropdownMenuItem(
//                                                 value: item,
//                                                 child: Text(
//                                                   item,
//                                                   style: const TextStyle(
//                                                     fontSize: 12,
//                                                     color: themewhitecolor,
//                                                   ),
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             )
//                                             .toList(),
//                                         onChanged: (item) => setState(
//                                             () => selectedItemcategory != item),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 10),
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: DropdownButtonFormField(
//                                             decoration: InputDecoration(
//                                               border: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                                 borderSide: const BorderSide(
//                                                   color: Palette.themecolor,
//                                                 ),
//                                               ),
//                                               contentPadding:
//                                                   const EdgeInsets.all(8),
//                                             ),
//                                             value: selectedItemStates,
//                                             menuMaxHeight: 200,
//                                             isDense: true,
//                                             dropdownColor: themeblackcolor,
//                                             items: stateitems
//                                                 .map(
//                                                   (item) => DropdownMenuItem(
//                                                     value: item,
//                                                     child: SizedBox(
//                                                       width: 160,
//                                                       child: Text(
//                                                         item,
//                                                         style: const TextStyle(
//                                                           fontSize: 12,
//                                                           color:
//                                                               themewhitecolor,
//                                                         ),
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                                 .toList(),
//                                             onChanged: (item) => setState(() =>
//                                                 selectedItemStates != item),
//                                           ),
//                                         ),
//                                         10.kW,
//                                         Expanded(
//                                           child: DropdownButtonFormField(
//                                             decoration: InputDecoration(
//                                               border: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                                 borderSide: const BorderSide(
//                                                   color: Palette.themecolor,
//                                                 ),
//                                               ),
//                                               contentPadding:
//                                                   const EdgeInsets.all(8),
//                                             ),
//                                             value: selectItemCities,
//                                             menuMaxHeight: 200,
//                                             isDense: true,
//                                             dropdownColor: themeblackcolor,
//                                             items: cities
//                                                 .map(
//                                                   (item) => DropdownMenuItem(
//                                                     value: item,
//                                                     child: Text(
//                                                       item,
//                                                       style: const TextStyle(
//                                                         fontSize: 12,
//                                                         color: themewhitecolor,
//                                                       ),
//                                                       maxLines: 1,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 )
//                                                 .toList(),
//                                             onChanged: (item) => setState(
//                                                 () => selectItemCities != item),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: DropdownButtonFormField(
//                                         decoration: InputDecoration(
//                                           border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                             borderSide: const BorderSide(
//                                               color: Palette.themecolor,
//                                             ),
//                                           ),
//                                           contentPadding:
//                                               const EdgeInsets.all(8),
//                                         ),
//                                         value: selectItemAreas,
//                                         menuMaxHeight: 200,
//                                         isDense: true,
//                                         dropdownColor: themeblackcolor,
//                                         items: areas
//                                             .map(
//                                               (item) => DropdownMenuItem(
//                                                 value: item,
//                                                 child: SizedBox(
//                                                   width: 160,
//                                                   child: Text(
//                                                     item,
//                                                     style: const TextStyle(
//                                                       fontSize: 12,
//                                                       color: themewhitecolor,
//                                                     ),
//                                                     maxLines: 1,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                             .toList(),
//                                         onChanged: (item) => setState(
//                                             () => selectItemAreas != item),
//                                       ),
//                                     ),
//                                     10.kW,
//                                     Expanded(
//                                       child: DropdownButtonFormField(
//                                         decoration: InputDecoration(
//                                           border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                             borderSide: const BorderSide(
//                                               color: Palette.themecolor,
//                                             ),
//                                           ),
//                                           contentPadding:
//                                               const EdgeInsets.all(8),
//                                         ),
//                                         value: selectSorting,
//                                         menuMaxHeight: 200,
//                                         dropdownColor: themeblackcolor,
//                                         isDense: true,
//                                         items: sortingOptions
//                                             .map(
//                                               (item) => DropdownMenuItem(
//                                                 value: item,
//                                                 child: Text(
//                                                   item,
//                                                   style: const TextStyle(
//                                                     fontSize: 12,
//                                                     color: themewhitecolor,
//                                                   ),
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             )
//                                             .toList(),
//                                         onChanged: (item) => setState(
//                                             () => selectSorting != item),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               10.kH,
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15.0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     const Text(
//                                       "Bedrooms",
//                                       style: TextStyle(
//                                         fontSize: mediumfontsize4,
//                                         color: themewhitecolor,
//                                       ),
//                                     ),
//                                     selectBedroom.isEmpty
//                                         ? Container()
//                                         : CustomTextButton(
//                                             buttonText: "Reset",
//                                             onTap: () {
//                                               setState(
//                                                 () {
//                                                   selectBedroom.clear();
//                                                 },
//                                               );
//                                             },
//                                             buttonTextStyle: const TextStyle(
//                                               fontSize: 18,
//                                               color: Palette.themecolor,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                   ],
//                                 ),
//                               ),
//                               5.kH,
//                               Wrap(
//                                 children: [
//                                   SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 15.0),
//                                       child: Row(
//                                         children: List.generate(
//                                           9,
//                                           (index) => InkWell(
//                                             onTap: () {
//                                               if (selectBedroom
//                                                   .contains(index)) {
//                                                 setState(
//                                                   () {
//                                                     selectBedroom.remove(index);
//                                                   },
//                                                 );
//                                               } else {
//                                                 setState(
//                                                   () {
//                                                     selectBedroom.add(index);
//                                                   },
//                                                 );
//                                               }
//                                             },
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(4.0),
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: selectBedroom
//                                                           .contains(index)
//                                                       ? Palette.themecolor
//                                                       : themewhitecolor,
//                                                   borderRadius:
//                                                       BorderRadius.circular(22),
//                                                   border: Border.all(
//                                                     color: selectBedroom
//                                                             .contains(index)
//                                                         ? Colors.transparent
//                                                         : themegreytextcolor,
//                                                   ),
//                                                 ),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(
//                                                       14.0),
//                                                   child: Center(
//                                                     child: Text(
//                                                       bedrooms[index],
//                                                       style: TextStyle(
//                                                         fontSize: 18,
//                                                         color: selectBedroom
//                                                                 .contains(index)
//                                                             ? themeblackcolor
//                                                             : themegreytextcolor,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               10.kH,
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15.0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     const Text(
//                                       "Baths",
//                                       style: TextStyle(
//                                         fontSize: mediumfontsize4,
//                                         color: themewhitecolor,
//                                       ),
//                                     ),
//                                     selectBath.isEmpty
//                                         ? Container()
//                                         : CustomTextButton(
//                                             buttonText: "Reset",
//                                             onTap: () {
//                                               setState(
//                                                 () {
//                                                   selectBath.clear();
//                                                 },
//                                               );
//                                             },
//                                             buttonTextStyle: const TextStyle(
//                                               fontSize: 18,
//                                               color: Palette.themecolor,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                   ],
//                                 ),
//                               ),
//                               5.kH,
//                               Wrap(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 15.0),
//                                     child: Row(
//                                       children: List.generate(
//                                         6,
//                                         (index) => InkWell(
//                                           onTap: () {
//                                             if (selectBath.contains(index)) {
//                                               setState(
//                                                 () {
//                                                   selectBath.remove(index);
//                                                 },
//                                               );
//                                             } else {
//                                               setState(
//                                                 () {
//                                                   selectBath.add(index);
//                                                 },
//                                               );
//                                             }
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 color:
//                                                     selectBath.contains(index)
//                                                         ? Palette.themecolor
//                                                         : themewhitecolor,
//                                                 borderRadius:
//                                                     BorderRadius.circular(22),
//                                                 border: Border.all(
//                                                   color:
//                                                       selectBath.contains(index)
//                                                           ? Colors.transparent
//                                                           : themegreytextcolor,
//                                                 ),
//                                               ),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(14.0),
//                                                 child: Center(
//                                                   child: Text(
//                                                     bathrooms[index],
//                                                     style: TextStyle(
//                                                       fontSize: 18,
//                                                       color: selectBath
//                                                               .contains(index)
//                                                           ? themeblackcolor
//                                                           : themegreytextcolor,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 5),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       "Price Range ",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         color: themewhitecolor,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     15.kH,
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Container(
//                                           height: 45,
//                                           width: size.width / 100 * 35,
//                                           decoration: BoxDecoration(
//                                             color: themewhitecolor,
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                             border: Border.all(
//                                               color: themegreytextcolor,
//                                             ),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   (values.start).toString(),
//                                                   style: const TextStyle(
//                                                     fontSize: 15,
//                                                     color: themeblackcolor,
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         const Text(
//                                           "to",
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             color: themegreytextcolor,
//                                           ),
//                                         ),
//                                         Container(
//                                           height: 45,
//                                           width: size.width / 100 * 35,
//                                           decoration: BoxDecoration(
//                                             color: themewhitecolor,
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                             border: Border.all(
//                                               color: themegreytextcolor,
//                                             ),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   (values.end).toString(),
//                                                   style: const TextStyle(
//                                                     fontSize: 15,
//                                                     color: themeblackcolor,
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     RangeSlider(
//                                       activeColor: Palette.themecolor,
//                                       inactiveColor: themegreytextcolor,
//                                       values: values,
//                                       divisions: 10,
//                                       min: 0,
//                                       max: 100,
//                                       onChanged: (newValue) {
//                                         setState(() {
//                                           values = newValue;
//                                         });
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SafeArea(
//                   child: Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                       height: 60,
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       decoration: const BoxDecoration(
//                         color: themeblackcolor,
//                         border: Border(
//                           top: BorderSide(
//                             color: themegreytextcolor,
//                           ),
//                         ),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CustomButton(
//                             height: 45,
//                             width: size.width,
//                             child: const Text(
//                               "Search",
//                               style: TextStyle(
//                                 color: themeblackcolor,
//                                 fontSize: mediumfontsize3,
//                               ),
//                             ),
//                             onTap: () {
//                               // Go.push(
//                               //   context,
//                               //   const SearchProjectsScreen(title: "Homes"),
//                               // );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }
