import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taxischronodriver/screens/auth/login_page.dart';
import 'package:taxischronodriver/screens/component/codepromo.dart';
// import 'package:taxischronodriver/screens/homepage.dart';
import 'package:taxischronodriver/screens/mesrequettes.dart';
// import 'package:taxischronodriver/screens/paquage.dart';
import 'package:taxischronodriver/screens/auth/profilepage.dart';
import 'package:taxischronodriver/services/firebaseauthservice.dart';
import 'package:taxischronodriver/varibles/variables.dart';
import 'package:url_launcher/url_launcher.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool isConnected = authentication.currentUser != null;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
              right: Radius.circular(30), left: Radius.circular(8))),
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: isConnected
                ? Text(
                    authentication.currentUser!.displayName!,
                    style: police.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Text("Veillez vous connecter",
                    style: police.copyWith(fontWeight: FontWeight.bold)),
            accountEmail:
                !isConnected ? null : Text(authentication.currentUser!.email!),

            currentAccountPicture: CircleAvatar(
              radius: 70,
              child: ClipOval(
                child: checkUrl(
                  'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                ),
                /* CachedNetworkImage(
                  imageUrl:
                      'https://png.pngtree.com/png-clipart/20190924/original/pngtree-business-people-avatar-icon-user-profile-free-vector-png-image_4815126.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 90,
                ),*/
              ),
            ),
            // decoration: const BoxDecoration(
            //   color: Colors.blue,
            //   image: DecorationImage(
            //       fit: BoxFit.fill,
            //       image: NetworkImage(
            //           'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png')),
            // ),
          ),
          isConnected
              ? ListTile(
                  leading: const Icon(Icons.person_pin),
                  title: Text('Mon compte', style: police),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      PageTransition(
                        child: const ProfileScreen(),
                        type: PageTransitionType.leftToRight,
                      ),
                    );
                  },
                )
              : const SizedBox.shrink(),
          !isConnected
              ? ListTile(
                  leading: const Icon(Icons.person_pin),
                  title: Text('Connextion', style: police),
                  onTap: () {
                    Navigator.of(context).push(PageTransition(
                      child: const LoginPage(),
                      type: PageTransitionType.fade,
                    ));
                  },
                )
              : const SizedBox.shrink(),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text('Mes Courses', style: police),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  PageTransition(
                      child: const MesRequettes(),
                      type: PageTransitionType.leftToRight));
            },
          ),
          const Divider(),
          ListTile(
              title: Text('Contacter nous', style: police),
              leading: const Icon(Icons.call),
              // ignore: avoid_returning_null_for_void
              onTap: () async {
                await FlutterPhoneDirectCaller.callNumber("+237658549711");
              }),
          // ListTile(
          //   leading: const Icon(Icons.panorama_fish_eye_rounded),
          //   title: Text('Statistiques', style: police),
          //   onTap: () {
          //     if (isConnected) {
          //       Navigator.of(context).push(PageTransition(
          //           child: const PackageUi(), type: PageTransitionType.fade));
          //     } else {
          //       getsnac(
          //           title: "Connexion",
          //           icons: Icon(Icons.info_outline, color: dredColor),
          //           msg:
          //               "Veillez vous connecter avant de souscrire à un package");
          //       connexion();
          //     }
          //   },
          // ),

          ListTile(
              leading: const Icon(Icons.description),
              title: Text('A propos de Taxis chrono', style: police),
              onTap: () async {
                launchUrl(Uri.parse("https://www.taxi-chrono.net"));
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: Text('Utiliser un code Promo', style: police),
              // ignore: avoid_returning_null_for_void
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(PageTransition(
                    child: const CodePromocomponent(),
                    type: PageTransitionType.leftToRight));
              }),
          isConnected
              ? ListTile(
                  title: Text('Déconexion', style: police),
                  leading: const Icon(Icons.exit_to_app),
                  // ignore: avoid_returning_null_for_void
                  onTap: () async => isConnected
                      ? Authservices().logOut().then((value) {
                          Navigator.of(context).pop();
                          setState(() {});
                        })
                      : getsnac(
                          title: "DÉCONNEXION", msg: "Aucun compte connecté"),
                )
              : const SizedBox.shrink(),

          ListTile(
              title: Text('Supprimer mon compte', style: police),
              leading: const Icon(Icons.delete_forever),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Supprimer votre compte?'),
                      content: const Text(
                          '''Si vous sélectionnez Supprimer, nous supprimerons votre compte sur notre serveur. 

Les données de votre application seront également supprimées et vous ne pourrez pas les récupérer.'''),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                          onPressed: () async {
                            bool step1 = true;
                            bool step2 = false;
                            bool step3 = false;
                            bool step4 = false;
                            while (true) {
                              if (step1) {
                                ///ajouter ce matin 5/9/2023
                                Navigator.of(context).pop();
                                //delete user info in the database
                                getsnac(
                                    title: "suppression du compte",
                                    msg: "suppression en cours");
                                Duration(seconds: 9);
                                var delete = await bd
                                    .collection('Utilisateur')
                                    .doc(authentication.currentUser!.uid)
                                    .delete();
                                await bd
                                    .collection('cars')
                                    .doc(authentication.currentUser!.uid)
                                    .delete();
                                await bd
                                    .collection('Chauffeur')
                                    .doc(authentication.currentUser!.uid)
                                    .delete();
                                step1 = false;
                                step2 = true;
                              }

                              if (step2) {
                                //delete user
                                await FirebaseAuth.instance.currentUser!
                                    .delete();
                                // deleteUserAccount();
                                step2 = false;
                                step3 = true;
                              }

                              if (step3) {
                                await FirebaseAuth.instance.signOut();
                                step3 = false;
                                step4 = true;
                              }

                              if (step4) {
                                //go to sign up log in page
                                // await Navigator.pushNamed(context, '/');
                                connexion();
                                step4 = false;

                                ///ajouter ce matin 5/9/2023

                                getsnac(
                                    title: "suppression du compte",
                                    msg: "compte supprimer avec succés");
                              }

                              if (!step1 && !step2 && !step3 && !step4) {
                                break;
                              }
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              })
        ],
      ),
    );
  }

  // fontion de navigation vers la page d'authentification
  connexion() => Navigator.of(context).push(PageTransition(
        child: const LoginPage(),
        type: PageTransitionType.fade,
      ));
}

Widget checkUrl(String url) {
  try {
    return Image.network(url,
        height: 90, width: double.infinity, fit: BoxFit.cover);
  } catch (e) {
    return Icon(Icons.image);
  }
}

Future<void> deleteUserAccount() async {
  try {
    await FirebaseAuth.instance.currentUser!.delete();
  } on FirebaseAuthException catch (e) {
    //log.e(e);

    if (e.code == "requires-recent-login") {
      await _reauthenticateAndDelete();
    } else {
      // Handle other Firebase exceptions
    }
  } catch (e) {
    //log.e(e);

    // Handle general exception
  }
}

Future<void> _reauthenticateAndDelete() async {
  try {
    final providerData = FirebaseAuth.instance.currentUser?.providerData.first;

    if (AppleAuthProvider().providerId == providerData!.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(AppleAuthProvider());
    } else if (GoogleAuthProvider().providerId == providerData.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(GoogleAuthProvider());
    }

    await FirebaseAuth.instance.currentUser?.delete();
  } catch (e) {
    // Handle exceptions
  }
}
