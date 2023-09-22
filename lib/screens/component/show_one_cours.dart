import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/autres/reservation.dart';
import 'package:taxischronodriver/modeles/autres/transaction.dart';
import 'package:taxischronodriver/varibles/variables.dart';

import '../../services/mapservice.dart';

class ShowOneCourse extends StatefulWidget {
  final TransactionApp transactionApp;
  const ShowOneCourse({super.key, required this.transactionApp});

  @override
  State<ShowOneCourse> createState() => _ShowOneCourseState();
}

class _ShowOneCourseState extends State<ShowOneCourse> {
  ApplicationUser? userapp;
  Reservation? reservation;
  LatLng? location;

  Future<Uint8List> bitcone(imgurli) async {
    return (await NetworkAssetBundle(Uri.parse(imgurli)).load(imgurli))
        .buffer
        .asUint8List();
  }

  Set<Marker> markersSets = {};
  Completer controllerMap = Completer<GoogleMapController>();

// setConotroller
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

//
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylinesSets = {};

  // car Url
  String carUrl =
      "https://firebasestorage.googleapis.com/v0/b/taxischrono-c12c9.appspot.com/o/Bonhomme%20LOca%20voit.png?alt=media&token=c10224dc-8e5b-48fe-b713-d01f70eb6866";

  // set marker
  setMrkers() async {
    final bitcar = await bitcone(carUrl);
    setState(() {
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
    });
  }

// from wurrent position
  fromCurrentPosition() async {
    location = GooGleMapServices.currentPosition;
    setMrkers();
    setState(() {});
    if (location == null) {
      var permissison = await GooGleMapServices.handleLocationPermission();
      if (permissison) {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .then((value) {
          setState(() {
            location = LatLng(value.latitude, value.longitude);
          });
          setMrkers();
          setState(() {});
        });
      }
    }
  }

  setClient() async {
    userapp = await ApplicationUser.infos(widget.transactionApp.idclient);
    reservation = await Reservation.reservationFuture(
        widget.transactionApp.idReservation);
    setState(() {});
    setState(() {
      markersSets.add(
        Marker(
          markerId: const MarkerId("departduClient"),
          position: reservation!.pointDepart.adresseposition,
          infoWindow: const InfoWindow(title: "Positon de départ du client"),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
    setState(() {
      markersSets.add(
        Marker(
          markerId: const MarkerId("arriverClient"),
          position: reservation!.pointArrive.adresseposition,
          infoWindow: const InfoWindow(title: "Positon d'arrivé du client"),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
    getPolilineLines(
        reservation!.pointDepart.adresseposition,
        reservation!.pointArrive.adresseposition,
        polylinePoints,
        polylinesSets);
    setState(() {});
  }

  @override
  void initState() {
    fromCurrentPosition();
    setClient();
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        actions: [
          Icon(
            widget.transactionApp.etatTransaction == 1
                ? Icons.run_circle_sharp
                : Icons.pending_outlined,
            size: 40,
          )
        ],
        elevation: 0.0,
        title: userapp == null || reservation == null
            ? shimmer(50.0, 150.0)
            : ListTile(
                title: Text(
                  widget.transactionApp.etatTransaction == 0
                      ? reservation!.pointDepart.adresseName
                      : reservation!.pointArrive.adresseName,
                  style: police,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  userapp!.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: police,
                ),
              ),
        backgroundColor: dredColor,
      ),
      body: location == null
          ? const LoadingComponen()
          : GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: location!,
                zoom: 16,
              ),
              onMapCreated: (control) {
                controllerMap.complete(control);
              },
              markers: markersSets,
              polylines: Set<Polyline>.of(polylinesSets.values),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          voirMaPosition();
        },
        backgroundColor: blanc,
        child: Center(
          child: Icon(
            Icons.podcasts,
            size: 40,
            color: dredColor,
          ),
        ),
      ),
    );
  }
}
