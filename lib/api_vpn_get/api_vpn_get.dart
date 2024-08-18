import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn/app_prefrences/app_prefrences.dart';
import 'package:vpn/model/vpn_info.dart';
import 'package:http/http.dart' as http;

import '../model/ip_info.dart';

class ApiVpnGate {
  static Future<List<VpnInfo>> retrieveAllFreeAvaliableVpnServers() async {
    final List<VpnInfo> vpnServerList = [];
    try {
      final responseApi =
          await http.get(Uri.parse('http://www.net.vpnate.net/api/iphone/'));
      final commaSeperatedValueString =
          responseApi.body.split('#')[1].replaceAll('*', '');

      List<List<dynamic>> listData =
          CsvToListConverter().convert(commaSeperatedValueString);

      final header = listData[0];
      for (int counter = 1; counter < listData.length - 1; counter++) {
        Map<String, dynamic> jsonData = {};
        for (int innercounter = 0;
            innercounter < header.length;
            innercounter++) {
          jsonData.addAll({
            header[innercounter].toString(): listData[counter][innercounter]
          });
          vpnServerList.add(VpnInfo.fromJson(jsonData));
        }
      }
    } catch (e) {
      Get.snackbar('Error Occured', e.toString(),
          colorText: Colors.white, backgroundColor: Colors.red.withOpacity(.8));
    }

    if (vpnServerList.isNotEmpty) AppPrefrences.vpnList = vpnServerList;
    return vpnServerList;
  }

  static Future<void> retrieveIPDetails(
      {required Rx<IpInfo> ipInformation}) async {
    try {
      final responseFromApi =
          await http.get(Uri.parse('http://ip-api.com/json/'));

      final dataFromApi = jsonDecode(responseFromApi.body);

      ipInformation.value = IpInfo.fromJson(dataFromApi);
    } catch (e) {
      Get.snackbar('Error occured', e.toString(),
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }
}
