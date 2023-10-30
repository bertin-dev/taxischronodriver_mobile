import 'package:get/get.dart';
import 'package:taxischronodriver/controllers/useapp_controller.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChauffeurController>(ChauffeurController());
  }
}
