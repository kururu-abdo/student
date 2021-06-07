import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:student_side/util/constants.dart';

class LogoutController extends GetxController {
  Future<void> logout() async {
    getStorage.write('isLogged', false);
  }
}
