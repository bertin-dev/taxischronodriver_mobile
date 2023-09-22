// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:taxischronodriver/screens/mapreservation.dart';
// import 'package:taxischronodriver/services/mapservice.dart';
// import 'package:taxischronodriver/varibles/variables.dart';

// import '../modeles/autres/reservation.dart';

// class PrixType extends StatefulWidget {
//   final Adresse adressestart, adresseend;
//   final RouteModel routeModel;
//   const PrixType({
//     super.key,
//     required this.adresseend,
//     required this.adressestart,
//     required this.routeModel,
//   });

//   @override
//   State<PrixType> createState() => _PrixTypeState();
// }

// class _PrixTypeState extends State<PrixType> {
//   double selectedPrice = 250; //prix de la course.
//   final List<String> listType = ['Commun', "Depot", 'Covoiturage'];
//   String selectTedType = 'Commun';
//   final List<double> listPrice = [
//     300,
//     500,
//     750,
//     1000,
//     1500,
//     2000,
//     2500,
//     3000,
//     5000,
//     10000
//   ]; // liste des pris
//   TextEditingController controllerPrix = TextEditingController();
//   final List<double> couterlist = [300, 500, 750, 1000];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: SingleChildScrollView(
//             child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     child: Text(
//                       "Veillez indiquer le montant que vous souhaitez payer",
//                       style: police.copyWith(
//                         fontWeight: FontWeight.bold,
//                         // fontSize: 18,
//                         letterSpacing: 2,
//                         // wordSpacing: 2.5,
//                       ),
//                     ),
//                   ),
//                 ),
//                 TextFormField(
//                   controller: controllerPrix,
//                   keyboardType: TextInputType.number,
//                   style: police,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.grey.shade200,
//                     hintText: '250',
//                     icon: const FaIcon(
//                       Icons.attach_money,
//                       size: 30,
//                     ),
//                     suffix: Text('XFA',
//                         style: police.copyWith(
//                           fontSize: 16,
//                           letterSpacing: 0.3,
//                           fontWeight: FontWeight.w900,
//                           // color: Colors.grey,
//                         )),
//                     contentPadding:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: blanc),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                       borderSide: const BorderSide(color: Colors.grey),
//                     ),
//                     hintStyle: police,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 pricecheck(),
//                 SizedBox(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     child: Text(
//                       "Veillez choisir le type de transport",
//                       style: police.copyWith(
//                         fontWeight: FontWeight.bold,
//                         // fontSize: 18,
//                         letterSpacing: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 208,
//                   child: Center(
//                     child: choisType(listTypes: listType),
//                   ),
//                 ),
//                 spacerHeight(15),
//                 boutonText(
//                   context: context,
//                   action: () async {
//                     final Reservation reservation = Reservation(
//                       idReservation:
//                           DateTime.now().microsecondsSinceEpoch.toString(),
//                       idClient: "idClient",
//                       pointDepart: widget.adressestart,
//                       pointArrive: widget.adresseend,
//                       prixReservation: selectedPrice,
//                       dateReserVation: DateTime.now(),
//                       typeReservation: selectTedType,
//                     );
//                     Navigator.of(context).push(
//                       PageTransition(
//                         child: MapReservation(
//                           reservation: reservation,
//                           routeModel: widget.routeModel,
//                         ),
//                         type: PageTransitionType.rightToLeft,
//                       ),
//                     );
//                   },
//                   text: "Confirmer",
//                 )
//               ],
//             ),
//           ),
//         )),
//       ),
//     );
//   }

//   // bouton de selection des prix

//   Widget priceContainer(double prix) {
//     bool isprice = prix == selectedPrice;

//     return InkWell(
//       onTap: () {
//         setState(() {
//           selectedPrice = prix;
//           controllerPrix.text = prix.toString();
//           FocusScope.of(context).unfocus();
//         });
//       },
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: 115, minWidth: 100),
//         padding: const EdgeInsets.all(8),
//         // margin: const EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           color: isprice ? Colors.blue.shade100 : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             width: isprice ? 3 : 1,
//             color: isprice ? vert : Colors.blue.shade400,
//           ),
//         ),
//         child: Center(
//           child: Text('$prix XFA', style: police),
//         ),
//       ),
//     );
//   }

//   Widget pricecheck() {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: SizedBox(
//         width: double.infinity,
//         child: Wrap(
//           alignment: WrapAlignment.spaceAround,
//           runSpacing: 5,
//           children: listPrice.map((prix) => priceContainer(prix)).toList(),
//         ),
//       ),
//     );
//   }

//   // chois du type de voiture

//   Widget choisType({required List<String> listTypes}) {
//     return GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//           crossAxisCount: 2,
//         ),
//         itemCount: listTypes.length,
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () {
//               setState(() {
//                 selectTedType = listTypes[index];
//               });
//             },
//             child: Container(
//               // margin: const EdgeInsets.all(5),
//               height: 200,
//               width: 185,
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),

//               decoration: BoxDecoration(
//                 color: selectTedType == listTypes[index]
//                     ? Colors.blue.shade100
//                     : Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: const [
//                   BoxShadow(
//                       blurRadius: 0.5,
//                       spreadRadius: 0.5,
//                       offset: Offset(0.5, 0.5))
//                 ],
//                 border: Border.all(
//                     width: selectTedType == listTypes[index] ? 2 : 1,
//                     color:
//                         selectTedType == listTypes[index] ? vert : Colors.grey),
//               ),
//               child: Center(
//                 child: Text(
//                   listTypes[index],
//                   style: police,
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
