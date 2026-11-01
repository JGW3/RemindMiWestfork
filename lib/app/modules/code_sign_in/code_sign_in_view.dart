import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:remindmi/app/components/child_options_sheet.dart';
import 'package:remindmi/app/helper/session.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';

// Child's phone: scan the parent's QR code or type the 8-character code.
class CodeSignInView extends StatefulWidget {
  const CodeSignInView({super.key});

  @override
  State<CodeSignInView> createState() => _CodeSignInViewState();
}

class _CodeSignInViewState extends State<CodeSignInView> {
  final typed = TextEditingController();
  bool busy = false;
  bool scanning = true;

  Future<void> redeem(String code) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('redeemSignInCode')
          .call({'code': code});
      await FirebaseAuth.instance.signInWithCustomToken(result.data['token']);
      await completeSignIn();
    } catch (e) {
      showCustomSnackBar(functionError(e), title: 'Sign in');
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Sign in with a code',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text(
            'Ask your parent to open RemindMi → Manage → Add Dependent, tap you, '
            'and choose "Sign in a phone".',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          if (scanning)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 280,
                child: MobileScanner(
                  onDetect: (capture) {
                    final value = capture.barcodes.firstOrNull?.rawValue;
                    if (value != null && value.startsWith('remindmi:')) {
                      setState(() => scanning = false);
                      redeem(value);
                    }
                  },
                  errorBuilder: (context, error) => Center(
                    child: Text('Camera unavailable. Type the code below.'),
                  ),
                ),
              ),
            ),
          SizedBox(height: 24),
          TextField(
            controller: typed,
            textCapitalization: TextCapitalization.characters,
            style: GoogleFonts.robotoMono(fontSize: 24, letterSpacing: 2),
            decoration: InputDecoration(
              labelText: 'Or type the code',
              hintText: 'ABCD-1234',
              border: OutlineInputBorder(),
            ),
            onSubmitted: redeem,
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: busy ? null : () => redeem(typed.text),
              child: busy ? CircularProgressIndicator() : Text('Sign in'),
            ),
          ),
        ],
      ),
    );
  }
}
