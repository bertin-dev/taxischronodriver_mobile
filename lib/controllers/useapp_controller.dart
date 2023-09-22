import 'package:get/get.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
// import 'package:taxischronodriver/modeles/autres/vehicule.dart';
// import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
// import 'package:taxischronodriver/varibles/variables.dart';

class ChauffeurController extends GetxController {
  Rx<Chauffeur> applicationUser = Chauffeur(
          userAdresse: '',
          userEmail: '',
          userName: '',
          userTelephone: '',
          userCni: "",
          expireCniDate: DateTime.now(),
          numeroPermi: '',
          expirePermiDate: DateTime.now())
      .obs;

  ApplicationUser get cuurentUser => applicationUser.value;

  setUser(Chauffeur applicationUser) =>
      this.applicationUser.value = applicationUser;
}
