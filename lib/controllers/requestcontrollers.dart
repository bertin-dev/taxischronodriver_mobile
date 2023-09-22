import 'package:get/get.dart';
import 'package:taxischronodriver/modeles/autres/reservation.dart';

import '../varibles/variables.dart';

class ResquestController extends GetxController {
  RxList<Reservation> reservationListobserv = <Reservation>[].obs;

  List<Reservation> get reservations => reservationListobserv;

  @override
  void onInit() {
    final idchauffeur = authentication.currentUser!.uid;
    reservationListobserv
        .bindStream(Reservation.listReservationChauffeur(idchauffeur));
    super.onInit();
  }
}
