// import 'package:flutter/material.dart';
// import 'package:taxischronodriver/constants.dart';

// class PackageUi extends StatefulWidget {
//   const PackageUi({Key? key}) : super(key: key);

//   @override
//   State<PackageUi> createState() => _PackState();
// }

// class _PackState extends State<PackageUi> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // drawer: const SideBar(),
//       body: Padding(
//         padding: const EdgeInsets.only(right: 10, left: 10, bottom: 0),
//         child: GestureDetector(
//           onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
//           child: ListView(
//             physics: const BouncingScrollPhysics(),
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 20,
//                       ),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           suffixIcon: const Icon(Icons.search),
//                           contentPadding:
//                               const EdgeInsets.only(left: 15, right: 10),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                           hintText: "Rechercher un Paquage",
//                           hintStyle: const TextStyle(
//                               fontSize: 14, fontStyle: FontStyle.italic),
//                         ),
//                         style: const TextStyle(fontSize: 18),
//                         cursorHeight: 30,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 8,
//                   ),
//                   ElevatedButton.icon(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           elevation: 0,
//                           padding: const EdgeInsets.only(
//                               top: 12, bottom: 12, left: 5, right: 10),
//                           shape: RoundedRectangleBorder(
//                               side: BorderSide(
//                                   width: 2, color: kTextColor.withOpacity(.6)),
//                               borderRadius: BorderRadius.circular(5))),
//                       icon: const Icon(
//                         Icons.filter_alt_rounded,
//                         color: kTextColor,
//                         size: 20,
//                       ),
//                       label: const Text(
//                         "Filtrer",
//                         style: TextStyle(
//                             fontSize: 18,
//                             color: kTextColor,
//                             fontWeight: FontWeight.bold),
//                       ))
//                 ],
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(top: 30, bottom: 20),
//                 child: Text(
//                   "Paquage Disponible",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(top: 30, bottom: 20),
//                 child: Text(
//                   "package le plus souscrit",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               GridView(
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 3,
//                     mainAxisSpacing: 5,
//                     mainAxisExtent: 245),
//                 children: [
//                   packDetailGrid("Pack1", 1000, 4.5, 'illustration1.jpg'),
//                   packDetailGrid("Pack2", 2000, 4.5, 'illustration2.jpg'),
//                   packDetailGrid("Pack3", 3000, 4.5, 'illustration3.png'),
//                   packDetailGrid("Pack4", 4000, 4.5, 'illustration4.JPG'),
//                   packDetailGrid("Pack5", 5000, 4.5, 'illustration2.jpg'),
//                   packDetailGrid("Pack6", 500, 4.5, 'illustration1.jpg'),
//                 ],
//               ),
//               const SizedBox(
//                 height: 50,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget packDetail(String name, int charge, double rating, String image) {
//     return GestureDetector(
//       onTap: () {},
//       child: Card(
//         elevation: 2,
//         child: Column(
//           children: [
//             Container(
//               height: 96,
//               width: 180,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(5), topRight: Radius.circular(5)),
//                 image: DecorationImage(
//                     image: AssetImage('images/$image'), fit: BoxFit.fill),
//               ),
//             ),
//             Container(
//               width: 180,
//               padding:
//                   const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFEBFAFF),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.star,
//                         color: kPrimaryColor,
//                         size: 16,
//                       ),
//                       const SizedBox(
//                         width: 3,
//                       ),
//                       Text(
//                         rating.toString(),
//                         style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 11,
//                             fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                   Text(
//                     name,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const Icon(
//                     Icons.security,
//                     size: 16,
//                     color: Colors.cyan,
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               width: 180,
//               padding: const EdgeInsets.only(
//                   top: 10, left: 10, right: 10, bottom: 5),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       careTile("Nombre de Ticket"),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       careTile("Validité")
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     children: [
//                       careTile("Avantages"),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       careTile("Description")
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//                 width: 180,
//                 padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(5),
//                       bottomRight: Radius.circular(5)),
//                   color: Color(0xFFFFFFFF),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 3),
//                         decoration: const BoxDecoration(
//                           border: Border(
//                             top: BorderSide(width: 2, color: kPrimaryColor),
//                             bottom: BorderSide(width: 2, color: kPrimaryColor),
//                           ),
//                         ),
//                         child: const Text(
//                           "Souscrire",
//                           style: TextStyle(
//                               color: kPrimaryColor,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 5, horizontal: 12),
//                       color: kPrimaryColor,
//                       child: Text(
//                         'F cfa $charge',
//                         style: const TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     )
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget packDetailGrid(String name, int charge, double rating, String image) {
//     return GestureDetector(
//       onTap: () {},
//       child: Card(
//         elevation: 2,
//         child: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 height: 96,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(5),
//                       topRight: Radius.circular(5)),
//                   image: DecorationImage(
//                       image: AssetImage('images/$image'), fit: BoxFit.fill),
//                 ),
//               ),
//             ),
//             Container(
//               padding:
//                   const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFEBFAFF),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.star,
//                         color: kPrimaryColor,
//                         size: 16,
//                       ),
//                       const SizedBox(
//                         width: 3,
//                       ),
//                       Text(
//                         rating.toString(),
//                         style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 11,
//                             fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                   Text(
//                     name,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const Icon(
//                     Icons.security,
//                     size: 16,
//                     color: Colors.cyan,
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               padding:
//                   const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       careTileGrid("100 tickets"),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       careTileGrid("Validité")
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     children: [
//                       careTileGrid("Avantage"),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       careTileGrid("Description")
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//                 padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(5),
//                       bottomRight: Radius.circular(5)),
//                   color: Color(0xFFFFFFFF),
//                 ),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
//                   color: kPrimaryColor,
//                   child: Text(
//                     'F cfa $charge',
//                     style: const TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                 )),
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.all(10),
//               padding: const EdgeInsets.symmetric(vertical: 3),
//               decoration: const BoxDecoration(
//                 border: Border(
//                   top: BorderSide(width: 2, color: kPrimaryColor),
//                   bottom: BorderSide(width: 2, color: kPrimaryColor),
//                 ),
//               ),
//               child: const Text(
//                 "Souscrire",
//                 style: TextStyle(
//                     color: kPrimaryColor, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget careTile(String title) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
//       decoration: BoxDecoration(
//           border: Border.all(width: 2, color: kPrimaryColor),
//           borderRadius: BorderRadius.circular(4)),
//       child: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
//       ),
//     );
//   }

//   Widget careTileGrid(String title) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//       decoration: BoxDecoration(
//           border: Border.all(width: 1.5, color: kPrimaryColor),
//           borderRadius: BorderRadius.circular(4)),
//       child: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
//       ),
//     );
//   }
// }
