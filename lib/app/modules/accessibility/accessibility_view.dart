import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindmi/app/services/accessibility_service.dart';

class AccessibilityView extends StatelessWidget {
  const AccessibilityView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AccessibilityService.to;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Accessibility',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(
        () => ListView(
          children: [
            SwitchListTile(
              title: Text('Bold text'),
              value: settings.bold.value,
              onChanged: settings.setBold,
            ),
            ListTile(
              title: Text('Text size'),
              subtitle: Slider(
                value: settings.textScale.value,
                min: 0.9,
                max: 1.6,
                divisions: 7,
                label: '${(settings.textScale.value * 100).round()}%',
                onChanged: settings.setTextScale,
              ),
            ),
            SwitchListTile(
              title: Text('Read aloud'),
              subtitle: Text(
                'Shows a speaker button on tasks that reads them out',
              ),
              value: settings.readAloud.value,
              onChanged: settings.setReadAloud,
            ),
            if (settings.readAloud.value)
              ListTile(
                leading: Icon(Icons.volume_up),
                title: Text('Try it'),
                onTap: () => settings.speak(
                  'Hi! This is how RemindMi reads your tasks out loud.',
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'These settings are saved on this phone.',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
