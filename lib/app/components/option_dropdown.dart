import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Dropdown bound to an Rx value, styled like the task form's priority picker.
class OptionDropdown<T> extends StatelessWidget {
  final Rx<T> value;
  final Map<T, String> options;

  const OptionDropdown({Key? key, required this.value, required this.options})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: DropdownButton<T>(
          borderRadius: BorderRadius.circular(8.0),
          iconEnabledColor: Color.fromARGB(255, 101, 152, 254),
          underline: SizedBox(),
          isExpanded: true,
          // A stored value that isn't offered any more falls back to the first option
          value: options.containsKey(value.value)
              ? value.value
              : options.keys.first,
          items: [
            for (final option in options.entries)
              DropdownMenuItem(
                value: option.key,
                child: Text(
                  '    ' + option.value,
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
          onChanged: (newValue) {
            if (newValue != null) value.value = newValue;
          },
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 101, 152, 254)),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
