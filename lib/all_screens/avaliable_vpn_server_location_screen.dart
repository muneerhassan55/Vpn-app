// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn/controller/controller_vpn_location.dart';
import 'package:vpn/widgets/vpn_location_card_widget.dart';

class AvaliableVpnServerLocationScreen extends StatelessWidget {
  AvaliableVpnServerLocationScreen({super.key});

  final vpnLocationController = ControllerVpnLocation();
  loadingWidget() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Gathering Free VPN Locations',
            style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  noVpnServerFoundUIWidget() {
    return Center(
        child: Text(
      'No VPNs Found, Try Again',
      style: TextStyle(
          fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold),
    ));
  }

  vpnAvaliableServerData() {
    return ListView.builder(
        itemCount: vpnLocationController.vpnFreeServersAvaliableList.length,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(3),
        itemBuilder: (context, index) {
          return VpnLocationCardWidget(
              vpnInfo:
                  vpnLocationController.vpnFreeServersAvaliableList[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    if (vpnLocationController.vpnFreeServersAvaliableList.isEmpty) {
      vpnLocationController.retrieveVpnInformation();
    }
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text('Vpn Location (' +
                vpnLocationController.vpnFreeServersAvaliableList.length
                    .toString() +
                ")"),
          ),

          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10),
            child: FloatingActionButton(
              onPressed: () {
                vpnLocationController.retrieveVpnInformation();
              },
              child: Icon(
                CupertinoIcons.refresh_circled,
                size: 40,
              ),
              backgroundColor: Colors.redAccent,
            ),
          ),
          body: vpnLocationController.isLoadingNewLocations.value
              ? loadingWidget()
              : vpnLocationController.vpnFreeServersAvaliableList.isEmpty
                  ? noVpnServerFoundUIWidget()
                  : vpnAvaliableServerData(),

          // vpnLocationController.isLoadingNewLocations.value
          //     ? loadingWidget
          //     : vpnLocationController.vpnFreeServersAvaliableList.isEmpty
          //         ? noVpnServerFoundUIWidget
          //         : vpnAvaliableServerData,
        ));
  }
}
