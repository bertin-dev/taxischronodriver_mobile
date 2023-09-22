import 'package:cloud_firestore/cloud_firestore.dart' as fst;

import '../../varibles/variables.dart';

class TransactionApp {
  final String idTansaction;
  final String idclient;
  final String idChauffer;
  final String idReservation;
  final DateTime dateAcceptation;
  final DateTime? tempsDepart;
  final DateTime? tempsArrive;
  final DateTime? tempsAnnulation;
  final int etatTransaction;
  String? commentaireClientSurLeChauffeur;
  String? commentaireChauffeurSurLeClient;
  double? noteChauffeur;

  TransactionApp({
    required this.idTansaction,
    required this.idclient,
    required this.idChauffer,
    required this.idReservation,
    required this.dateAcceptation,
    required this.etatTransaction,
    this.tempsAnnulation,
    this.tempsDepart,
    this.tempsArrive,
    this.noteChauffeur,
    this.commentaireClientSurLeChauffeur,
    this.commentaireChauffeurSurLeClient,
  });

// Collection variable
  fst.DocumentReference collection() =>
      firestore.collection("TransactionApp").doc(idTansaction);

  // Json
  Map<String, dynamic> tomap() => {
        'idTansaction': idTansaction,
        "idClient": idclient,
        'idChauffeur': idChauffer,
        'idReservation': idReservation,
        "tempsDepart": tempsDepart,
        "tempsArrive": tempsArrive,
        "noteChauffeur": noteChauffeur,
        "commentaireClientSurLeChauffeur": commentaireClientSurLeChauffeur,
        'commentaireChauffeurSurLeClient': commentaireChauffeurSurLeClient,
        'dateAcceptation': fst.Timestamp.fromDate(dateAcceptation),
        "etatTransaction": etatTransaction,
        "tempsAnnulation": tempsAnnulation,
      };
  factory TransactionApp.fromJson(Map<String, dynamic> transaction) =>
      TransactionApp(
        idTansaction: transaction['idTansaction'],
        idclient: transaction['idClient'],
        idChauffer: transaction['idChauffeur'],
        dateAcceptation:
            (transaction['dateAcceptation'] as fst.Timestamp).toDate(),
        idReservation: transaction['idReservation'],
        tempsDepart: transaction['tempsDepart'] == null
            ? null
            : (transaction['tempsDepart'] as fst.Timestamp).toDate(),
        tempsArrive: transaction['tempsArrive'] == null
            ? null
            : (transaction['tempsArrive'] as fst.Timestamp).toDate(),
        noteChauffeur: transaction['noteChauffeur'] ?? 2.5,
        commentaireChauffeurSurLeClient:
            transaction["commentaireChauffeurSurLeClient"],
        commentaireClientSurLeChauffeur:
            transaction['commentaireClientSurLeChauffeur'],
        etatTransaction: (transaction['etatTransaction']),
        tempsAnnulation: transaction['tempsAnnulation'] == null
            ? null
            : (transaction['tempsAnnulation'] as fst.Timestamp).toDate(),
      );

  // Validation de la transaction
  Future valideTransaction() async {
    await collection().set(tomap());
  }

  noterChauffeur(int noteChauffeur) async {
    await collection().update({'noteChauffeur': noteChauffeur});
  }

  commenterSurLeClient(String comment) async {
    await collection().update({"commentaireChauffeurSurLeClient": comment});
  }

  commenterSurLaconduiteDuChauffeur(comment) async {
    await collection().update({'commentaireClientSurLeChauffeur': comment});
  }

  modifierEtat(int etat) async {
    if (etat == 1) {
      await collection().update({
        "etatTransaction": etat,
        "tempsDepart": fst.FieldValue.serverTimestamp()
      });
    } else if (etat == 2) {
      await collection().update({
        "etatTransaction": etat,
        "tempsArrive": fst.FieldValue.serverTimestamp(),
      });
    } else {
      await collection().update({
        "etatTransaction": etat,
        "tempsAnnulation": fst.FieldValue.serverTimestamp(),
      });
    }
  }

  static Stream<List<TransactionApp>> currentTransaction(iduser) => firestore
      .collection("TransactionApp")
      .where('idChauffeur', isEqualTo: iduser)
      .where("etatTransaction", whereIn: [0, 1])
      .snapshots()
      .map((event) {
        return event.docs
            .map((e) => TransactionApp.fromJson(e.data()))
            .toList();
      });

  static Stream<List<TransactionApp>> allTransaction(iduser) => firestore
          .collection("TransactionApp")
          .where('idChauffeur', isEqualTo: iduser)
          .snapshots()
          .map((event) {
        return event.docs
            .map((e) => TransactionApp.fromJson(e.data()))
            .toList()
            .reversed
            .toList();
      });
// fin de la classe
}

// la transaction a quatres état qui sont {0: validé, 1:en cours, -1: annulé, 2:terminé}