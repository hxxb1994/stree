import 'package:base_provider/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:water_mana/constants/type_clock.dart';

import '../../widgets/timer_dialog.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseView<HomePage, HomeController> {
  @override
  Widget buildContent(BuildContext context, HomeController controller) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: const Center(
          child: Text('Trang chủ', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: controller.isConnectEsp32 ? connectedWifi() : noConnectWifi(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: controller.connectedToESP32,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget noConnectWifi() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Text(
          textAlign: TextAlign.center,
          'Chưa kết nối wifi, vui lòng kết nối wifi và thử lại!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget connectedWifi() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 32),
      child: Column(
        children: [
          Row(spacing: 16, children: [toggleButtonLed(), toggleButtonWatter()]),
          const SizedBox(height: 16),
          settingAuto(),
        ],
      ),
    );
  }

  Widget buildDeviceCard({
    required String image,
    required String title,
    required bool value,
    required Function(bool) onToggle,
  }) {
    return Expanded(
      child: Container(
        height: 260,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.teal[700],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(child: Image.asset(image)),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),

            const SizedBox(height: 10),

            FlutterSwitch(
              width: 60,
              height: 30,
              value: value,
              activeColor: Colors.greenAccent,
              onToggle: onToggle,
            ),
          ],
        ),
      ),
    );
  }

  Widget toggleButtonLed() {
    return buildDeviceCard(
      image: 'assets/images/lamp.png',
      title: controller.isOnLed ? 'Đèn đang bật' : 'Đèn đang tắt',
      value: controller.isOnLed,
      onToggle: (val) {
        controller.switchButton(key: KeySwitch.led, value: val);
      },
    );
  }

  Widget toggleButtonWatter() {
    return buildDeviceCard(
      image: 'assets/images/watter.png',
      title: controller.isOnWatter ? 'Nước đang bật' : 'Nước đang tắt',
      value: controller.isOnWatter,
      onToggle: (val) {
        controller.switchButton(key: KeySwitch.watter, value: val);
      },
    );
  }

  Widget settingAuto() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[700],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Cài đặt',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),

          const SizedBox(height: 16),

          /// AUTO SWITCH
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tự động cảm ứng",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              FlutterSwitch(
                width: 60,
                height: 30,
                value: controller.isAuto,
                onToggle: (val) {
                  controller.changeAuto(val);
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// TIMER HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Hẹn giờ",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              if (controller.autoOnOff.length <= 3)
                IconButton(
                  onPressed: openDialog,
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
            ],
          ),

          const SizedBox(height: 8),

          ...buildList(),
        ],
      ),
    );
  }

  List<Widget> buildList() {
    return List.generate(controller.autoOnOff.length, (index) {
      final e = controller.autoOnOff[index];

      return Dismissible(
        key: Key(index.toString()),
        direction: DismissDirection.endToStart,

        /// nền khi swipe
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete, color: Colors.white),
        ),

        confirmDismiss: (_) async {
          return await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Xoá hẹn giờ?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Huỷ"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                    controller.removeTimer(index);
                  },
                  child: Text("Xoá"),
                ),
              ],
            ),
          );
        },

        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemValues[e['mode']]!,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                e['time'].format(context),
                style: const TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> openDialog() async {
    final result = await showDialog<Map<String, Object>>(
      context: context,
      builder: (_) => TimerDialog(),
    );

    if (result != null) {
      controller.addToListAuto(result);
    }
  }
}
