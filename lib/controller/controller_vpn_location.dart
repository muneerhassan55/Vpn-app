import 'package:get/get.dart';
import 'package:vpn/api_vpn_get/api_vpn_get.dart';
import 'package:vpn/app_prefrences/app_prefrences.dart';

import '../model/vpn_info.dart';

class ControllerVpnLocation extends GetxController {
  List<VpnInfo> vpnFreeServersAvaliableList = AppPrefrences.vpnList;
  final RxBool isLoadingNewLocations = false.obs;
  Future<void> retrieveVpnInformation() async {
    isLoadingNewLocations.value = true;
    vpnFreeServersAvaliableList.clear();
    vpnFreeServersAvaliableList =
        await ApiVpnGate.retrieveAllFreeAvaliableVpnServers();
    isLoadingNewLocations.value = false;
  }
}
