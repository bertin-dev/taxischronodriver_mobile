// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:taxischronodriver/screens/delayed_animation.dart';
import 'package:taxischronodriver/screens/auth/register.dart';
import 'package:taxischronodriver/services/firebaseauthservice.dart';

import '../../varibles/variables.dart';
import 'login_number.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerEmail = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loader = false;
  TextEditingController controllerPasswor = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white.withOpacity(0),
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.close,
      //       color: Colors.black,
      //       size: 30,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),

      body: SafeArea(
        child: loader
            ? const LoadingComponen()
            : SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DelayedAnimation(
                              delay: 1500,
                              child: Text(
                                "Connecter l'adresse e-mail",
                                style: GoogleFonts.poppins(
                                  color: Colors.amber.shade900,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            DelayedAnimation(
                              delay: 2000,
                              child: Text(
                                "Il est recommandé de vous connecter avec votre adresse e-mail pour mieux protéger vos informations.",
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
                      spacerHeight(30),
                      loginForm(),
                      spacerHeight(30),
                      DelayedAnimation(
                        delay: 2500,
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
                              'CONFIRMER',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 4),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  loader = true;
                                });
                                await Authservices()
                                    .login(controllerEmail.text,
                                        controllerPasswor.text)
                                    .then((login) {
                                  setState(() {
                                    loader = false;
                                  });
                                  switch (login) {
                                    case null:
                                      // Navigator.of(context).pop();
                                      setState(() {});
                                      break;
                                    case "network-request-failed":
                                      getsnac(
                                        title: "Erreur de connexion",
                                        msg:
                                            'Erreur de connexion internet veillez vérifier votre connexion internet puis reéssayer',
                                      );
                                      break;
                                    case 'user-not-found':
                                      getsnac(
                                        title: "Erreur de connexion",
                                        msg:
                                            'Aucun utilisateur avec cet email n\'a été trouvé',
                                      );
                                      break;
                                    case "wrong-password":
                                      getsnac(
                                        title: "Erreur de connexion",
                                        msg: 'Email ou mot de passe incorect',
                                      );
                                      break;
                                    default:
                                      getsnac(
                                        title: "Erreur de connexion : $login",
                                        msg: 'Veillez reéssayer',
                                      );
                                  }
                                });
                              } else {}
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // DelayedAnimation(
                      //   delay: 3000,
                      //   child: ElevatedButton(
                      //     onPressed: () async {
                      //       await Authservices().singInAppl().then((value) {
                      //         if (value ==
                      //             'l\'authentification avec apple n\'est pas disponible sur votre mobile') {
                      //           getsnac(
                      //               title: "Erreur d'hautentification",
                      //               msg:
                      //                   "Modele de connexion Apple non disponible pour votre appareil");
                      //         }
                      //         switch (value) {
                      //           case null:
                      //             Navigator.of(context).pop();
                      //             break;
                      //           case "pas d'authorisation":
                      //             getsnac(
                      //                 title: "Erreur d'hautentification",
                      //                 msg:
                      //                     "Véillez autoriser l'authentification par email");
                      //             break;
                      //         }
                      //       });
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       shape: const StadiumBorder(),
                      //       backgroundColor: dredColor, //const Color(0xFF576dff),
                      //       padding: const EdgeInsets.all(13),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         const Icon(Icons.apple,
                      //             color: Colors.black),
                      //         const SizedBox(width: 10),
                      //         Text(
                      //           'Apple',
                      //           style: GoogleFonts.poppins(
                      //             color: Colors.black,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 15),
                      DelayedAnimation(
                        delay: 2500,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(PageTransition(
                                child: const LoginNumber(),
                                type: PageTransitionType.leftToRight));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: dredColor,
                            padding: const EdgeInsets.all(13),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.phone, color: Colors.black),
                              const SizedBox(width: 10),
                              Text(
                                'Numéro de téléphone',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spacerHeight(15),
                      DelayedAnimation(
                        delay: 2550,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: dredColor,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              'Pas de compte? Creer le votre ici',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {
                      //       Navigator.pop(context);
                      //     },
                      //     child: DelayedAnimation(
                      //       delay: 2450,
                      //       child: Text(
                      //         "SAUTER",
                      //         style: GoogleFonts.poppins(
                      //           color: Colors.black,
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  var _obscureText = true;
  Widget loginForm() => Form(
        key: formKey,
        child: Column(
          children: [
            DelayedAnimation(
              delay: 2750,
              child: TextFormField(
                controller: controllerEmail,
                decoration: InputDecoration(
                  icon: const Icon(Icons.email),
                  labelText: 'Votre e-mail',
                  labelStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            DelayedAnimation(
              delay: 4500,
              child: TextFormField(
                controller: controllerPasswor,
                validator: (value) {
                  return (value != null || value!.length < 8)
                      ? null
                      : "mot de passe invalide";
                },
                obscureText: _obscureText,
                decoration: InputDecoration(
                  icon: const Icon(Icons.security),
                  labelStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  labelText: 'Mot de passe',
                  suffix: IconButton(
                    icon: const Icon(
                      Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
