import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/vpn_info.dart';

class AppPrefrences {
  static late Box boxOfData;
  static Future<void> initHive() async {
    await Hive.initFlutter();
    boxOfData = await Hive.openBox('data');
  }

//user choce for theme
  static bool get isModeDark => boxOfData.get('isModeDark') ?? false;
  static set isModeDark(bool value) => boxOfData.put('isModeDark', value);

  //saving singlr selected vpn detals

  static VpnInfo get vpnInfoObj =>
      VpnInfo.fromJson(jsonDecode(boxOfData.get("vpn") ?? '{}'));
  static set vpnInfoObj(VpnInfo value) =>
      boxOfData.put('vpn', jsonEncode(value));

  //saving all vpn servers deatils

  static List<VpnInfo> get vpnList {
    List<VpnInfo> tempVpnList = [];

    final dataVpn = jsonDecode(boxOfData.get('vpnList') ?? '[]');

    for (var data in dataVpn) {
      tempVpnList.add(VpnInfo.fromJson(data));
    }
    return tempVpnList;
  }

  static set vpnList(List<VpnInfo> valueList) =>
      boxOfData.put('vpnList', jsonEncode(valueList));
}
