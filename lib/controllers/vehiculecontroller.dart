import 'package:get/get.dart';

import 'package:taxischronodriver/varibles/variables.dart';

import '../modeles/applicationuser/chauffeur.dart';
import '../modeles/autres/vehicule.dart';

class VehiculeController extends GetxController {
  Rx<Vehicule> currentVehicul = Vehicule(
    assurance: "",
    token: "",
    isActive: false,
    activeEndDate: DateTime.now(),
    expirationAssurance: DateTime.now(),
    imatriculation: "",
    numeroDeChassie: "",
    chauffeurId: "",
    statut: false,
  ).obs;

  Vehicule get currentCar => currentVehicul.value;
  static setCurrentCar(userid) async {
    await Chauffeur.havehicule(userid).then((value) {
      if (value != null) VehiculeController().currentVehicul.value = value;
    });
  }

  @override
  void onInit() {
    String chaufd = authentication.currentUser!.uid;
    currentVehicul.bindStream(Vehicule.vehiculeStrem(chaufd));
    super.onInit();
  }
}
