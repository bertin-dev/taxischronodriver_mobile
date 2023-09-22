import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taxischronodriver/modeles/autres/reservation.dart';
import 'package:taxischronodriver/modeles/autres/transaction.dart';
import 'package:taxischronodriver/modeles/discutions/conversation.dart';
import 'package:taxischronodriver/modeles/discutions/message.dart';
import 'package:taxischronodriver/screens/auth/register.dart';
import 'package:taxischronodriver/services/firebaseauthservice.dart';
import 'package:taxischronodriver/services/transitionchauffeur.dart';
import 'package:taxischronodriver/varibles/variables.dart';

import '../../controllers/useapp_controller.dart';
import 'chauffeur.dart';

class ApplicationUser {
  String? userid;
  final String userEmail;
  final String userName;
  final String? userTelephone;
  final String? userProfile;
  final String? motDePasse;
  final String? userAdresse;
  final String? userDescription;
  final String? userCni;
  final DateTime? expireCniDate;

  ApplicationUser({
    this.userAdresse,
    required this.userEmail,
    required this.userName,
    this.userTelephone,
    this.userCni,
    this.motDePasse,
    this.userDescription,
    this.userid,
    this.userProfile,
    this.expireCniDate,
  });

  factory ApplicationUser.fromJson(Map<String, dynamic> mapUser) =>
      ApplicationUser(
          userAdresse: mapUser['userAdresse'],
          userEmail: mapUser['userEmail'],
          userName: mapUser['userName'],
          userTelephone: mapUser['userTelephone'],
          userCni: mapUser['userCni'],
          userDescription: mapUser['userDescription'],
          userid: mapUser['userid'],
          userProfile: mapUser['userProfile'],
          expireCniDate: mapUser['expireCniDate']);

// factorisation des données
  Map<String, dynamic> toJson() => {
        if (userAdresse != null) 'userAdresse': userAdresse,
        if (userEmail != null) 'userEmail': userEmail,
        if (userName != null) 'userName': userName,
        if (userTelephone != null) 'userTelephone': userTelephone,
        if (userCni != null) 'userCni': userCni,
        if (userDescription != null) 'userDescription': userDescription,
        if (userid != null) 'userid': userid,
        if (userProfile != null) 'userProfile': userProfile,
        if (expireCniDate != null) 'ExpireCniDate': expireCniDate,
      };

//  Sauvegarde d'un utilisateur dans la base de donné.
  Future saveUser() async {
    final doc = await firestore.collection('Utilisateur').doc(userid!).get();
    if (doc.exists) {
      updateUser();
    } else {
      await firestore.collection('Utilisateur').doc(userid!).set(toJson());
    }
  }

// vérification de l'existance d'un utilisateur.
// la fonction seras utilsé avant l'authentification.
  static Future<bool> userExist(
      {String? userEmail, String? userPhonNumber}) async {
    var exist = false;
    await firestore.collection('Utilisateur').get().then((value) {
      value.docs.map((element) {
        ApplicationUser userapp = ApplicationUser.fromJson(element.data());

        if (userapp.userEmail == userEmail ||
            userapp.userTelephone == userPhonNumber) {
          exist = true;
        }
      }).toList();
    });
    return exist;
  }

// mettre à jour un utilisateur
  Future updateUser() async {
    await firestore.collection('Utilisateur').doc(userid!).update(toJson());
  }

// récupérer les information de l'utilisateur.
  static Stream<ApplicationUser> appUserInfos(idClient) => firestore
      .collection('Utilisateur')
      .doc(idClient)
      .snapshots()
      .map((user) => ApplicationUser.fromJson(user.data()!));
  static Future<ApplicationUser> infos(idClient) => firestore
      .collection('Utilisateur')
      .doc(idClient)
      .get()
      .then((value) => ApplicationUser.fromJson(value.data()!));

// Utilisateur courant dans l'application
  static Stream<ApplicationUser?>? currentUser() {
    try {
      return authentication.authStateChanges().map(
            (user) => user == null
                ? null
                : ApplicationUser(
                    userEmail: user.email!,
                    userName: user.displayName!,
                    userTelephone: user.phoneNumber,
                    userid: user.uid,
                  ),
          );
    } catch (e) {
      return null;
    }
  }

// future appUser
  static Future<ApplicationUser?> currentUserFuture() async {
    try {
      return firestore
          .collection('Utilisateur')
          .doc(authentication.currentUser!.uid)
          .get()
          .then((user) => ApplicationUser.fromJson(user.data()!));
    } catch (e) {
      return null;
    }
  }

// login whith email and password
  login() async {
    if (authentication.currentUser == null) {
      await Authservices().login(userEmail, motDePasse);
    }
  }

// fonction de tchat
  envoyerUnMessage(Message message) async {
    Conversation conversation = Conversation(lastMessage: message);
    await conversation.sendMessage();
  }

// permet d'envoyer un méssage d'urgence au service client.
  singalerUrgence({required String message}) {
    final Message msg = Message(
      senderUserId: userid!,
      destinationUserId: idServiceClient,
      libelle: message,
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'urgence',
      isRead: false,
    );
    Message reponse = Message(
      senderUserId: idServiceClient,
      destinationUserId: userid!,
      libelle:
          "Merci de bien vouloir nous signaler votre urgence S'il-vous-plait",
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'reponse',
      isRead: false,
    );
    envoyerUnMessage(msg);
    envoyerUnMessage(reponse);
  }

// fontion permettant d'envoyer un méssage au service client
  contacterLeServiceClient({required String message}) {
    final Message msg = Message(
      senderUserId: userid!,
      destinationUserId: idServiceClient,
      libelle: message,
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'contacter',
      isRead: false,
    );
    envoyerUnMessage(msg);
  }

// signaler le départ de la course
  static signalerDepart({required TransactionApp transaction}) {
    transaction.modifierEtat(2);
  }

// fonction permettant de signaler l'arrivé à destaination
  static signalerArriver({required TransactionApp transaction}) {
    transaction.modifierEtat(1);
  }

// fontion permettant d'annuler la rservation
  static annulerUneRservation(Reservation reservation) async {
    await reservation.annuletReservation();
  }

//  fonction per;ettqnt de noter le chquffeur
  static noterLechauffeur(
      {required TransactionApp transaction, required int note}) {
    transaction.noterChauffeur(note);
  }

//fonction d'enrégistrement des utilisateurs
  register() async {
    String error = "";
    if (authentication.currentUser == null) {
      Authservices().register(userEmail, motDePasse);
    }
    if (authentication.currentUser != null) {
      final user = authentication.currentUser!;
      await authentication.verifyPhoneNumber(
        timeout: const Duration(seconds: 90),
        phoneNumber: userTelephone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await user.updatePhoneNumber(credential).then((value) {
            saveUser();
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          error = exception.code;
          debugPrint(error);
        },
        codeSent: (String verificationId, int? resentokent) async {
          // notons que la variable smsCode sera modifier par lors de la connexion à
          //l'interface utilisateur

          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
          await authentication.currentUser!
              .updatePhoneNumber(credential)
              .then((value) {
            saveUser();
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    }
  }

  static Future authenticatePhonNumber(
      {required String phonNumber,
      required void Function(String, int?) onCodeSend,
      required void Function(PhoneAuthCredential) verificationCompleted,
      required void Function(FirebaseAuthException) verificationFailed,
      required GlobalKey<ScaffoldState> global}) async {
    var exist = await userExist(userPhonNumber: phonNumber);
    //print(exist);
    if (!exist) {
      FocusScope.of(global.currentContext!).unfocus();
      global.currentState!.showBottomSheet((context) {
        return Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Ce numéro n'as pas de compte",
                    style: police.copyWith(
                        fontSize: 18, fontWeight: FontWeight.w800)),
                spacerHeight(30),
                boutonText(
                    context: context,
                    action: () {
                      Navigator.of(context).push(
                        PageTransition(
                            child: const SignupPage(),
                            type: PageTransitionType.leftToRight),
                      );
                    },
                    text: "Creez votre compte"),
                spacerHeight(15),
                boutonText(
                    context: context,
                    action: () {
                      Navigator.of(context).pop();
                    },
                    text: "Annuler")
              ],
            ),
          ),
        );
      });
    } else {
      await authentication.verifyPhoneNumber(
        phoneNumber: phonNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: onCodeSend,
        codeAutoRetrievalTimeout: (time) {},
      );
    }
  }
// validation OTP pour l'hautentification

  static Future validateOPT(context,
      {required String smsCode, required String verificationId}) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await authentication.signInWithCredential(credential).then((value) async {
      if (value.user != null) {
        Navigator.of(context).pushReplacement(PageTransition(
            child: TransitionChauffeurVehicule(
              applicationUser: ApplicationUser(
                userEmail: value.user!.email!,
                userName: value.user!.displayName!,
                userid: value.user!.uid,
                userTelephone: value.user!.phoneNumber,
              ),
            ),
            type: PageTransitionType.leftToRight));
        Get.put<ChauffeurController>(ChauffeurController())
            .applicationUser
            .value = await Chauffeur.chauffeurInfos(value.user!.uid);
      }
    });
  }
// fin de la classe

}
