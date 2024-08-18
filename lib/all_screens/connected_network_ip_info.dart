import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn/api_vpn_get/api_vpn_get.dart';
import 'package:vpn/model/ip_info.dart';
import 'package:vpn/model/network_ip_info.dart';
import 'package:vpn/widgets/network_ip_info_widget.dart';

class ConnectedNetworkIpInfoScreen extends StatelessWidget {
  const ConnectedNetworkIpInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ipInfo = IpInfo.fromJson({}).obs;
    ApiVpnGate.retrieveIPDetails(ipInformation: ipInfo);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Connected Network IP Information",
          style: TextStyle(fontSize: 14),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () {
            ipInfo.value = IpInfo.fromJson({});
            ApiVpnGate.retrieveIPDetails(ipInformation: ipInfo);
          },
          child: Icon(CupertinoIcons.refresh),
        ),
      ),
      body: Obx(() => ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(3),
            children: [
              //ip address
              NetworkIpInfoWidget(
                  networkIpInfo: NetworkIpInfo(
                      titleText: 'IP Address',
                      subTitleText: ipInfo.value.query,
                      iconData: Icon(
                        Icons.my_location_outlined,
                        color: Colors.redAccent,
                      ))),

              //isp
              NetworkIpInfoWidget(
                  networkIpInfo: NetworkIpInfo(
                      titleText: 'Internet Service Provider',
                      subTitleText: ipInfo.value.internetServiceProvider,
                      iconData: Icon(
                        Icons.account_tree,
                        color: Colors.deepOrange,
                      ))),
              //location
              NetworkIpInfoWidget(
                  networkIpInfo: NetworkIpInfo(
                      titleText: 'Location',
                      subTitleText: ipInfo.value.countryName.isEmpty
                          ? "Retrieving.."
                          : "${ipInfo.value.cityName}, ${ipInfo.value.regionName}, ${ipInfo.value.countryName}",
                      iconData: Icon(
                        CupertinoIcons.location_solid,
                        color: Colors.green,
                      ))),

              //zip code
              NetworkIpInfoWidget(
                  networkIpInfo: NetworkIpInfo(
                      titleText: 'Zip Code',
                      subTitleText: ipInfo.value.zipCode,
                      iconData: Icon(
                        CupertinoIcons.map_pin_ellipse,
                        color: Colors.pinkAccent,
                      ))),

              //timw zone

              NetworkIpInfoWidget(
                  networkIpInfo: NetworkIpInfo(
                      titleText: 'Time Zone',
                      subTitleText: ipInfo.value.timezone,
                      iconData: Icon(
                        Icons.share_arrival_time_outlined,
                        color: Colors.cyan,
                      ))),
            ],
          )),
    );
  }
}
