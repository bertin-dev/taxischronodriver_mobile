import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:taxischronodriver/controllers/useapp_controller.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
import 'package:taxischronodriver/modeles/autres/vehicule.dart';
import 'package:taxischronodriver/screens/auth/car_register.dart';
import 'package:taxischronodriver/screens/component/sidebar.dart';
import 'package:taxischronodriver/screens/homepage.dart';
import 'package:taxischronodriver/services/mapservice.dart';
import 'package:taxischronodriver/varibles/variables.dart';

import '../controllers/vehiculecontroller.dart';

class TransitionChauffeurVehicule extends StatefulWidget {
  final ApplicationUser applicationUser;
  const TransitionChauffeurVehicule({super.key, required this.applicationUser});

  @override
  State<TransitionChauffeurVehicule> createState() =>
      _TransitionChauffeurVehiculeState();
}

class _TransitionChauffeurVehiculeState
    extends State<TransitionChauffeurVehicule> {
  bool haveVehicule = false;

  bool isEmailVerified = authentication.currentUser!.emailVerified;
  haveCar() async {
    setState(() {
      loafinTimerend = false;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      count++;
      // print(count);
      if (count == 30) {
        setState(() {
          loafinTimerend = true;
        });
        timer.cancel();
      }
      try {
        await bd
            .collection('cars')
            .doc(authentication.currentUser!.uid)
            .get()
            .then((event) async {
          // debugPrint('car : ${value!.toMap()}');
          if (event.exists) {
            haveVehicule = true;
            setState(() => haveVehicule = true);
            setState(() {
              loafinTimerend = false;
            });
            final comparaison =
                event['activeEndDate'].activeEndDate.compareTo(DateTime.now());
            if (comparaison < 0) {
              debugPrint('la date viens avant');
              try {
                await Vehicule.setActiveState(
                    false,
                    event['activeEndDate'].millisecondsSinceEpoch,
                    event['chauffeurId']);
              } catch (e) {
                debugPrint("Erreur de mise à jour de la date : $e");
              }
            } else {
              debugPrint('la date viens après');
            }
          } else {
            haveVehicule = false;
            setState(() {
              haveVehicule = false;
            });
            timer.cancel();
            debugPrint('don\'t have car');
          }
        });
      } catch (excep) {
        debugPrint("Error");
      }
    });
  }

  var loafinTimerend = false;
  var count = 0;
  Timer? timer;
  @override
  void initState() {
    haveCar();
    Get.put<VehiculeController>(VehiculeController());
    Get.put<ChauffeurController>(ChauffeurController());

    GooGleMapServices.requestLocation();

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return haveVehicule ? const HomePage() : const RequestCar();
  }

  sendVerificationEmail() async {
    if (authentication.currentUser != null) {
      try {
        await authentication.currentUser!.sendEmailVerification().then((value) {
          getsnac(
              title: "Vérification d'email",
              msg:
                  "Un mail de vérification a été envoyé à l'adresse ${authentication.currentUser!.email}");
        });
      } catch (e) {
        getsnac(msg: "$e", title: "Erreur d'envoie de mail de vérification");
      }
    }
  }

  checkVerificationEmail() async {
    await authentication.currentUser!.reload();
    setState(() {
      isEmailVerified = authentication.currentUser!.emailVerified;
    });
  }
}
/*class _TransitionChauffeurVehiculeState
    extends State<TransitionChauffeurVehicule> {
  bool? haveVehicule;
  bool isEmailVerified = authentication.currentUser!.emailVerified;

  Stream<QuerySnapshot> havehicules(BuildContext context) async* {
    final uid = await authentication.currentUser!.uid;
    yield* bd
        .collection('cars')
        .where('chauffeurId', isEqualTo: uid)
        .snapshots();
  }

  haveCar() async {
    setState(() {
      loafinTimerend = false;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      count++;
      // print(count);
      if (count == 30) {
        setState(() {
          loafinTimerend = true;
        });
        timer.cancel();
      }
      try {
        await Chauffeur.havehicule(authentication.currentUser!.uid)
            .then((value) async {
          debugPrint('car : ${value!.toMap()}');
          if (value != null) {
            setState(() {
              haveVehicule = true;
            });
            setState(() {
              loafinTimerend = false;
            });
            final comparaison = value.activeEndDate.compareTo(DateTime.now());
            if (comparaison < 0) {
              debugPrint('la date viens avant');
              try {
                await Vehicule.setActiveState(
                    false,
                    value.activeEndDate.millisecondsSinceEpoch,
                    value.chauffeurId);
              } catch (e) {
                debugPrint("Erreur de mise à jour de la date : $e");
              }
            } else {
              debugPrint('la date viens après');
            }
          } else {
            setState(() {
              haveVehicule = false;
            });
            timer.cancel();
            debugPrint('don\'t have car');
          }
        });
      } catch (excep) {
        debugPrint("Error");
      }
    });
  }

  var loafinTimerend = false;
  var count = 0;
  Timer? timer;
  @override
  void initState() {
    Get.put<VehiculeController>(VehiculeController());
    Get.put<ChauffeurController>(ChauffeurController());

    GooGleMapServices.requestLocation();

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //if (haveVehicule==false) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: havehicules(context),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.only(left: 120, top: 250),
                  child: Text(
                    'Something went wrong',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              // ignore: unnecessary_null_comparison
              if (snapshot.hasData) {
                return const HomePage();
              }
              if (snapshot.data == null) {
                return const RequestCar();
              }
              return SizedBox();
            }),
      ),
    );
  }

  sendVerificationEmail() async {
    if (authentication.currentUser != null) {
      try {
        await authentication.currentUser!.sendEmailVerification().then((value) {
          getsnac(
              title: "Vérification d'email",
              msg:
                  "Un mail de vérification a été envoyé à l'adresse ${authentication.currentUser!.email}");
        });
      } catch (e) {
        getsnac(msg: "$e", title: "Erreur d'envoie de mail de vérification");
      }
    }
  }

  checkVerificationEmail() async {
    await authentication.currentUser!.reload();
    setState(() {
      isEmailVerified = authentication.currentUser!.emailVerified;
    });
  }
}*/

/*class userListvehiculeCard extends StatefulWidget {
  userListvehiculeCard({Key? key, required this.vehicule}) : super(key: key);
  final Vehicule vehicule;

  @override
  State<userListvehiculeCard> createState() => _userListvehiculeCardState();
}

class _userListvehiculeCardState extends State<userListvehiculeCard> {
  

  @override
  Widget build(BuildContext context) {
 
    return Text(widget.vehicule.assurance);
  }
}*/
