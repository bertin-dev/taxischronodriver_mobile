import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taxischronodriver/controllers/useapp_controller.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/autres/reservation.dart';
import 'package:taxischronodriver/modeles/autres/transaction.dart';
import 'package:taxischronodriver/modeles/autres/vehicule.dart';
import 'package:taxischronodriver/screens/auth/car_register.dart';
import 'package:taxischronodriver/screens/homepage.dart';
import 'package:taxischronodriver/services/transitionchauffeur.dart';
import 'package:taxischronodriver/varibles/variables.dart';

// import 'package:taxischrono/varibles/variables.dart';

class Chauffeur extends ApplicationUser {
  final String? numeroPermi;
  final DateTime? expirePermiDate;
  String? passeword;
  Chauffeur({
    required super.userAdresse,
    required super.userEmail,
    required super.userName,
    required super.userTelephone,
    required super.userCni,
    super.motDePasse,
    super.userDescription,
    super.userid,
    super.userProfile,
    required super.expireCniDate,
    required this.numeroPermi,
    this.passeword,
    required this.expirePermiDate,
  });

  //  lq vqriqble active permet de se rassurer que le compte du chauffeur est paye

  static DocumentReference<Map<String, dynamic>> chauffeurCollection(
          String userId) =>
      firestore.collection("Chauffeur").doc(userId);
  // les fonxtions de mapage du chauffeur

  Map<String, dynamic> toMap() => {
        if (userid != null) 'userid': userid,
        if (numeroPermi != null) "numeroPermi": numeroPermi,
        if (expirePermiDate != null)
          'expirePermiDate': Timestamp.fromDate(expirePermiDate!),
      };

  // function de validation OTP

  static Future validateOPT(Chauffeur chauffeurOtp, context,
      {required String smsCode, required String verificationId}) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await authentication.signInWithCredential(credential).then((value) async {
      if (value.user != null) {
        chauffeurOtp.userid = value.user!.uid;
        await value.user!.updateEmail(chauffeurOtp.userEmail);
        await value.user!.updateDisplayName(chauffeurOtp.userName);
        await value.user!.updatePassword(chauffeurOtp.passeword!);
        await chauffeurOtp.saveUser().then((value) {
          Get.find<ChauffeurController>().applicationUser.value = chauffeurOtp;
          Navigator.of(context).pushReplacement(PageTransition(
              child: TransitionChauffeurVehicule(
                applicationUser: chauffeurOtp,
              ),
              type: PageTransitionType.leftToRight));
        });
      } else {
        toaster(
            message: 'Erreur d\'inscription veillez reéssayer',
            color: Colors.red);
      }
    });
  }

  // function de reception de code et de demande de renvoie du nouveau code;

  static Future loginNumber(
    Chauffeur chauffeurOtp, {
    required BuildContext context,
    required Function(String verificationId, int? value1) onCodeSend,
  }) async {
    await authentication.verifyPhoneNumber(
      phoneNumber: chauffeurOtp.userTelephone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await authentication
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            chauffeurOtp.userid = value.user!.uid;
            await value.user!.updateEmail(chauffeurOtp.userEmail);
            await value.user!.updateDisplayName(chauffeurOtp.userName);
            await value.user!.updatePassword(chauffeurOtp.passeword!);
            await chauffeurOtp.saveUser().then((value) {
              Get.find<ChauffeurController>().applicationUser.value =
                  chauffeurOtp;
              Navigator.of(context).pushReplacement(
                PageTransition(
                  child: TransitionChauffeurVehicule(
                      applicationUser: chauffeurOtp),
                  type: PageTransitionType.leftToRight,
                ),
              );
            });
          } else {
            toaster(
                message: 'Erreur d\'inscription veillez reéssayer',
                color: Colors.red);
          }
        });
      },
      verificationFailed: (FirebaseAuthException except) {
        debugPrint(except.code);
        toaster(
            message:
                "Une Erreur est survenus l'ors de l'inscription Veillez reéssayer",
            long: true,
            color: Colors.red);
      },
      codeSent: onCodeSend,
      codeAutoRetrievalTimeout: (phone) {},
    );
  }

  factory Chauffeur.fromMap(
          {required Map<String, dynamic> userMap,
          required Map<String, dynamic> chauffeurMap}) =>
      Chauffeur(
        userAdresse: userMap['userAdresse'],
        userEmail: userMap['userEmail'],
        userName: userMap['userName'],
        userTelephone: userMap['userTelephone'],
        userCni: userMap["userCni"],
        userDescription: userMap['userDescription'],
        userProfile: userMap['userProfile'],
        userid: userMap['userid'],
        expireCniDate: (userMap['ExpireCniDate'] as Timestamp).toDate(),
        numeroPermi: chauffeurMap['numeroPermi'],
        expirePermiDate:
            (chauffeurMap['expirePermiDate'] as Timestamp).toDate(),
      );
  // la fonction d'acceptation de la commande

  static Future accepterLaCommande(Reservation reservation, chauffid) async {
    await Reservation.acceptByChauffeur(chauffid, reservation)
        .then((value) async {
      TransactionApp transaction = TransactionApp(
        idTansaction: DateTime.now().millisecondsSinceEpoch.toString(),
        idclient: reservation.idClient,
        dateAcceptation: DateTime.now(),
        idChauffer: chauffid!,
        idReservation: reservation.idReservation,
        etatTransaction: 0,
      );
      await transaction.valideTransaction();
    });
  }

// refuser la commande
  static Future refuserserunCommande(Reservation reservation, chauffid) async {
    await Reservation.rejectByChauffeur(chauffid, reservation)
        .then((value) => true);
  }

// Enrégistrement du chauffeur
  @override
  saveUser() async {
    super.saveUser();
    await chauffeurCollection(userid!).get().then((value) async {
      if (value.exists) {
        await chauffeurCollection(userid!).update(toMap());
      } else {
        await chauffeurCollection(userid!).set(toMap());
      }
    });
  }

// modifier le statut du chauffeur s'il a ou non payé l'abonemet
  static Future setStatut(String userId, bool statut) async {
    await chauffeurCollection(userId).set({"statut": statut});
  }

  // fonction vérifiant si le chauffeur est actif

  // @override
  Future loginChauffeur(String password) async {
    try {
      await authentication
          .createUserWithEmailAndPassword(email: userEmail, password: password)
          .then((value) async {
        await value.user!.updateDisplayName(userName);
        userid = value.user!.uid;
        saveUser();
      });
      return null;
    } on FirebaseException catch (excep) {
      return excep.code;
    }
  }

// fonction de récupération des infos du chauffeur
  static Future<Chauffeur> chauffeurInfos(idChauffeur) async {
    final userMap = await firestore
        .collection('Utilisateur')
        .doc(idChauffeur)
        .get()
        .then((user) {
      print(user.data());
      return user.data()!;
    });
    final chauffeurMap =
        await chauffeurCollection(idChauffeur).get().then((event) {
      print(event.data);
      return event.data()!;
    });
    return Chauffeur.fromMap(userMap: userMap, chauffeurMap: chauffeurMap);
  }

///////////////
  static Future<dynamic> havehicul(uid) async {
    await bd.collection("cars").doc(uid).get();
  }

// vérifier si l'utilisateur a un véhicule.
  static Future<Vehicule?> havehicule(userid) async {
    Vehicule? result;
    /* await datatbase.ref("Vehicules").child(userid).get().then((value) {
      if (value.exists) {
        debugPrint(Vehicule.froJson(value.value).toMap().toString());
        try {
          result = Vehicule.froJson(value.value);
        } catch (e) {
          debugPrint(e.toString());
          result = null;
        }
      } else {
        result = null;
      }
    });
    return result;*/

    bd.collection("cars").doc(userid).get().then((value) {
      if (value.exists) {
        const HomePage();

        debugPrint(Vehicule.froJson(value.data()).toMap().toString());
        try {
          result = Vehicule.froJson(value.data());
        } catch (e) {
          debugPrint(e.toString());
          result = null;
        }
      } else {
        result = null;
        const RequestCar();
      }
    });
    return result;
  }

  static Future<bool> havecar(userid) async {
    Vehicule? result;
    bd.collection("cars").doc(userid).get().then((value) {
      if (value.exists) {
        debugPrint(Vehicule.froJson(value.data()).toMap().toString());
        try {
          result = Vehicule.froJson(value.data());
        } catch (e) {
          debugPrint(e.toString());
          result = null;
        }
      } else {
        result = null;
      }
    });
    return result!.isActive;
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
      final providerData =
          FirebaseAuth.instance.currentUser?.providerData.first;

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

// fin de la classe
}

/*class Abonnement {
  DateTime? paiementdate;
  String idChauffeur;
  double montant;

  Abonnement(
      {required this.idChauffeur, required this.montant, this.paiementdate});
  Map<String, dynamic> toMap() => {
        if (paiementdate != null)
          'paiementdate': Timestamp.fromDate(paiementdate!),
        "montant": montant,
        'idChauffeur': idChauffeur,
      };
  factory Abonnement.fromMap(map) => Abonnement(
        idChauffeur: map['idChauffeur'],
        montant: map['montant'],
        paiementdate: (map['paiementdate'] as Timestamp).toDate(),
      );

  Future makePaiement() async {
    await firestore.collection("Abonnement").doc(idChauffeur).set(toMap());
    await firestore
        .collection("Chauffeur")
        .doc(idChauffeur)
        .update({"active": true});
  }

  static endAbonnement(idChauf) async {
    await firestore
        .collection("Abonnement")
        .doc(idChauf)
        .get()
        .then((value) async {
      if (value.exists) {
        final Abonnement abonnement = Abonnement.fromMap(value.data()!);
        if (abonnement.paiementdate!.compareTo(DateTime.now()) >= 0) {
          await firestore
              .collection("Chauffeur")
              .doc(idChauf)
              .update({"active": false});
        }
      }
    });
  }
}*/
