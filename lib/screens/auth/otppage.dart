import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
import 'package:taxischronodriver/screens/delayed_animation.dart';

import '../../varibles/variables.dart';

class OtpPage extends StatefulWidget {
  final Chauffeur? chauffeur;
  final String verificationId;
  final String? phone;
  final bool isauthentication;
  const OtpPage(
      {super.key,
      this.chauffeur,
      this.phone,
      required this.verificationId,
      required this.isauthentication});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  bool loading = false;
  String smsCode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close, color: dredColor, size: 27),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DelayedAnimation(
                  delay: 1500,
                  child: Text(
                    "Vérification du numéro de téléphone",
                    style: GoogleFonts.poppins(
                      color: dredColor,
                      letterSpacing: 3,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                spacerHeight(30),
                DelayedAnimation(
                  delay: 2000,
                  child: Text(
                    "Un code a été envoyé au numéro",
                    style:
                        police.copyWith(fontWeight: FontWeight.bold, height: 2),
                    textAlign: TextAlign.center,
                  ),
                ),
                spacerHeight(5),
                DelayedAnimation(
                  delay: 2000,
                  child: Text(
                    widget.chauffeur != null
                        ? "${widget.chauffeur!.userTelephone}"
                        : "${widget.phone}",
                    style: police.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                spacerHeight(50),
                DelayedAnimation(
                  delay: 2500,
                  child: Pinput(
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme(),
                    submittedPinTheme: submitpinTheme(),
                    onChanged: (val) {
                      setState(() {
                        smsCode = val;
                      });
                    },
                    length: 6,
                    onCompleted: (val) {
                      setState(() {
                        smsCode = val;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 120),
                DelayedAnimation(
                    delay: 3000,
                    child: loading
                        ? const SizedBox(
                            height: 70,
                            width: double.infinity,
                            child: Center(
                              child: LoadingComponen(),
                            ),
                          )
                        : boutonText(
                            context: context,
                            action: () {
                              if (loading) {
                                Fluttertoast.showToast(
                                    msg: "Chargement en cours",
                                    toastLength: Toast.LENGTH_SHORT);
                              } else {
                                if (smsCode.length == 6) {
                                  loading = true;
                                  setState(() {});
                                  if (widget.isauthentication) {
                                    ApplicationUser.validateOPT(context,
                                        smsCode: smsCode,
                                        verificationId: widget.verificationId);
                                  } else {
                                    Chauffeur chauffeur = widget.chauffeur!;
                                    Chauffeur.validateOPT(
                                      chauffeur,
                                      context,
                                      smsCode: smsCode,
                                      verificationId: widget.verificationId,
                                    );
                                  }
                                  loading = false;
                                  setState(() {});
                                  // Navigator.of(context).pop();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Remplissez correctement le code",
                                      toastLength: Toast.LENGTH_LONG,
                                      backgroundColor: Colors.red,
                                      fontSize: 16);
                                }
                              }
                            },
                            text: 'Valider'.toUpperCase())),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: police,
      decoration: BoxDecoration(
          border: Border.all(color: dredColor),
          borderRadius: BorderRadius.circular(40)));
  PinTheme focusedPinTheme() => defaultPinTheme.copyDecorationWith(
        border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
        borderRadius: BorderRadius.circular(12),
      );
  PinTheme submitpinTheme() => defaultPinTheme.copyDecorationWith(
        border: Border.all(color: const Color.fromARGB(49, 114, 178, 238)),
        borderRadius: BorderRadius.circular(12),
      );
}
