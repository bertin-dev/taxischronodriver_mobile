import 'package:get/get.dart';

import '../modeles/applicationuser/appliactionuser.dart';

class CurentUser extends GetxController {
  ApplicationUser applicationUser = ApplicationUser(
    userAdresse: '',
    userEmail: '',
    userName: '',
    userTelephone: '',
  );
}
