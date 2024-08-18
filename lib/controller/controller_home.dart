import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn/app_prefrences/app_prefrences.dart';
import 'package:vpn/model/vpn_configuration.dart';
import 'package:vpn/vpn_engine/vpn_engine.dart';

import '../model/vpn_info.dart';

class ControllerHome extends GetxController {
  final Rx<VpnInfo> vpnInfo = AppPrefrences.vpnInfoObj.obs;
  final vpnConnectionState = VpnEngine.vpnDisconnectedNow.obs;

  void connectToVpnNow() async {
    if (vpnInfo.value.base64OpenVpnConfiguration.isEmpty) {
      Get.snackbar(
          'Countary / Location', 'Please select country /location first');
      return;
    }
    if (vpnConnectionState.value == VpnEngine.vpnConnectedNow) {
      final dataConfigVpn =
          Base64Decoder().convert(vpnInfo.value.base64OpenVpnConfiguration);
      final configuration = Utf8Decoder().convert(dataConfigVpn);
      final vpnConfiguration = VpnConfiguration(
          username: 'vpn',
          password: 'vpn',
          countryName: vpnInfo.value.countryLongName,
          config: configuration);

      await VpnEngine.startVpnNow(vpnConfiguration);
    } else {
      await VpnEngine.stopVpnNow();
    }
  }

  Color get getRoundButtonColor {
    switch (vpnConnectionState.value) {
      case VpnEngine.vpnDisconnectedNow:
        return Colors.redAccent;

      case VpnEngine.vpnConnectedNow:
        return Colors.green;

      default:
        return Colors.orange;
    }
  }

  String get getRoundedButtonText {
    switch (vpnConnectionState.value) {
      case VpnEngine.vpnDisconnectedNow:
        return "Let's Connect";

      case VpnEngine.vpnConnectedNow:
        return 'DisConnect';

      default:
        return 'Connecting..';
    }
  }
}
