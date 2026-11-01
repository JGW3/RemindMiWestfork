import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Minutes before the due time for the early reminder; 0 = only at due time
const remindBeforeOptions = {
  0: 'Remind at due time',
  5: 'Remind 5 min before',
  15: 'Remind 15 min before',
  30: 'Remind 30 min before',
  60: 'Remind 1 hour before',
};

class RemindBeforeDropdown extends StatelessWidget {
  final RxInt value;

  const RemindBeforeDropdown({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: DropdownButton<int>(
          borderRadius: BorderRadius.circular(8.0),
          iconEnabledColor: Color.fromARGB(255, 101, 152, 254),
          underline: SizedBox(),
          isExpanded: true,
          // Tasks saved with a value not in the list fall back to "at due time"
          value: remindBeforeOptions.containsKey(value.value) ? value.value : 0,
          items: [
            for (final option in remindBeforeOptions.entries)
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
          onChanged: (newValue) => value.value = newValue ?? 0,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 101, 152, 254)),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
