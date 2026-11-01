import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:remindmi/app/components/child_options_sheet.dart';

// Parent's phone: shows a one-time QR code / 8-character code that signs a
// child's phone into the child's account (functions/signin.js).
class SignInCodeView extends StatefulWidget {
  final String childUid;
  final String name;

  const SignInCodeView({super.key, required this.childUid, required this.name});

  @override
  State<SignInCodeView> createState() => _SignInCodeViewState();
}

class _SignInCodeViewState extends State<SignInCodeView> {
  String? code;
  DateTime? expiresAt;
  String? error;
  Timer? ticker;

  @override
  void initState() {
    super.initState();
    newCode();
    // Redraw the countdown every second
    ticker = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    ticker?.cancel();
    super.dispose();
  }

  Future<void> newCode() async {
    setState(() {
      code = null;
      error = null;
    });
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('createSignInCode')
          .call({'childUid': widget.childUid});
      setState(() {
        code = result.data['code'];
        expiresAt = DateTime.fromMillisecondsSinceEpoch(
          result.data['expiresAt'],
        );
      });
    } catch (e) {
      setState(() => error = functionError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final left = expiresAt?.difference(DateTime.now());
    final expired = left != null && left.isNegative;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Sign in ${widget.name}\'s phone',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text(
            'On ${widget.name}\'s phone, open RemindMi, tap "Sign in with a code", '
            'and scan this or type the code.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          if (error != null)
            Text(error!, style: TextStyle(color: Colors.red, fontSize: 16))
          else if (code == null)
            Center(child: CircularProgressIndicator())
          else ...[
            Center(
              child: Opacity(
                opacity: expired ? 0.2 : 1,
                child: QrImageView(data: 'remindmi:$code', size: 240),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: SelectableText(
                '${code!.substring(0, 4)}-${code!.substring(4)}',
                style: GoogleFonts.robotoMono(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                expired
                    ? 'Expired'
                    : 'Works once · expires in ${left!.inMinutes}:${(left.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ],
          SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: newCode,
            icon: Icon(Icons.refresh),
            label: Text('New code'),
          ),
        ],
      ),
    );
  }
}
