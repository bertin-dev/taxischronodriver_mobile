import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:taxischronodriver/controllers/requestcontrollers.dart';
import 'package:taxischronodriver/controllers/vehiculecontroller.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
import 'package:taxischronodriver/modeles/autres/reservation.dart';
import 'package:taxischronodriver/modeles/autres/transaction.dart';
import 'package:taxischronodriver/modeles/autres/vehicule.dart';
import 'package:taxischronodriver/screens/component/courswaiting.dart';

import 'package:taxischronodriver/screens/component/sidebar.dart';
import 'package:taxischronodriver/services/mapservice.dart';
import 'package:taxischronodriver/services/transitionchauffeur.dart';
import 'package:taxischronodriver/varibles/variables.dart';

import '../controllers/useapp_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///////////////////
  ///les variables
  ///////////////.
  Completer controllerMap = Completer<GoogleMapController>();
  ScrollController controllerSlide = ScrollController();
  late Vehicule vehicule;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool voirs = false;
  LatLng? location;
  Set<Marker> markersSets = {};

  setMrkers() async {
    final bitcar = await bitcone(carUrl);
    markersSets.add(
      Marker(
        markerId: MarkerId(authentication.currentUser!.uid),
        position: location!,
        infoWindow: const InfoWindow(
          title: "Votre Positions actuelle",
        ),
        icon: BitmapDescriptor.fromBytes(bitcar),
      ),
    );
  }

  // Location? userCurrentLocation;
  fromCurrentPosition() async {
    location = GooGleMapServices.currentPosition;
    if (location != null) {
      setMrkers();
      setState(() {});
    }

    if (location == null) {
      var permissison = await GooGleMapServices.handleLocationPermission();
      if (permissison) {
        if (mounted) {
          await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high)
              .then((value) {
            setState(() {
              location = LatLng(value.latitude, value.longitude);
              setMrkers();
              // print(location!.latitude);
            });
          });
        }
      }
    }

    Geolocator.getPositionStream().listen((event) async {
      location = LatLng(event.latitude, event.longitude);
      await Vehicule.setPosition(location!, authentication.currentUser!.uid);
      setMrkers();
    });
  }

// fonction permettanrt de revenir sur la position de l'Utilisateur
  voirMaPosition() async {
    GoogleMapController googleMapController = await controllerMap.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location!,
          zoom: 16,
        ),
      ),
    );
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylinesSets = {};
  bool loder = false;

  ///////////////////
  ///les fonctions
  ///////////////.

  @override
  void initState() {
    initializeFirebaseMessaging();
    Get.put<ChauffeurController>(ChauffeurController());
    fromCurrentPosition();
    transactionEncour();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const SafeArea(child: SideBar()),
      body: SafeArea(
        child: location == null
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Recherche de position...",
                            style: police,
                          ),
                        ),
                      ),
                      spacerHeight(20),
                      const LoadingComponen(),
                      spacerHeight(10),
                      Text(
                        "Vérification des services de localisation ...",
                        textAlign: TextAlign.center,
                        style: police.copyWith(letterSpacing: 3, fontSize: 16),
                      ),
                      spacerHeight(20),
                      boutonText(
                          context: context,
                          action: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                                (route) => false);
                          },
                          text: 'Recharger'),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition:
                        CameraPosition(target: location!, zoom: 16),
                    onMapCreated: (control) {
                      controllerMap.complete(control);
                    },
                    markers: markersSets,
                    polylines: Set<Polyline>.of(polylinesSets.values),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              scaffoldKey.currentState!.openDrawer();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: dredColor, shape: BoxShape.circle),
                              child: const Icon(
                                Icons.menu,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: GetX<VehiculeController>(
                          init:
                              Get.put<VehiculeController>(VehiculeController()),
                          builder: (_) {
                            if (_.currentCar.chauffeurId.trim().isNotEmpty) {
                              return FlutterSwitch(
                                width: 100.0,
                                height: 45.0,
                                toggleSize: 43,
                                activeColor: Colors.green,
                                inactiveColor: Colors.grey.shade500,
                                activeToggleColor: dredColor,
                                activeText: "Online",
                                inactiveText: "Ofline",
                                activeTextColor: Colors.white,
                                inactiveTextColor: Colors.black,
                                activeIcon: const Icon(Icons.online_prediction),
                                inactiveIcon: const Icon(Icons.offline_bolt),
                                switchBorder: Border.all(color: dredColor),
                                value: _.currentCar.statut,
                                onToggle: (value) async {
                                  // print(value);
                                  if (value == false) {
                                    await _.currentCar.setStatut(value);
                                  } else {
                                    if (_.currentCar.isActive) {
                                      await _.currentCar.setStatut(value);
                                    } else {
                                      boobtomshet(
                                        keys: scaffoldKey,
                                        hei: 300,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            spacerHeight(20),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Text(
                                                "$value Votre Compte n'est plus actif veillez le réactiver pour continuer à recevoir les commandes des clients",
                                                style: police.copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            spacerHeight(30),
                                            boutonText(
                                              couleur: Colors.green.shade400,
                                              context: context,
                                              action: () {
                                                activerMoncompte();
                                              },
                                              text: "Activer mon compte",
                                            ),
                                            spacerHeight(15),
                                            boutonText(
                                              context: context,
                                              action: () {
                                                Navigator.of(context).pop();
                                              },
                                              text: "Annuler",
                                            ),
                                            spacerHeight(30),
                                          ],
                                        ),
                                      );
                                    }
                                  }

                                  setState(() {});
                                },
                              );
                            } else {
                              return Card(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text('chargement ...', style: police),
                              ));
                            }
                          }),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: GetX<ResquestController>(
                        init: Get.put<ResquestController>(ResquestController()),
                        builder: (control) {
                          if (control.reservations != null &&
                              control.reservations.isNotEmpty) {
                            Timer.periodic(const Duration(seconds: 9), (timer) {
                              setState(() {
                                polylinesSets = {};
                              });
                            });
                            return RequestCard(
                              reservation: control.reservations[0],
                            );
                          } else {
                            return SizedBox(
                              height: 70,
                              width: taille(context).width * 0.7,
                              child: InkWell(
                                splashColor: dredColor,
                                onTap: () {
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SafeArea(child: contenaireCours());
                                    },
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: ListTile(
                                      title: Text(
                                        'En cours',
                                        style: police.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: dredColor,
                                        child: Center(
                                          child: Icon(Icons.run_circle_sharp,
                                              color: blanc, size: 40),
                                        ),
                                      ),
                                      trailing: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: Center(
                                          child: Text(
                                            transactionAppList.length
                                                .toString(),
                                            style: police.copyWith(
                                              fontSize: 30,
                                              color: blanc,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                  loder
                      ? Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: noire.withOpacity(0.4),
                          child: const Center(child: LoadingComponen()),
                        )
                      : const SizedBox.shrink()
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => voirMaPosition(),
        backgroundColor: dredColor,
        child: const Icon(Icons.podcasts, size: 30),
      ),
    );
  }
// fontionc activant le compte

  activerMoncompte() async {
    Navigator.of(context).pop();

    boobtomshet(
      keys: scaffoldKey,
      hei: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Choisissez votre plan de souscription',
                textAlign: TextAlign.center,
                style: police.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4)),
          ),
          spacerHeight(30),
          ListTile(
            onTap: () async {
              //loder = true;
              setState(() {});
//////recupére les données de cars
              await bd
                  .collection('cars')
                  .doc(authentication.currentUser!.uid)
                  .get()
                  .then((event) async {
                if (event['isActive'] == true) {
                  Fluttertoast.showToast(
                      msg: 'Vous avez déjà utilisé votre temps d\'éssaie',
                      toastLength: Toast.LENGTH_LONG);
                  //loder = false;
                  setState(() {});
                } else {
                  /*await Chauffeur.havehicule(authentication.currentUser!.uid)
                      .then((value) async {*/
                  final date = DateTime.now().add(const Duration(days: 7));
                  await Vehicule.setActiveState(
                      true,
                      date.millisecondsSinceEpoch,
                      authentication.currentUser!.uid);

                  // loder = false;
                  setState(() {});
                  Fluttertoast.showToast(
                      msg:
                          "Vous avez activé votre période d'éssaie avec succes",
                      toastLength: Toast.LENGTH_LONG);
                  Navigator.of(context).pop();
                  // });
                }
              });

              /* Chauffeur.havehicule(authentication.currentUser!.uid)
                  .then((value) async {
                vehicule = value!;
                if (vehicule.isActive == true) {
                  Fluttertoast.showToast(
                      msg: 'Vous avez déjà utilisé votre temps d\'éssaie',
                      toastLength: Toast.LENGTH_LONG);
                  /* loder = false;
                  setState(() {});
                }
              });
              await datatbase
                  .ref('Vehicules')
                  .child(authentication.currentUser!.uid)
                  .child("assaie")
                  .get()
                  .then((value) async {
                if (value.exists) {
                  Fluttertoast.showToast(
                      msg: 'Vous avez déjà utilisé votre temps d\'éssaie',
                      toastLength: Toast.LENGTH_LONG);*/
                  loder = false;
                  setState(() {});
                } else {
                  await Chauffeur.havehicule(authentication.currentUser!.uid)
                      .then((value) async {
                    final date = DateTime.now().add(const Duration(days: 7));
                    await Vehicule.setActiveState(
                        true, date.millisecondsSinceEpoch, value!.chauffeurId);

                    loder = false;
                    setState(() {});
                    Fluttertoast.showToast(
                        msg:
                            "Vous avez activé votre période d'éssaie avec succes",
                        toastLength: Toast.LENGTH_LONG);
                    Navigator.of(context).pop();
                  });

                  /* await datatbase
                      .ref('Vehicules')
                      .child(authentication.currentUser!.uid)
                      .update({"assaie": true})*/
                  /* await bd
                      .collection("cars")
                      .doc(authentication.currentUser!.uid)
                      .update({"isActive": true}).then((value) {
                    loder = false;
                    setState(() {});
                    Fluttertoast.showToast(
                        msg:
                            "Vous avez activé votre période d'éssaie avec succes",
                        toastLength: Toast.LENGTH_LONG);
                    Navigator.of(context).pop();
                  });*/
                }
              });*/
              // await payement(jours: 8, prix: 2500, scaffoldkey: scaffoldKey);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: dredColor,
                )),
            title: Text(
              "Période d'éssaie",
              style: police.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text("Valide 7 jours", style: police),
            leading: CircleAvatar(
              backgroundColor: dredColor,
              child: Icon(Icons.local_taxi, color: blanc),
            ),
          ),
          spacerHeight(7.5),
          const Divider(),
          spacerHeight(7.5),
          ListTile(
            onTap: () async {
              await payement(jours: 8, prix: 2500, scaffoldkey: scaffoldKey);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: dredColor,
                )),
            title: Text(
              "2500 FCFA",
              style: police.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text("Valide 8 jours", style: police),
            leading: CircleAvatar(
              backgroundColor: dredColor,
              child: Icon(Icons.local_taxi, color: blanc),
            ),
          ),
          spacerHeight(7.5),
          const Divider(),
          spacerHeight(7.5),
          ListTile(
            onTap: () async {
              await payement(jours: 16, prix: 5000, scaffoldkey: scaffoldKey);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Colors.blue.shade400,
                )),
            title: Text(
              "5OOO FCFA",
              style: police.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text("Valide 16 jours", style: police),
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade400,
              child: Icon(Icons.local_taxi, color: blanc),
            ),
          ),
          spacerHeight(7.5),
          const Divider(),
          spacerHeight(7.5),
          ListTile(
            onTap: () async {
              await payement(jours: 32, prix: 10000, scaffoldkey: scaffoldKey);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Colors.green.shade400,
                )),
            title: Text(
              "10 000 FCFA",
              style: police.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text("Valide 32 jours", style: police),
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade400,
              child: Icon(Icons.local_taxi, color: blanc),
            ),
          ),
          spacerHeight(7.5),
          const Divider(),
          spacerHeight(7.5),
          boutonText(
              context: context,
              action: () {
                Navigator.of(context).pop();
              },
              text: 'Annuler'),
          spacerHeight(30),
        ],
      ),
    );
  }

// Contenaire affichant les courses en cours
///////////////////////////////////////////////////////////:::

  Widget contenaireCours() {
    return Column(
      children: [
        ListTile(
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_circle_down,
              size: 40,
              color: dredColor,
            ),
          ),
          title: Text(
            'Vos Cours en cours',
            style: police.copyWith(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          subtitle: Text("${transactionAppList.length} Courses en cours",
              style: police),
        ),
        spacerHeight(20),
        Expanded(
          child: ListView.builder(
              itemCount: transactionAppList.length,
              itemBuilder: (context, index) {
                return MapWaitingRuning(
                    transactionApp: transactionAppList[index]);
              }),
        )
      ],
    );
  }
// paiements
///////////////////////////////////////////////////////////:::

  Future payement({
    required double prix,
    required int jours,
    required GlobalKey<ScaffoldState> scaffoldkey,
  }) async {
    final reference =
        "${authentication.currentUser!.uid}${DateTime.now().microsecondsSinceEpoch}";

    final mapPey = {
      'amount': prix,
      'currency': 'XAF',
      'reference': reference,
      'email': authentication.currentUser!.email,
      'phone': authentication.currentUser!.phoneNumber!,
      'name': authentication.currentUser!.displayName,
      "sandbox": "sb.LCpQWUn5EhUyl0AmvtkEEQhYzJ4e0B0n",
      "description":
          "paiement de packages pour ${authentication.currentUser!.displayName}"
    };
    final dio = Dio();
    Navigator.of(context).pop();
    loder = true;
    setState(() {});
    try {
      await dio
          .post(
        "https://api.notchpay.co/payments/initialize",
        queryParameters: mapPey,
        options: Options(headers: header),
      )
          .then((value) async {
        // print(value);
        loder = false;
        setState(() {});
        if (value.statusCode == 201) {
          final response = value.data;
          debugPrint(response.toString());
          if (response['status'] == "Accepted") {
            final secondRef = response["transaction"]['reference'];

            TextEditingController controllerphone = TextEditingController();
            showDialog(
              context: scaffoldkey.currentContext!,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(8),
                  titlePadding: const EdgeInsets.all(12),
                  title: Text(
                    'Valider le paiement',
                    style: police.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  content: TextFormField(
                    controller: controllerphone,
                    maxLength: 9,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: police.copyWith(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      prefix: Text('+237', style: police),
                      hintText: "number",
                      hintStyle: police,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Annuler',
                          style: police.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    //  boutton permettant de valider le paiement
                    TextButton(
                      /////////
                      onPressed: () async {
                        print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
                        print(authentication.currentUser!.phoneNumber);
                        if (controllerphone.text.trim().length == 9) {
                          Navigator.of(context).pop();
                          loder = true;
                          setState(() {});
                          final map = {
                            'currency': 'xaf',
                            'channel': 'mobile',
                            'data': {
                              // 'phone': authentication.currentUser!.phoneNumber
                              'phone': '+237${controllerphone.text}',
                            },
                          };
                          try {
                            await dio
                                .put(
                              'https://api.notchpay.co/payments/$secondRef',
                              queryParameters: map,
                              options: Options(headers: header),
                            )
                                .then((valuerequest) {
                              // print(valuerequest);
                              // toaster(
                              //     message:
                              //         "Taper #150*50# et suivre les instructions",
                              //     long: true);
                              loder = false;
                              setState(() {});
                              toaster(
                                  message:
                                      "Votre transaction est en cours de traitement\nCela peut prendre jusqu'à 2 minutes",
                                  color: Colors.blueAccent,
                                  long: true);
                              // dialogInformation(context,
                              //     message:
                              //         "Votre transaction est en cours de traitement\nCela peut prendre jusqu'à 2 minutes",
                              //     icone: Icon(
                              //       Icons.run_circle,
                              //       color: blanc,
                              //     ));
                              if (valuerequest.statusCode == 202) {
                                var counta = 0;
                                Timer.periodic(const Duration(seconds: 1),
                                    (timer) async {
                                  counta++;
                                  if (counta == 180) {
                                    timer.cancel();
                                  }

                                  await dio
                                      .get(
                                    "https://api.notchpay.co/payments/$secondRef",
                                    queryParameters: {"currency": "xaf"},
                                    options: Options(headers: header),
                                  )
                                      .then((values) async {
                                    // print(values.data);
                                    if (values.statusCode == 200 &&
                                        values.data["transaction"]['status'] ==
                                            "complete") {
                                      timer.cancel();
                                      await Chauffeur.havehicule(
                                              authentication.currentUser!.uid)
                                          .then((value) async {
                                        final date = DateTime.now()
                                            .add(Duration(days: jours));
                                        await Vehicule.setActiveState(
                                            true,
                                            date.millisecondsSinceEpoch,
                                            value!.chauffeurId);
                                        Fluttertoast.showToast(
                                            msg:
                                                "Vous avez activé votre compte pour une duré de $jours Jours",
                                            toastLength: Toast.LENGTH_LONG,
                                            backgroundColor: Colors.green);
                                        await Future.delayed(
                                            const Duration(seconds: 7));
                                        Fluttertoast.cancel();
                                      });
                                    }
                                  });
                                });
                              } else {
                                throw Exception("Erreur de paiement");
                              }
                            });
                          } catch (except) {
                            toaster(
                                message:
                                    "Paiement échoué veillez vérifier que votre solde est suffisant",
                                color: Colors.red,
                                long: true);
                            // dialogInformation(
                            //   context,
                            //   message:
                            //       "Paiement échoué veillez vérifier que votre solde est suffisant",
                            //   icone: const Icon(Icons.close,
                            //       size: 40, color: Colors.red),
                            // );
                            loder = false;
                            setState(() {});
                          }
                        } else {
                          toaster(
                              message: "Entez un numéro de téléphone correcte",
                              color: Colors.red,
                              long: true);
                        }
                      }, ///////
                      child: Text(
                        'valider',
                        style: police.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            toaster(
                message:
                    "Une Erreur est survenu: veillez vérifier votre connexion internet",
                long: true);
          }
        } else {}
      });
    } catch (e) {
      loder = false;
      setState(() {});
      toaster(
          message:
              "Une Erreur est survenu: veillez vérifier votre connexion internet",
          long: true);
    }
  }

  Future<dynamic> dialogInformation(BuildContext context,
      {required String message, required Widget icone}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              message,
              style: police.copyWith(fontWeight: FontWeight.bold),
            ),
            contentPadding: const EdgeInsets.all(15),
            titlePadding: const EdgeInsets.all(15),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Annuler",
                    style: police.copyWith(fontWeight: FontWeight.bold)),
              )
            ],
            content: CircleAvatar(
              backgroundColor: dredColor,
              child: Center(child: icone),
            ),
          );
        });
  }

//**** *///////////////////////////////////
// les Icones des éléments

  Future<Uint8List> bitcone(imgurli) async {
    return (await NetworkAssetBundle(Uri.parse(imgurli)).load(imgurli))
        .buffer
        .asUint8List();
  }

  String imgurl =
      "https://firebasestorage.googleapis.com/v0/b/taxischrono-c12c9.appspot.com/o/Bonhomme%20LOca122%20(2).png?alt=media&token=a1394dea-4b12-4d90-b223-4473746317ef";
  String carUrl =
      "https://firebasestorage.googleapis.com/v0/b/taxischrono-c12c9.appspot.com/o/Bonhomme%20LOca%20voit.png?alt=media&token=c10224dc-8e5b-48fe-b713-d01f70eb6866";

  // biteUser() async => await bitcone(imgurl);

////////////////////////////////////////////////////////////////////:::::
  // les permissions des notifications

  List<TransactionApp> transactionAppList = [];
////////////////////////////////////////////////////////////////////////////
  // Pour recevoir les notifications firebase

  initializeFirebaseMessaging() async {
    final instanceMessage = FirebaseMessaging.instance;
    await instanceMessage.getToken().then((token) async {
      /* await datatbase
          .ref("Vehicules")
          .child(authentication.currentUser!.uid)
          .update({"token": token});*/

      await bd
          .collection("cars")
          .doc(authentication.currentUser!.uid)
          .update({"token": token});
    });
  }

////////////////////////////////////////////////////////////////////////
// pour les transactions en cours

  transactionEncour() async {
    TransactionApp.currentTransaction(authentication.currentUser!.uid)
        .listen((event) {
      setState(() {
        transactionAppList = event;
      });
      for (var elemnt in event) {
        // print(elemnt.tomap());
        if (elemnt.etatTransaction != 2 && elemnt.etatTransaction != -1) {
          Reservation.reservationStream(elemnt.idReservation)
              .listen((event) async {});
        }
      }
    });
  }
}

class RequestCard extends StatefulWidget {
  const RequestCard({
    Key? key,
    required this.reservation,
    this.isView,
  }) : super(key: key);

  final Reservation reservation;
  final bool? isView;

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  int valueconut = 10;
  conterSet() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (valueconut > 0) {
        setState(() {
          valueconut--;
        });
      } else {
        timer.cancel();
        Reservation.rejectByChauffeur(
            authentication.currentUser!.uid, widget.reservation);
      }
    });
  }

//
  @override
  void initState() {
    if (widget.isView == null) conterSet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prix = widget.reservation.prixReservation;
    final depart = widget.reservation.pointDepart;
    final arrive = widget.reservation.pointArrive;
    final type = widget.reservation.typeReservation;
    return SizedBox(
      height: widget.isView == null ? 450 : 350,
      width: taille(context).width - 20,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_taxi,
                    size: 30,
                    color: dredColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(type,
                      style: police.copyWith(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  const Expanded(child: SizedBox()),
                  Text("$prix XFA",
                      style: police.copyWith(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
              spacerHeight(8),
              FutureBuilder<ApplicationUser>(
                  future: ApplicationUser.infos(widget.reservation.idClient),
                  builder: (context, snapshot) {
                    return (!snapshot.hasError && snapshot.hasData)
                        ? ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              snapshot.data!.userName,
                              maxLines: 1,
                              style: police.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 0.0),
                            ),
                            horizontalTitleGap: 5,
                            subtitle: Text(
                              snapshot.data!.userTelephone ??
                                  snapshot.data!.userEmail,
                              style: police.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: dredColor,
                                  letterSpacing: 3),
                            ),
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  "images/user.png",
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ),
                            trailing: FutureBuilder<RouteModel?>(
                                future: GooGleMapServices().getRoute(
                                    start: depart.adresseposition,
                                    end: arrive.adresseposition),
                                builder: (context, snapshot) {
                                  return (!snapshot.hasError &&
                                          snapshot.hasData)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data!.distance.text,
                                              style: police,
                                            ),
                                            Text(
                                              snapshot
                                                  .data!.tempsNecessaire.text,
                                              style: police,
                                            ),
                                          ],
                                        )
                                      : shimmer(50.0, 60.0);
                                }),
                          )
                        : shimmer(60.0, double.infinity);
                  }),
              if (widget.isView == null) spacerHeight(12),
              ListTile(
                leading: Icon(Icons.pin_drop, color: dredColor, size: 30),
                horizontalTitleGap: 8,
                title: Text(
                  'Point de départ',
                  style: police.copyWith(fontSize: 12),
                ),
                subtitle: Text(
                  depart.adresseName,
                  maxLines: 2,
                  style: police.copyWith(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.0),
                ),
              ),
              widget.isView == null
                  ? ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(
                        Icons.watch_later_outlined,
                        color: Colors.red.shade200,
                      ),
                      title: Text(
                        "Il vous reste : $valueconut s",
                        style: police.copyWith(
                            color: valueconut > 5 ? Colors.black : dredColor,
                            fontSize: 13,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListTile(
                      leading: Icon(
                        Icons.watch_later_outlined,
                        color: Colors.blueGrey.shade500,
                      ),
                      title: Text(
                        DateFormat("EEEE d MMMM y")
                            .format(widget.reservation.dateReserVation),
                        style: police.copyWith(
                            color: valueconut > 5 ? Colors.black : dredColor,
                            fontSize: 13,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
              ListTile(
                leading:
                    Icon(Icons.location_history, color: dredColor, size: 30),
                horizontalTitleGap: 8,
                title: Text(
                  'point d\'arrivé',
                  style: police.copyWith(fontSize: 12),
                ),
                subtitle: Text(
                  arrive.adresseName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: police.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.0),
                ),
              ),
              if (widget.isView == null) spacerHeight(15),
              if (widget.isView == null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        icon: const Icon(Icons.close, size: 30.0),
                        onPressed: () async {
                          await Chauffeur.refuserserunCommande(
                              widget.reservation,
                              authentication.currentUser!.uid);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: dredColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            )),
                        label: Text('Annuler', style: police)),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check, size: 30.0),
                      onPressed: () async {
                        Chauffeur.accepterLaCommande(widget.reservation,
                                authentication.currentUser!.uid)
                            .then((value) async {
                          await Chauffeur.havehicule(
                                  authentication.currentUser!.uid)
                              .then((value) async {
                            if (value != null) await value.setStatut(true);
                          });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          )),
                      label: Text('Accepter', style: police),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
