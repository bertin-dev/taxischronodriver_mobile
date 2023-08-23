import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart' as getx;
import 'package:shimmer/shimmer.dart';

// google signin variable;

final googleSignIn = GoogleSignIn();
final dredColor = Colors.amber.shade700;
final grey = Colors.grey[400];
// Color.fromARGB(248, 255, 233, 33);
// firebase variables

final authentication = FirebaseAuth.instance;
final datatbase = FirebaseDatabase.instance;
final firestore = FirebaseFirestore.instance;

final police = GoogleFonts.poppins(fontSize: 14);
// les variables pour l'OTP
var smsCode = "";
// const

// la snackbar des infos
getsnac(
        {required String title,
        required String msg,
        bool error = true,
        Widget? icons,
        Duration? duration}) =>
    getx.Get.snackbar(
      title,
      msg,
      titleText:
          Text(title, style: police.copyWith(fontWeight: FontWeight.w800)),
      messageText: Text(msg, style: police),
      icon: icons ??
          Icon(
            error ? Icons.error : Icons.check,
            color: error ? Colors.red : Colors.greenAccent,
            size: 30,
          ),
      backgroundColor: Colors.grey.shade200,
      duration: duration ?? const Duration(milliseconds: 3750),
      snackPosition: getx.SnackPosition.TOP,
      maxWidth: double.infinity,
      borderWidth: 1.5,
      borderColor: error ? Colors.red : Colors.greenAccent,
      borderRadius: 15,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      shouldIconPulse: true,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
// les type de bouton à utiliser dans l'application
Widget boutonText(
        {required BuildContext context,
        required void Function()? action,
        Color? couleur,
        required String text}) =>
    SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          backgroundColor: couleur ?? dredColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: police.copyWith(fontWeight: FontWeight.w600, color: noire),
        ),
      ),
    );

//  les champs d'entré unpeu commun
TextFormField champsdeRecherche(
        {required void Function(String value)? changement,
        required String hintext,
        void Function()? onTap,
        TextEditingController? controller,
        IconData? iconData}) =>
    TextFormField(
      onTap: onTap,
      controller: controller,
      style: police,
      onChanged: changement,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        hintText: hintext,
        hintStyle: police,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: blanc),
          borderRadius: BorderRadius.circular(15),
        ),
        icon: Icon(
          iconData ?? Icons.location_on_outlined,
          size: 30,
        ),
        fillColor: Colors.grey.shade200.withOpacity(0.7),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );

// la variable qui servira de hauteur dans l'Application
spacerHeight(double hauteur) => SizedBox(height: hauteur);
Color blanc = Colors.white;
Color vert = Colors.greenAccent;
Color noire = Colors.black;
const mapApiKey = "AIzaSyDRiuLYKs1ymgiW97p3ybAuQLOQcBDqUvg";
const younde = LatLng(3.866667, 11.516667);
const String idServiceClient = "taxisChronoInccCenter";

// les fonctions

Size taille(BuildContext context) => MediaQuery.of(context).size;

// adresse de la console google : https://console.cloud.google.com
Widget shimmer(htr, lgr) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      direction: ShimmerDirection.ltr,
      child: Container(
        height: htr,
        width: lgr,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white),
      ),
    );

// fonction retournant la distance en Kilomètre entre deux points
double calculateDistance(LatLng start, LatLng end) {
  var lat1 = start.latitude;
  var lon1 = start.longitude;
  var lat2 = end.latitude;
  var lon2 = end.longitude;
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

getPolilineLines(LatLng start, LatLng end, PolylinePoints polylinePoints,
    Map<PolylineId, Polyline> polylinesSets) async {
  // PolylineResult polylineResult =
  List<LatLng> polylineCoordinates = [];
  await polylinePoints
      .getRouteBetweenCoordinates(
    mapApiKey,
    PointLatLng(start.latitude, start.longitude),
    PointLatLng(end.latitude, end.longitude),
    travelMode: TravelMode.driving,
  )
      .then(
    (value) {
      if (value.points.isNotEmpty) {
        for (var element in value.points) {
          polylineCoordinates.add(LatLng(element.latitude, element.longitude));
        }
      } else {
        debugPrint(value.errorMessage);
      }

      addpolylinespoints(polylineCoordinates, polylinesSets);
    },
  );
}

addpolylinespoints(List<LatLng> listlatlng, polylinesSets) async {
  PolylineId id = const PolylineId("poly");
  Polyline polyline = Polyline(
    polylineId: id,
    points: listlatlng,
    color: Colors.blueAccent.shade200,
    width: 5,
  );
  polylinesSets[id] = polyline;
}

boobtomshet(
        {required GlobalKey<ScaffoldState> keys,
        required double hei,
        required Widget child}) =>
    keys.currentState!.showBottomSheet((context) {
      return Container(
        height: hei,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(child: child),
      );
    });

class LoadingComponen extends StatelessWidget {
  const LoadingComponen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitRipple(
        color: dredColor,
        size: 150,
        borderWidth: 5,
      ),
    );
  }
}

final header = {
  "Accept": "application/json",
  "Authorization": publickeyPaiment,
};

const publickeyPaiment = "b.S3PM3xdiXFRIT8l6";
const pathUrl = "https://api.notchpay.co/payments/initialize";
showload(context) {
  showDialog(
      context: context,
      builder: (context) {
        return const SimpleDialog(children: [
          LoadingComponen(),
        ]);
      });
}

toaster({required String message, Color? color, bool? long}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength:
            long != null && long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        backgroundColor: color ?? Colors.grey.shade900.withOpacity(0.8));
