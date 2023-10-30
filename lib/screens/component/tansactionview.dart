import 'package:flutter/material.dart';

import '../../modeles/autres/reservation.dart';
import '../../modeles/autres/transaction.dart';
import '../../varibles/variables.dart';
import '../homepage.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key, required this.transactionApp});
  final TransactionApp transactionApp;
  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Reservation>(
        stream:
            Reservation.reservationStream(widget.transactionApp.idReservation),
        builder: (context, snapshot) {
          return (!snapshot.hasError && snapshot.hasData)
              ? Container(
                  // height: widget.isVieuw != null ? 412 : 550,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      spacerHeight(15),
                      RequestCard(
                        isView: true,
                        reservation: snapshot.data!,
                      ),
                      spacerHeight(2),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              widget.transactionApp.etatTransaction == 0
                                  ? "En attente"
                                  : widget.transactionApp.etatTransaction == 1
                                      ? "En cours"
                                      : widget.transactionApp.etatTransaction ==
                                              -1
                                          ? "Annulé"
                                          : "Terminée",
                              style:
                                  police.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : snapshot.hasError
                  ? Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: police,
                      ),
                    )
                  : const Center(
                      child: LoadingComponen(),
                    );
        });
  }
}
