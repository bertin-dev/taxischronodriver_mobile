// // ignore_for_file: avoid_print, unnecessary_null_comparison

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:taxischronodriver/screens/prixtype.dart';

// import 'dart:async';

// import '../services/mapservice.dart';
// import '../varibles/variables.dart';

// class SearchDestinaitionPage extends StatefulWidget {
//   const SearchDestinaitionPage({super.key});

//   @override
//   State<SearchDestinaitionPage> createState() => _SearchDestinaitionPageState();
// }

// class _SearchDestinaitionPageState extends State<SearchDestinaitionPage> {
//   Future? places;

//   // //////////////////////////
//   // les controlleurs de champs de saisie;
//   /////////////
//   TextEditingController controllerstart = TextEditingController();
//   TextEditingController controllersend = TextEditingController();

//   // /// les variables qui seront envoyer pour mes positions de départ et d'arriver
//   Place? endPlace;
//   Place? startPlace;

//   bool isDepart =
//       true; //permet de vérifier que le foccus est sur le champs de départ

//   bool find =
//       false; //permet de vérifier que la recherche est terminer afin d'affiche le bouton de validation

//   bool vide = true; //permet de vérifier que le champs de saisie n'est pas vide
//   //

//   currentAddess() async {
//     if (GooGleMapServices.currentPlace != null) {
//       setState(() {
//         startPlace = GooGleMapServices.currentPlace!;
//         controllerstart.text = startPlace!.mainName;
//       });
//     }
//   }

//   @override
//   void initState() {
//     currentAddess();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: FaIcon(
//             Icons.close,
//             color: vert,
//             size: 30,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: FaIcon(
//               Icons.history,
//               color: vert,
//               size: 30,
//             ),
//           ),
//         ],
//         title: Text(
//           "Donner votre étinnéraire",
//           style: police.copyWith(
//               fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: InkWell(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // les champ de recherche.

//               SizedBox(
//                 height: 150,
//                 width: double.infinity,
//                 child: Card(
//                   shape: shapeBorder,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: champsdeRecherche(
//                             iconData: Icons.person_pin,
//                             onTap: () {
//                               setState(() {
//                                 isDepart = true;
//                                 find = false;
//                               });
//                             },
//                             controller: controllerstart,
//                             changement: (value) {
//                               setState(() {
//                                 vide = value.trim().isEmpty;
//                               });
//                               findPlace(value);
//                               find = false;
//                             },
//                             hintext: "Point de départ"),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: champsdeRecherche(
//                           iconData: Icons.local_taxi,
//                           onTap: () {
//                             setState(() {
//                               isDepart = false;
//                               find = false;
//                             });
//                           },
//                           controller: controllersend,
//                           changement: (value) {
//                             setState(() {
//                               vide = value.trim().isEmpty;
//                               find = false;
//                             });
//                             findPlace(value);
//                           },
//                           hintext: "Ou allons nous ?",
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               //  la liste des résultas.

//               Expanded(
//                 child: Card(
//                   shape: shapeBorder,
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     child: places == null || vide
//                         ? Center(
//                             child: Text(
//                             "Recherchez un endroit",
//                             style: police.copyWith(
//                                 fontWeight: FontWeight.w900,
//                                 letterSpacing: 3,
//                                 wordSpacing: 2),
//                           ))
//                         : FutureBuilder(
//                             future: places!,
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return const Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               } else {
//                                 if ((!snapshot.hasError &&
//                                     snapshot.hasData &&
//                                     snapshot.data!.isNotEmpty)) {
//                                   return ListView.separated(
//                                     keyboardDismissBehavior:
//                                         ScrollViewKeyboardDismissBehavior
//                                             .onDrag,
//                                     itemCount: snapshot.data!.length,
//                                     itemBuilder: (context, index) {
//                                       final place = snapshot.data!;
//                                       return placeDisplay(
//                                         place: place[index],
//                                         ontap: () =>
//                                             setController(place[index]),
//                                       );
//                                     },
//                                     separatorBuilder: (context, index) =>
//                                         buildDivider(),
//                                   );
//                                 }
//                                 if (snapshot.hasError) {
//                                   return Center(
//                                       child: Text(
//                                     snapshot.error.toString(),
//                                     style: police.copyWith(
//                                         fontWeight: FontWeight.w900,
//                                         letterSpacing: 3,
//                                         wordSpacing: 2),
//                                   ));
//                                 } else if (snapshot.data!.isEmpty && !vide) {
//                                   return Center(
//                                       child: Text(
//                                     'Aucun androit ne corespond a votre recherche ',
//                                     style: police.copyWith(
//                                         fontWeight: FontWeight.w900,
//                                         letterSpacing: 3,
//                                         wordSpacing: 2),
//                                   ));
//                                 } else {
//                                   return const Center(
//                                     child: CircularProgressIndicator(),
//                                   );
//                                 }
//                               }
//                             }),
//                   ),
//                 ),
//               ),
//               // on affiche le boutton de validation si et seulement si les deux point sont non vide.
//               find
//                   ? Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 20),
//                       child: boutonText(
//                         context: context,
//                         action: () => createRouteModel(),
//                         text: "Continuer",
//                       ),
//                     )
//                   : const SizedBox.shrink()
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// // fonction permettant d'afficher les resultats de la map
//   Widget placeDisplay({required Place place, required void Function() ontap}) {
//     return ListTile(
//       leading: const Icon(Icons.location_on_rounded),
//       onTap: ontap,
//       title: Text(place.mainName,
//           style: police.copyWith(fontWeight: FontWeight.bold)),
//       subtitle: Text(
//         place.secondaryName,
//         style: police,
//       ),
//     );
//   }

// // permet de modifier les places des point de départ et d'arrivé en fonction du lieu selectionner

//   setController(Place place) {
//     FocusScope.of(context).unfocus();
//     if (isDepart) {
//       setState(() {
//         startPlace = place;
//         controllerstart.text = place.mainName;
//         find =
//             (controllerstart.text.isNotEmpty && controllersend.text.isNotEmpty);
//         places = null;
//       });
//     } else {
//       setState(() {
//         endPlace = place;
//         controllersend.text = place.mainName;
//         find =
//             (controllerstart.text.isNotEmpty && controllersend.text.isNotEmpty);
//         places = null;
//       });
//     }
//   }

// // function de la map autocomplete elle permet le recherche automatique.
//   findPlace(String valeur) {
//     try {
//       setState(() {
//         places = GooGleMapServices.chekPlaceAutoComplette(valeur, "userToken");
//       });
//     } catch (e) {
//       debugPrint('erreur: $e');
//     }
//   }

//   // fonction permettant de creer la route à envoyé dans la page suivante

//   createRouteModel() async {
//     try {
//       dialogueDechargement(context);

//       print("Start ${startPlace!.toMap()}");

//       Adresse? start;
//       Adresse? end;

//       // creation de la première adresse : adresse de départ

//       await GooGleMapServices.checkDetailFromPlace(startPlace!.placeId)
//           .then((value) {
//         if (value != null) {
//           print(value.toMap());
//           start = value;
//         } else {
//           showAboutDialog(
//             context: context,
//             children: [
//               const Text("Error le retour est null"),
//             ],
//           );
//         }
//       });
//       print("Start adresse ${start!.toMap()}");

//       // creation de la dernière adresse : adresse d'arrivé

//       print("ENd ${endPlace!.toMap()}");
//       await GooGleMapServices.checkDetailFromPlace(endPlace!.placeId)
//           .then((value) {
//         if (value != null) {
//           print(value.toMap());
//           end = value;
//         } else {}
//       });
//       print("End adresse ${end!.toMap()}");

//       // création de la route service.

//       await GooGleMapServices()
//           .getRoute(
//         start: (start as Adresse).adresseposition,
//         end: (end as Adresse).adresseposition,
//       )
//           .then((value) {
//         print(value!.toMap());
//         Navigator.of(context).pop();
//         Navigator.of(context).push(
//           PageTransition(
//               child: PrixType(
//                 routeModel: value,
//                 adresseend: end!,
//                 adressestart: start!,
//               ),
//               type: PageTransitionType.fade),
//         );
//       });
//     } catch (e) {
//       debugPrint('Error : $e');
//     }
//   }

//   // fin de la classe principales
// }

// final shapeBorder =
//     RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));
// Widget buildDivider() => const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.0),
//       child: Divider(),
//     );

// // fonction permettant d'afficher la boite de dialogue de chargement
// dialogueDechargement(BuildContext context) {
//   showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return SimpleDialog(
//           contentPadding: const EdgeInsets.all(15),
//           children: [
//             Center(
//               child: SizedBox(
//                 height: 60,
//                 width: 60,
//                 child: CircularProgressIndicator(
//                   color: vert,
//                 ),
//               ),
//             )
//           ],
//         );
//       });
// }
