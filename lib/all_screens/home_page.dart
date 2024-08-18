// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn/all_screens/avaliable_vpn_server_location_screen.dart';
import 'package:vpn/all_screens/connected_network_ip_info.dart';
import 'package:vpn/app_prefrences/app_prefrences.dart';
import 'package:vpn/controller/controller_home.dart';
import 'package:vpn/main.dart';
import 'package:vpn/model/vpn_status.dart';
import 'package:vpn/vpn_engine/vpn_engine.dart';
import 'package:vpn/widgets/custom_widget.dart';
import 'package:vpn/widgets/timer_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final homeController = Get.put(ControllerHome());
  localSectionBottomNavigationBar() {
    return SafeArea(
        child: Semantics(
      button: true,
      child: InkWell(
        onTap: () {
          Get.to(() => AvaliableVpnServerLocationScreen());
        },
        child: Container(
          color: Colors.redAccent,
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.041),
          height: 62,
          child: Row(
            children: [
              Icon(
                CupertinoIcons.flag_circle,
                color: Colors.white,
                size: 36,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Select Country / Location',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.redAccent,
                  size: 26,
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget vpnRoundButton() {
    return Column(
      children: [
        //vpn button
        Semantics(
          button: true,
          child: InkWell(
            onTap: () {
              homeController.connectToVpnNow();
            },
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //color
                color: homeController.getRoundButtonColor.withOpacity(.1),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //color
                  color: homeController.getRoundButtonColor.withOpacity(.3),
                ),
                child: Container(
                  height: screenSize.height * .14,
                  width: screenSize.height * .14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    //color
                    color: homeController.getRoundButtonColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        homeController.getRoundedButtonText,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        //status of connection

        Container(
          margin: EdgeInsets.only(
              top: screenSize.height * .015, bottom: screenSize.height * .02),
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          decoration: BoxDecoration(
              color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
          child: Text(
            homeController.vpnConnectionState.value ==
                    VpnEngine.vpnDisconnectedNow
                ? "Not Connected"
                : homeController.vpnConnectionState
                    .replaceAll('_', " ")
                    .toUpperCase(),
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
        //timer
        Obx(() => TimerWidget(
            initTimeNow: homeController.vpnConnectionState.value ==
                VpnEngine.vpnConnectedNow))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    VpnEngine.snapshotVpnStage().listen((event) {
      homeController.vpnConnectionState.value = event;
    });
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Free Vpn'),
        leading: IconButton(
            onPressed: () {
              Get.to(() => ConnectedNetworkIpInfoScreen());
            },
            icon: Icon(Icons.perm_device_info)),
        actions: [
          IconButton(
              onPressed: () {
                Get.changeThemeMode(AppPrefrences.isModeDark
                    ? ThemeMode.light
                    : ThemeMode.dark);

                AppPrefrences.isModeDark = !AppPrefrences.isModeDark;
              },
              icon: Icon(Icons.brightness_2_outlined)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomWidget(
                    titleText:
                        homeController.vpnInfo.value.countryLongName.isEmpty
                            ? 'Location'
                            : homeController.vpnInfo.value.countryLongName,
                    subTitleText: 'FREE',
                    roundWidgetWithIcon: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.redAccent,
                      child:
                          homeController.vpnInfo.value.countryLongName.isEmpty
                              ? Icon(
                                  Icons.flag_circle,
                                  size: 30,
                                  color: Colors.white,
                                )
                              : null,
                      backgroundImage: homeController
                              .vpnInfo.value.countryLongName.isEmpty
                          ? null
                          : AssetImage(
                              'countryFlags/${homeController.vpnInfo.value.countryShortName.toLowerCase()}.png'),
                    )),
                CustomWidget(
                    titleText:
                        homeController.vpnInfo.value.countryLongName.isEmpty
                            ? '60 ms'
                            : '${homeController.vpnInfo.value.ping} ms',
                    subTitleText: 'PING',
                    roundWidgetWithIcon: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.black54,
                      child: Icon(
                        Icons.graphic_eq,
                        size: 30,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
          Obx(
            () => vpnRoundButton(),
          ),
          StreamBuilder<VpnStatus?>(
              initialData: VpnStatus(),
              stream: VpnEngine.snapshotVpnStatus(),
              builder: (context, dataSnapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomWidget(
                        titleText: "${dataSnapshot.data?.byteIn ?? '0 kbps'}",
                        subTitleText: 'DOWNLOAD',
                        roundWidgetWithIcon: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.arrow_circle_down,
                            size: 30,
                            color: Colors.white,
                          ),
                        )),
                    CustomWidget(
                        titleText: "${dataSnapshot.data?.byteOut ?? '0 kbps'}",
                        subTitleText: 'UPLOAD',
                        roundWidgetWithIcon: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.pinkAccent,
                          child: Icon(
                            Icons.arrow_circle_up_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        )),
                  ],
                );
              }),
        ],
      ),
      bottomNavigationBar: localSectionBottomNavigationBar(),
    );
  }
}
