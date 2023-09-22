import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:page_transition/page_transition.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/screens/component/show_one_cours.dart';

// import '../../modeles/applicationuser/client.dart';
import '../../modeles/autres/reservation.dart';
import '../../modeles/autres/transaction.dart';
import '../../varibles/variables.dart';
import '../homepage.dart';

class MapWaitingRuning extends StatefulWidget {
  final TransactionApp transactionApp;
  final bool? isVieuw;
  const MapWaitingRuning(
      {super.key, this.isVieuw, required this.transactionApp});

  @override
  State<MapWaitingRuning> createState() => _MapWaitingRuningState();
}

class _MapWaitingRuningState extends State<MapWaitingRuning> {
  String phoneClient = '';

  setClientPhone() async {
    final userclient =
        await ApplicationUser.infos(widget.transactionApp.idclient);
    setState(() {
      phoneClient = userclient.userTelephone!;
    });
  }

  @override
  void initState() {
    setClientPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Reservation>(
        stream:
            Reservation.reservationStream(widget.transactionApp.idReservation),
        builder: (context, snapshot) {
          return (!snapshot.hasError && snapshot.hasData)
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20))),
                  height: widget.isVieuw != null ? 412 : 445,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RequestCard(reservation: snapshot.data!, isView: true),
                      // spacerHeight(widget.isVieuw != null ? 1 : 20),
                      if (widget.isVieuw != null)
                        const SizedBox()
                      else
                        SizedBox(
                          height: 65,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: widget.transactionApp.etatTransaction ==
                                        1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                              icon: const Icon(Icons.check,
                                                  size: 30.0),
                                              onPressed: () async {
                                                widget.transactionApp
                                                    .modifierEtat(2);
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        PageTransition(
                                                            child:
                                                                const HomePage(),
                                                            type: PageTransitionType
                                                                .leftToRight),
                                                        (route) => false);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 9),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9),
                                                  )),
                                              label: Text('Fin de la course',
                                                  style: police)),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  PageTransition(
                                                      child: ShowOneCourse(
                                                          transactionApp: widget
                                                              .transactionApp),
                                                      type: PageTransitionType
                                                          .leftToRight));
                                            },
                                            child: Icon(
                                                Icons.info_outline_rounded,
                                                size: 50,
                                                color: dredColor),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton.icon(
                                              icon: const Icon(Icons.close,
                                                  size: 30.0),
                                              onPressed: () async {
                                                await snapshot.data!
                                                    .annuletReservation()
                                                    .then(
                                                      (value) => Navigator.of(
                                                              context)
                                                          .pushAndRemoveUntil(
                                                              PageTransition(
                                                                  child:
                                                                      const HomePage(),
                                                                  type: PageTransitionType
                                                                      .leftToRight),
                                                              (route) => false),
                                                    );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: dredColor,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 9),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9),
                                                  )),
                                              label: Text('Annuler',
                                                  style: police)),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  PageTransition(
                                                      child: ShowOneCourse(
                                                          transactionApp: widget
                                                              .transactionApp),
                                                      type: PageTransitionType
                                                          .leftToRight));
                                            },
                                            child: Icon(
                                                Icons.info_outline_rounded,
                                                size: 50,
                                                color: dredColor),
                                          ),
                                          phoneClient.trim().isNotEmpty
                                              ? ElevatedButton.icon(
                                                  icon: const Icon(Icons.phone,
                                                      size: 30.0),
                                                  onPressed: () async {
                                                    await FlutterPhoneDirectCaller
                                                        .callNumber(
                                                            phoneClient);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor: Colors
                                                              .green,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      25,
                                                                  vertical: 9),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9),
                                                          )),
                                                  label: Text('Client',
                                                      style: police.copyWith(
                                                          fontSize: 12)),
                                                )
                                              : shimmer(30.0, 50.0),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      // spacerHeight(widget.isVieuw != null ? 0 : 20),
                      // widget.isVieuw != null
                      //     ? SizedBox(
                      //         height: 60,
                      //         width: double.infinity,
                      //         child: Card(
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(15)),
                      //           child: Center(
                      //             child: Text(
                      //               widget.transactionApp.etatTransaction == 0
                      //                   ? "En attente"
                      //                   : widget.transactionApp
                      //                               .etatTransaction ==
                      //                           1
                      //                       ? "En cours"
                      //                       : widget.transactionApp
                      //                                   .etatTransaction ==
                      //                               -1
                      //                           ? "Annulé"
                      //                           : "Terminée",
                      //               style: police.copyWith(
                      //                   fontWeight: FontWeight.bold),
                      //             ),
                      //           ),
                      //         ),
                      //       )

                      // boutonText(
                      //     context: context,
                      //     couleur: Colors.green.shade300,
                      //     action: () async {
                      //       // await Client.utiliserUnTicket(
                      //       //     authentication.currentUser!.uid);
                      //       await widget.transactionApp.modifierEtat(1);
                      //     },
                      //     text: 'Démarer')
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
