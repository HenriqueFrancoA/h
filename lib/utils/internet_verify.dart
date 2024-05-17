import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

import 'package:h/utils/notification_snack_bar.dart';

class Internet {
  //Verifica se o dispositivo tem acesso a internet.
  Future<bool> checkConnection(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      // ignore: use_build_context_synchronously
      NotificationSnackbar.showError(
          context, "Verifique sua conexão com a internet");

      return false;
    }
  }
}
