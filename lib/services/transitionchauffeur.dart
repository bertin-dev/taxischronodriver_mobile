import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:taxischronodriver/controllers/useapp_controller.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
import 'package:taxischronodriver/modeles/autres/vehicule.dart';
import 'package:taxischronodriver/screens/auth/car_register.dart';
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
  bool? haveVehicule;
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
        await Chauffeur.havehicule(authentication.currentUser!.uid)
            .then((value) async {
          debugPrint('car : ${value!.toMap()}');
          if (value != null) {
            setState(() => haveVehicule = true);
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
    if (haveVehicule == null) {
      return Scaffold(
        body: !loafinTimerend
            ? const LoadingComponen()
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Erreur de connexion internet ...",
                          style: police,
                        ),
                      ),
                    ),
                    spacerHeight(50),
                    boutonText(
                        context: context,
                        action: () {
                          haveCar();
                        },
                        text: 'Rechargé')
                  ],
                ),
              ),
      );
    } else {
      return haveVehicule == true ? const HomePage() : const RequestCar();
    }
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
