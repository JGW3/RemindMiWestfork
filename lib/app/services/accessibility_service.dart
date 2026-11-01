import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Per-phone accessibility settings. Kept in their own storage box so signing
// out (which erases the default box) doesn't reset them.
class AccessibilityService extends GetxController {
  static const boxName = 'accessibility';
  static AccessibilityService get to => Get.find();

  final _box = GetStorage(boxName);
  final _tts = FlutterTts();

  late final bold = RxBool(_box.read('bold') ?? false);
  late final textScale = RxDouble(
    (_box.read('textScale') as num?)?.toDouble() ?? 1.0,
  );
  late final readAloud = RxBool(_box.read('readAloud') ?? false);

  void setBold(bool value) => _box.write('bold', bold.value = value);
  void setTextScale(double value) =>
      _box.write('textScale', textScale.value = value);
  void setReadAloud(bool value) {
    _box.write('readAloud', readAloud.value = value);
    if (!value) _tts.stop();
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.setSpeechRate(0.45); // a little slower than default
    await _tts.speak(text);
  }

  // Applies bold text and text size to the whole app (GetMaterialApp.builder).
  static Widget apply(BuildContext context, Widget? child) => Obx(() {
    final settings = to;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        boldText: settings.bold.value,
        textScaler: TextScaler.linear(settings.textScale.value),
      ),
      child: child ?? SizedBox.shrink(),
    );
  });
}

// Speaker button that reads a task aloud; hidden unless Read aloud is on.
class ReadAloudButton extends StatelessWidget {
  final String text;

  const ReadAloudButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Obx(
    () => AccessibilityService.to.readAloud.value
        ? IconButton(
            tooltip: 'Read aloud',
            icon: Icon(
              Icons.volume_up,
              color: Color.fromARGB(255, 24, 90, 219),
            ),
            onPressed: () => AccessibilityService.to.speak(text),
          )
        : SizedBox.shrink(),
  );
}
