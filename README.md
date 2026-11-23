# VPN App

A Flutter VPN client that loads free public servers, lets the user pick a country and connects through a native VPN engine over platform channels.

## Features

- Server list from the VPN Gate public API, parsed from CSV
- Server locations with country flags, speed and session count
- One-tap connect and disconnect, with live connection stage and status from native event channels
- Connection timer
- Current IP, location and ISP details from ip-api.com
- Selected server and settings saved locally with Hive
- GetX for state management

## Tech stack

Flutter · Dart · GetX · Hive · http · csv · Platform channels (MethodChannel / EventChannel)

## How it works

```
VPN Gate API ──csv──▶ VpnInfo list ──▶ location screen
                                         │ user picks a server
                                         ▼
           Flutter ── MethodChannel("vpnControl") ──▶ native VPN engine
           Flutter ◀── EventChannel("vpnStage" / "vpnStatus") ──
```

## Project structure

```
lib/
  api_vpn_get/      VPN Gate and IP info API calls
  vpn_engine/       platform channel bridge to the native VPN engine
  controller/       GetX controllers for home and server locations
  model/            server, IP info, configuration and status models
  all_screens/      home, server location and network info screens
  app_prefrences/   Hive-backed local preferences
countryFlags/       flag images
```

## Getting started

```bash
flutter pub get
flutter run
```

Run on a real Android device to test the VPN connection.

## License

Released under the [MIT License](LICENSE).
