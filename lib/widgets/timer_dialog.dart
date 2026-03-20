import 'package:flutter/material.dart';

import '../constants/type_clock.dart';

class TimerDialog extends StatefulWidget {
  const TimerDialog({super.key});

  @override
  State<TimerDialog> createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {
  String mode = "LED_ON";
  TimeOfDay time = const TimeOfDay(hour: 0, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// TITLE
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hẹn giờ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            /// DROPDOWN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Loại hẹn giờ"),
                DropdownButton<String>(
                  value: mode,
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(12),
                  items: itemValues.keys
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(itemValues[e]!),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => mode = v!),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// TIME PICKER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Chọn thời gian"),
                GestureDetector(
                  onTap: setTimePicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      time.format(context),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Huỷ"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, {"mode": mode, "time": time});
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void setTimePicker() async {
    final newTime = await showTimePicker(context: context, initialTime: time);

    if (newTime != null) {
      setState(() => time = newTime);
    }
  }
}
