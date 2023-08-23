import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxischronodriver/modeles/autres/package.dart';
import '../../varibles/variables.dart';

class ForfetClients {
  final String idForfait;
  final Packages package;
  DateTime activationDate;
  int nombreDeTicketsUtilise;
  int nombreDeTicketRestant;
  final String idUser;
  ForfetClients({
    required this.idUser,
    required this.activationDate,
    required this.idForfait,
    required this.nombreDeTicketRestant,
    required this.nombreDeTicketsUtilise,
    required this.package,
  });

  Map<String, dynamic> toMap() => {
        "idForfait": idForfait,
        "idPackage": package.toMap(),
        "idUser": idUser,
        "activationDate": Timestamp.fromDate(activationDate),
        "nombreDeTicketsUtilise": nombreDeTicketsUtilise,
        "nombreDeTicketRestant":
            package.nombreDeTickets - nombreDeTicketsUtilise,
      };

  factory ForfetClients.fromJson(Map<String, dynamic> forfait) => ForfetClients(
        idUser: forfait['idUser'],
        activationDate: (forfait['activationDate'] as Timestamp).toDate(),
        idForfait: forfait['idForfait'],
        nombreDeTicketRestant: forfait['nombreDeTicketRestant'],
        nombreDeTicketsUtilise: forfait['nombreDeTicketsUtilise'],
        package: Packages.fromMap(forfait['package']),
      );

  forfetCollection() => firestore
      .collection('Client')
      .doc(idUser)
      .collection("ForfetsActifs")
      .doc(idForfait);

  // activer un forfait
  activerForfait() async {
    await forfetCollection().set(toMap());
  }

  utiliserUnTicket() async {
    nombreDeTicketsUtilise++;
    // nombreDeTicketRestant -= 1;
    if (nombreDeTicketRestant > 0) {
      await forfetCollection().update(toMap());
    } else {
      // await forfetCollection().delete();
    }
  }

  static Stream<List<ForfetClients>> listDesForFaitsACtife(userid) => firestore
      .collection('Client')
      .doc(userid)
      .collection("ForfetsActifs")
      .where(isGreaterThan: 0, 'nombreDeTicketRestant')
      .snapshots()
      .map((event) => event.docs
          .map((forfait) => ForfetClients.fromJson(forfait.data()))
          .toList());

  static Future<List<ForfetClients>> listDesForFaitsACtifeFuture(userid) =>
      firestore
          .collection('Client')
          .doc(userid)
          .collection("ForfetsActifs")
          .where(isGreaterThan: 0, 'nombreDeTicketRestant')
          .get()
          .then((event) => event.docs
              .map((forfait) => ForfetClients.fromJson(forfait.data()))
              .toList());
}
