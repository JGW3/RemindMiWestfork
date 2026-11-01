import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndCondtions extends StatelessWidget {
  const TermsAndCondtions({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 18),
          Container(
            child: Text(
              'Terms & Conditons',
              style: GoogleFonts.dmSans(
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 5, 16, 0),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'This application agreement, hereafter referred to as “Agreement”, is the agreement between the development team and the user with respect to use of the application (“Software”). This software is developed by Nikhil Adhikari, Daniel Derheim, Bishnu Sharma, and John West. The development team will hereafter be referred to as the “Team”',
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                      textAlign: TextAlign.justify,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Grant of License ',
                        style: GoogleFonts.dmSans(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Subject to your compliance with the terms and conditions set forth within this agreement, the Team grants you a limited, non-exclusive, non-transferable license to install and use one copy of the Software on your mobile device for the sole purpose of accessing using the capabilities and services enabled via the Software. ',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Restrictions on Use  ',
                        style: GoogleFonts.dmSans(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'You may not: (i) copy, modify, translate, reverse engineer, decompile or disassemble the Software or create derivative works based thereon; (ii) install the Software onto a server so that it is accessible via a public network; (iii) share or permit other individuals/entities to use the Software, rent, lease or transfer the Software or rights to use it; or (iv) delete or modify any attributions, legal notices or other proprietary designations in the Software or part thereof. Any such forbidden use shall immediately and automatically terminate your license to use the Software, without derogating from any other remedies available to the Team at law or in equity. ',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Title and Ownership   ',
                        style: GoogleFonts.dmSans(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'The Software and any revisions, modifications, enhancements and/or derivatives of it are owned by the Team and/or its licensors.',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Compliance with the Law   ',
                        style: GoogleFonts.dmSans(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'The Software is intended for use only in compliance with the law. You undertake to use the Software in accordance with all applicable laws, including all applicable export laws, restrictions and regulations and agree that you will not export, or allow the export or re-export of the Software in violation of any such laws, restrictions and/or regulations. ',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Limitation of Liability  ',
                        style: GoogleFonts.dmSans(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Under no circumstances shall the Team be liable to you or any other person for any indirect, special, incidental, or consequential damages of any type including, without limitation, damages for loss of goodwill, business interruption, device failure or malfunction, loss of business profits, loss of data or business or financial information, procurement of substitute goods or services or any and all other commercial damages or losses. In no event shall the Team liability to you or any third party for any loss or damages exceed the amount paid by you to the Team for use of the software, even if the Team had been informed of the possibility of such damages, or for any claim by any other party. ',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Termination',
                        style: GoogleFonts.dmSans(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Your right to use this Software, as well as this Agreement, terminates if you fail to comply with any part of this License Agreement. The Team may terminate this Agreement at any time. You may terminate this license at any time by stopping your use of and uninstalling the Software. ',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 28),
        ],
      ),
    );
  }
}
