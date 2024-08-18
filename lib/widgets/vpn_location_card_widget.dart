import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn/app_prefrences/app_prefrences.dart';
import 'package:vpn/controller/controller_home.dart';
import 'package:vpn/main.dart';
import 'package:vpn/model/vpn_info.dart';
import 'package:vpn/vpn_engine/vpn_engine.dart';

class VpnLocationCardWidget extends StatelessWidget {
  final VpnInfo vpnInfo;
  const VpnLocationCardWidget({super.key, required this.vpnInfo});

  String formatSpeedBytes(int speedBytes, int decimals) {
    if (speedBytes <= 0) {
      return "0 B";
    }
    const suffixesTitle = ['Bps', 'kbps', 'Mbps', 'Gbps', 'Tbps'];
    var speedTitleIndex = (log(speedBytes) / log(1024)).floor();

    return "${(speedBytes / pow(1024, speedTitleIndex)).toStringAsFixed(decimals)}  ${suffixesTitle[speedTitleIndex]}";
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<ControllerHome>();
    screenSize = MediaQuery.of(context).size;
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: screenSize.height * .01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          homeController.vpnInfo.value = vpnInfo;
          AppPrefrences.vpnInfoObj = vpnInfo;
          Get.back();
          if (homeController.vpnConnectionState.value ==
              VpnEngine.vpnConnectedNow) {
            VpnEngine.stopVpnNow();

            Future.delayed(
                Duration(seconds: 3), () => homeController.connectToVpnNow());
          } else {
            homeController.connectToVpnNow();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          leading: Container(
            padding: EdgeInsets.all(0.5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              'countryFlags/${vpnInfo.countryLongName.toLowerCase()}.png',
              height: 40,
              width: screenSize.width * 0.15,
              fit: BoxFit.cover,
            ),
          ),

          //COuntry name
          title: Text(vpnInfo.countryLongName),

          //vpn sppedd
          subtitle: Row(
            children: [
              Icon(
                Icons.shutter_speed,
                color: Colors.redAccent,
                size: 20,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                formatSpeedBytes(vpnInfo.speed, 2),
                style: TextStyle(fontSize: 13),
              )
            ],
          ),

          //number of sessions
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vpnInfo.vpnSessionNum.toString(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).lightTextColor),
              ),
              SizedBox(
                width: 4,
              ),
              Icon(
                CupertinoIcons.person_2_alt,
                color: Colors.redAccent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
