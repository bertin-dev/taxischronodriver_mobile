import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:page_transition/page_transition.dart';

import 'package:taxischronodriver/controllers/useapp_controller.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
import 'package:taxischronodriver/screens/auth/otppage.dart';
import 'package:taxischronodriver/services/transitionchauffeur.dart';
import 'package:taxischronodriver/varibles/variables.dart';

import '../delayed_animation.dart';

class LoginNumber extends StatefulWidget {
  const LoginNumber({super.key});

  @override
  State<LoginNumber> createState() => _LoginNumberState();
}

class _LoginNumberState extends State<LoginNumber> {
  bool loader = false;
  final globalkey = GlobalKey<ScaffoldState>();
  PhoneNumber? numberSubmited;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalkey,
      body: loader
          ? const LoadingComponen()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    spacerHeight(100),
                    DelayedAnimation(
                      delay: 1000,
                      child: Text(
                        "Vérification de votre numéro de téléphone",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    spacerHeight(180),
                    DelayedAnimation(
                      delay: 1500,
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (number) {
                          setState(() {
                            numberSubmited = number;
                          });
                        },
                        hintText: "Votre Numéro de téléphone",
                        textStyle: police,
                        validator: (val) {
                          return numberSubmited == null ||
                                  numberSubmited!.phoneNumber!.length < 13
                              ? "entrez un numéro de téléphone valide"
                              : null;
                        },
                        inputBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: grey!),
                        ),
                        maxLength: 13,
                        initialValue: PhoneNumber(isoCode: "CM"),
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                      ),
                    ),
                    spacerHeight(180),
                    DelayedAnimation(
                      delay: 2000,
                      child: boutonText(
                          context: context,
                          action: () async {
                            if (numberSubmited != null &&
                                numberSubmited!.phoneNumber!.trim().length ==
                                    13) {
                              loader = true;
                              setState(() {});
                              // print(loader);
                              await ApplicationUser.authenticatePhonNumber(
                                phonNumber: numberSubmited!.phoneNumber!,
                                onCodeSend: (verificationId, resendToken) {
                                  Navigator.of(context).push(PageTransition(
                                      child: OtpPage(
                                        isauthentication: true,
                                        phone: numberSubmited!.phoneNumber!,
                                        verificationId: verificationId,
                                      ),
                                      type: PageTransitionType.leftToRight));
                                },
                                verificationCompleted: (credential) async {
                                  final auth = await authentication
                                      .signInWithCredential(credential);
                                  await Chauffeur.chauffeurInfos(auth.user!.uid)
                                      .then((chauff) {
                                    Get.find<ChauffeurController>()
                                        .applicationUser
                                        .value = chauff;
                                    Navigator.of(context).pushReplacement(
                                      PageTransition(
                                          child: TransitionChauffeurVehicule(
                                              applicationUser: chauff),
                                          type: PageTransitionType.leftToRight),
                                    );
                                  });
                                },
                                verificationFailed: (except) {
                                  loader = false;
                                  setState(() {});
                                  debugPrint(except.code);

                                  toaster(
                                      message:
                                          "Erreur d'enrégistrement Veillez réssayer",
                                      color: Colors.red,
                                      long: true);
                                },
                                global: globalkey,
                              );

                              loader = false;
                              setState(() {});
                              // print(loader);
                            } else {
                              toaster(
                                  message:
                                      "entrer une numéro de téléphone valide",
                                  color: Colors.red);
                            }
                          },
                          text: "Valider"),
                    ),
                    spacerHeight(100),
                  ],
                ),
              ),
            ),
    );
  }
}
