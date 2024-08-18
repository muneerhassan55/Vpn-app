import 'dart:convert';

class VpnStatus {
  String? byteIn;
  String? byteOut;
  String? durationTime;
  String? lastPacketRecieve;

  VpnStatus({
    this.byteIn,
    this.byteOut,
    this.durationTime,
    this.lastPacketRecieve,
  });

  factory VpnStatus.fromJson(Map<String, dynamic> jsonData) => VpnStatus(
        byteIn: jsonData['byte_in'],
        byteOut: jsonData['byte_out'],
        durationTime: jsonData['duration'],
        lastPacketRecieve: jsonData['last_packet_recieve'],
      );
  Map<String, dynamic> toJson() => {
        'byte_in': byteIn,
        'byte_out': byteOut,
        'duration': durationTime,
        'last_packet_recieve': lastPacketRecieve,
      };
}
