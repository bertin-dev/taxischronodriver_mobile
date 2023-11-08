import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/autres/vehicule.dart';
import 'package:taxischronodriver/screens/delayed_animation.dart';
import 'package:taxischronodriver/screens/homepage.dart';
import 'package:taxischronodriver/services/mapservice.dart';
import 'package:taxischronodriver/services/transitionchauffeur.dart';
import 'package:taxischronodriver/varibles/variables.dart';

class RequestCar extends StatefulWidget {
  const RequestCar({super.key});

  @override
  State<RequestCar> createState() => _RequestCarState();
}
class _RequestCarState extends State<RequestCar> {
  //TextEditingController controllerChassie = TextEditingController();
  TextEditingController controllerassurance = TextEditingController();
  TextEditingController controllerimat = TextEditingController();
  //TextEditingController controllermodele = TextEditingController();
  TextEditingController controllerCouleur = TextEditingController();
  TextEditingController controllerCapacity = TextEditingController();
  TextEditingController controllerGreyCard = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool loder = false;
  //  le debu du corps
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.close,
        //     color: Colors.black,
        //     size: 30,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: loder
          ? const LoadingComponen()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DelayedAnimation(
                            delay: 1500,
                            child: Text(
                              "Formulaire d'enregistrement du véhicule",
                              style: GoogleFonts.poppins(
                                color: dredColor,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          DelayedAnimation(
                            delay: 2500,
                            child: Text(
                              "Pensez à bien verifier les informations saisis afin de faciliter la validation de votre vehicule.",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),
                    signupForm(),
                    const SizedBox(height: 35),
                    SizedBox(
                      width: double.infinity,
                      child: DelayedAnimation(
                        delay: 5500,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 1,
                              shape: const StadiumBorder(),
                              backgroundColor: dredColor,
                              padding: const EdgeInsets.symmetric(
                                // horizontal: 125,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              'ENREGISTRER',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 4),
                            ),
                            onPressed: () async =>
                                await valideRequest(loder).then(
                              (value) => Navigator.of(context).pushReplacement(
                                PageTransition(
                                    child: const HomePage(),
                                    type: PageTransitionType.leftToRight),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    spacerHeight(15),
                  ],
                ),
              ),
            ),
    );
  }

  Future valideRequest(bool loader) async {
    // if (formkey.currentState!.validate()) {
    setState(() {
      loader = true;
    });
    Vehicule vehicule = Vehicule(
        assurance: controllerassurance.text,
        expirationAssurance: expireassurance,
        isActive: false,
        activeEndDate: DateTime.now(),
        imatriculation: controllerimat.text,
        greyCard: controllerGreyCard.text,
        capacity: controllerCapacity.text,
        chauffeurId: authentication.currentUser!.uid,
        statut: false,
        position: GooGleMapServices.currentPosition,
        token: " ");
    await vehicule.requestSave().then((value) async {
      if (value == true) {
        await ApplicationUser.infos(authentication.currentUser!.uid)
            .then((value) {
          Navigator.of(context).pushReplacement(
            PageTransition(
              child: TransitionChauffeurVehicule(
                applicationUser: value,
              ),
              type: PageTransitionType.leftToRight,
            ),
          );
        });
        setState(() {
          loader = false;
        });
      } else if (value == "véhicule déja existant ce véhicule existe déjà") {
        setState(() {
          loader = false;
        });
        getsnac(title: "Erreur d'enrégistrement ", msg: "$value");
      }
    });
    // } else {
    //   print("error ");
    // }
  }

// formulaire d'inscripttions
  Widget signupForm() {
    return Form(
      key: formkey,
      child: Column(
        children: [
          // le numéro de chassie
          // DelayedAnimation(
          //   delay: 3500,
          //   child: TextFormField(
          //     controller: controllerChassie,
          //     validator: (value) {
          //       return value != null || (value!.trim().isNotEmpty)
          //           ? value.length < 4
          //               ? "entrer un numéro de chassie valide"
          //               : null
          //           : 'veillez entrer un numéro de chassie';
          //     },
          //     style: police,
          //     decoration: InputDecoration(
          //       icon: const Icon(Icons.car_rental),
          //       hintStyle: police,
          //       labelText: 'Numero De Chassi',
          //       labelStyle: TextStyle(
          //         color: grey,
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10),

          // le modèle du véhicule
          /*DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              controller: controllermodele,
              validator: (value) {
                return value != null || (value!.trim().isNotEmpty)
                    ? value.length < 2
                        ? "un modèle valide"
                        : null
                    : 'veillez entrer le modèle de votre véhicule';
              },
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.local_taxi_outlined),
                hintStyle: police,
                // labelText: 'Model De Vehicule',
                labelText: 'Marque Du Vehicule',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),*/

          // la plaque d'imatricularion
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              controller: controllerimat,
              validator: (value) {
                return value != null || (value!.trim().isNotEmpty)
                    ? value.length < 4
                        ? "entrer une immatriculation valide valide"
                        : null
                    : 'veillez entrer une immatriculation';
              },
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.card_travel),
                hintStyle: police,
                labelText: 'Votre Numero de Plaque Immatriculation',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          //capacité
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              controller: controllerCapacity,
              validator: (value) {
                return value != null || (value!.trim().isNotEmpty)
                    ? value.length < 2
                    ? "une capacité valide"
                    : null
                    : 'veillez entrer la capacité de votre véhicule';
              },
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.local_taxi_outlined),
                hintStyle: police,
                // labelText: 'Model De Vehicule',
                labelText: 'Capacité du Vehicule',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          //Carte grise
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              controller: controllerGreyCard,
              validator: (value) {
                return value != null || (value!.trim().isNotEmpty)
                    ? value.length < 2
                    ? "une carte grise valide valide"
                    : null
                    : 'veillez entrer la carte grise de votre véhicule';
              },
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.local_taxi_outlined),
                hintStyle: police,
                // labelText: 'Model De Vehicule',
                labelText: 'Carte grise du Vehicule',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // numéro d'assurance
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              controller: controllerassurance,
              validator: (value) {
                return value != null || (value!.trim().isNotEmpty)
                    ? value.length < 4
                        ? "entrer un numéro d'assurance valide"
                        : null
                    : 'veillez entrer un numéro d\'assurance';
              },
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.assured_workload),
                hintStyle: police,
                labelText: 'Votre Numero Assurance',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // date d'expiration de l'assurance
          // DelayedAnimation(
          //   delay: 3500,
          //   child: TextFormField(
          //     style: police,
          //     controller: controllerExpirAssurance,
          //     validator: (val) {
          //       return val == null || expireassurance == null
          //           ? "entrezla date d'expiration du permis"
          //           : null;
          //     },
          //     onTap: () async {
          //       await showDatePicker(
          //         context: context,
          //         initialDate: DateTime.now(),
          //         firstDate: DateTime.now(),
          //         lastDate: DateTime.now().add(
          //           const Duration(days: 365 * 5),
          //         ),
          //       ).then((value) {
          //         if (value == null) return;
          //         setState(() {
          //           expireassurance = value;
          //           controllerExpirAssurance.text =
          //               DateFormat("EEE d MM y").format(expireassurance!);
          //         });
          //         FocusScope.of(context).unfocus();
          //       });
          //     },
          //     decoration: InputDecoration(
          //       icon: const Icon(Icons.date_range),
          //       hintStyle: police,
          //       labelText: 'La date d\'expiration du permi.',
          //       labelStyle: TextStyle(
          //         color: grey,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10),
          // couleur du véhicule
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              controller: controllerCouleur,
              validator: (value) {
                return value != null || (value!.trim().isNotEmpty)
                    ? value.length < 3
                        ? "entrer une couleur valide"
                        : null
                    : 'veillez entrer un numéro de chassie';
              },
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.color_lens),
                hintStyle: police,
                labelText: 'Couleur du Vehicule',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? expireassurance;
  TextEditingController controllerExpirAssurance = TextEditingController();
}
