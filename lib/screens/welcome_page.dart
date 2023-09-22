import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxischronodriver/screens/delayed_animation.dart';
import 'package:taxischronodriver/screens/social_page.dart';
import 'package:taxischronodriver/varibles/variables.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 60,
            horizontal: 30,
          ),
          child: Column(
            children: [
              DelayedAnimation(
                delay: 1500,
                child: Image.asset('images/illustration2.jpg'),
              ),
              DelayedAnimation(
                delay: 2500,
                child: Image.asset('images/illustration4.JPG'),

//                 child: SizedBox(
//                   height: 170,
//                   child: Image.asset('images/illustration2.jpg'),
//                 ),
//               ),
//               DelayedAnimation(
//                 delay: 2500,
//                 child: SizedBox(
//                   height: 400,
//                   child: Image.asset('images/illustration4.jpg'),
//                 ),
// >>>>>>>> 7fdfec98e39a073132af52bc7fcabe7cd7d9aafd:lib/screens/welcome_page.dart
              ),
              DelayedAnimation(
                delay: 3500,
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                    bottom: 20,
                  ),
                  child: Text(
                    "Soyez plus en securiter, plus rassurer et confortablement conduit en tous lieux et a tous moment",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              DelayedAnimation(
                delay: 4500,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: dredColor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.all(13)),
                    child: const Text('COMMENCER'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SocialPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
