import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxischronodriver/screens/delayed_animation.dart';
import 'package:taxischronodriver/varibles/variables.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        title: Text(authentication.currentUser!.displayName ?? "Auccun nom"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DelayedAnimation(
              delay: 1500,
              child: SizedBox(
                height: 280,
                child: Image.asset('images/illustration1.jpg'),
              ),
            ),
            DelayedAnimation(
              delay: 2500,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 30,
                ),
                child: Column(
                  children: [
                    Text(
                      "Le changement commence ici",
                      style: GoogleFonts.poppins(
                        color: dredColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Connecter vous et commencer a profiter de nos différents packages et disponibilités pour vos multiples déplacements",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DelayedAnimation(
              delay: 3500,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 40,
                ),
                child: Column(
                  children: const [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
