import 'dart:convert';

import 'package:base_provider/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum KeySwitch { led, watter }

class HomeController extends BaseController {
  bool isConnectEsp32 = false;
  bool isOnLed = false;
  bool isOnWatter = false;
  bool isAuto = false;
  List autoOnOff = [];
  late WebSocketChannel channel;

  @override
  void onInit({payload}) {
    connectedToESP32();
    super.onInit();
  }

  void switchButton({required KeySwitch key, required bool value}) async {
    try {
      if (!isConnectEsp32) {
        return;
      }
      setLoading(true);
      switch (key) {
        case KeySwitch.led:
          {
            isOnLed = value;
            channel.sink.add(jsonEncode({"type": "LED", "value": value}));
          }
        case KeySwitch.watter:
          {
            isOnWatter = value;
            channel.sink.add(jsonEncode({"type": "WATTER", "value": value}));
          }
      }
      setLoading(false);
    } catch (e) {
      setLoading(false);
    }
  }

  void changeAuto(bool value) {
    isAuto = value;
    channel.sink.add(jsonEncode({"type": "set_auto", "value": value}));
  }

  void handleMessage(String mess) {
    Log.d(mess);

    final data = jsonDecode(mess);
    if (data['type'] == 'state') {
      isOnLed = data['light'] == 1;
      isOnWatter = data['watter'] == 1;
      isAuto = data['auto'] == 1;
    }
    if (data['type'] == 'timers') {
      List timers = data["data"];

      autoOnOff = timers.map<Map<String, dynamic>>((e) {
        return {
          "mode": e["mode"],
          "time": TimeOfDay(hour: e["hour"], minute: e["minute"]),
        };
      }).toList();
    }

    notify();
    Log.d(isOnLed.toString());
  }

  void sendTime() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    channel.sink.add(jsonEncode({"type": "set_time", "ts": now}));
  }

  Future<void> connectedToESP32() async {
    setLoading(true);
    final info = NetworkInfo();
    String? ssid = await info.getWifiIP();
    Log.d("SSID: $ssid");

    setLoading(false);
    if (ssid == null) {
      isConnectEsp32 = false;
    }

    isConnectEsp32 = ssid?.contains("192.168.4") ?? false;
    if (isConnectEsp32) {
      channel = WebSocketChannel.connect(Uri.parse('ws://192.168.4.1:81'));
      channel.stream.listen((message) {
        handleMessage(message);
      });
      channel.sink.add(jsonEncode({"type": "get_state"}));
      channel.sink.add(jsonEncode({"type": "get_timers"}));
      sendTime();
    }
  }

  void addToListAuto(Map<String, Object> data) {
    autoOnOff.add(data);
    sendTimersToESP32();
    notify();
  }

  void sendTimersToESP32() {
    if (!isConnectEsp32) {
      return;
    }
    List timers = autoOnOff.map((e) {
      final time = e['time'];

      return {"mode": e['mode'], "hour": time.hour, "minute": time.minute};
    }).toList();

    final data = {"type": "set_timers", "data": timers};

    channel.sink.add(jsonEncode(data));
  }

  void removeTimer(int index) {
    autoOnOff.removeAt(index);
    notify();
    sendTimersToESP32();
  }

  @override
  void dispose() {
    channel.sink.close();
    autoOnOff = [];
    super.dispose();
  }
}
