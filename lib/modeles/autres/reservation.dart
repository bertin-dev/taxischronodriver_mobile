// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fst;
import 'package:taxischronodriver/modeles/autres/transaction.dart';
import 'package:taxischronodriver/services/mapservice.dart';

import '../../varibles/variables.dart';

class Reservation {
  final String idReservation;
  String idClient;
  Adresse pointDepart;
  Adresse pointArrive;
  Adresse? positionClient;
  double prixReservation;
  int etatReservation;
  DateTime dateReserVation;
  String typeReservation;

  Reservation({
    required this.idReservation,
    required this.idClient,
    required this.pointDepart,
    this.positionClient,
    required this.pointArrive,
    required this.prixReservation,
    required this.dateReserVation,
    required this.typeReservation,
    this.etatReservation = 0,
  });

// Collection

  fst.DocumentReference collection() =>
      firestore.collection("Reservation").doc(idReservation);

// Json
  Map<String, dynamic> tomap() => {
        'idReservation': idReservation,
        "pointDepart": pointDepart.toMap(),
        "pointArrive": pointArrive.toMap(),
        "positionClient":
            positionClient != null ? positionClient!.toMap() : null,
        "prixReservation": prixReservation,
        "typeRservation": typeReservation,
        "dateReservation": fst.Timestamp.fromDate(dateReserVation),
        "etatReservation": etatReservation,
        "idClient": idClient
      };

  factory Reservation.fromJson(Map<String, dynamic> reservation) => Reservation(
        idReservation: reservation["idReservation"],
        pointDepart: Adresse.fromMap(reservation["pointDepart"]),
        positionClient: reservation["positionClient"] != null
            ? Adresse.fromMap(reservation["positionClient"])
            : null,
        pointArrive: Adresse.fromMap(reservation["pointArrive"]),
        prixReservation: reservation["prixReservation"],
        dateReserVation:
            (reservation["dateReservation"] as fst.Timestamp).toDate(),
        typeReservation: reservation["typeRservation"],
        idClient: reservation['idClient'],
        etatReservation: reservation['etatReservation'],
      );

  // validation de la réservation
  valideRservation() async {
    collection().set(tomap());
  }

// changer l'atat d'une réservations.
  updateAcceptedState(int accept) async {
    await collection().update({"etatReservation": accept});
  }

// anuller une réservation
  Future annuletReservation() async {
    updateAcceptedState(-1);
    TransactionApp.allTransaction(authentication.currentUser!.uid)
        .listen((event) async {
      for (var element in event) {
        if (element.idReservation == idReservation) {
          await element.modifierEtat(-1);
        }
      }
    });
  }

// les reservations d'un chauffeurs en course.

  static Stream<List<Reservation>> listReservationChauffeur(idchauffeur) =>
      firestore
          .collection("Courses")
          .doc(idchauffeur)
          .collection("Request")
          .orderBy("dateReservation")
          .snapshots()
          .map((event) => event.docs
              .map((resevation) => Reservation.fromJson(resevation.data()))
              .toList());

  // fontion d'émission de la requette à un chauffeur particulier;
  static sendToChauffeur(idchauffeur, Reservation reservation) async {
    await firestore
        .collection('Courses')
        .doc(idchauffeur)
        .collection("Request")
        .doc(reservation.idReservation)
        .set(reservation.tomap());
  }

  //  la reservation en stream

  static Stream<Reservation> reservationStream(idRserVation) => firestore
      .collection("Reservation")
      .doc(idRserVation)
      .snapshots()
      .map((event) => Reservation.fromJson(event.data()!));
  // fonction de réfus d'une reservation par un chaufeur.
  static Future<Map<String, bool>?> rejectByChauffeur(
      idchauffeur, Reservation reservation) async {
    await suprimeraRservationChezUnChaufeur(idchauffeur, reservation)
        .then((value) => {'reject': true});
    return null;
  }

  static Future<Reservation> reservationFuture(idRserVation) async =>
      await firestore
          .collection("Reservation")
          .doc(idRserVation)
          .get()
          .then((event) => Reservation.fromJson(event.data()!));

  static Future<Map<String, bool>?> acceptByChauffeur(
      idchauffeur, Reservation reservation) async {
    await suprimeraRservationChezUnChaufeur(idchauffeur, reservation)
        .then((value) {
      reservation.updateAcceptedState(1);
      return {'accept': true};
    });
    return null;
  }

// suprimer la  réservation de la collection d'un chauffeur
  static Future suprimeraRservationChezUnChaufeur(
      idchauffeur, Reservation reservation) async {
    await firestore
        .collection('Courses')
        .doc(idchauffeur)
        .collection("Request")
        .doc(reservation.idReservation)
        .delete();
  }

  // fin de la classe.
}

//  la reservation a trois état {1:eccepté, 0: en requette, -1: annulé}
