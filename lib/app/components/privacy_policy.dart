import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 18),
          Container(
            child: Text(
              'Privacy Policy',
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
                      'RemindMi Developers built the RemindMi app as a Free app. This SERVICE is provided by RemindMi Developers at no cost and is intended for use as is. \n\n'
                      'This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.\n\n'
                      'If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.\n\n'
                      'The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at RemindMi unless otherwise defined in this Privacy Policy.\n\n',
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                      textAlign: TextAlign.justify,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Information Collection and Use',
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
                        'For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to name, email address. The information that we request will be retained by us and used as described in this privacy policy.\n\n'
                        'The app does use third party services that may collect information used to identify you.\n\n'
                        'Link to privacy policy of third party service providers used by the app\n\n'
                        '•	Google Play Services\n'
                        '•	Firebase Analytics',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Log Data  ',
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
                        'We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cookies   ',
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
                        'Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. '
                        'These are sent to your browser from the websites that you visit and are stored on your device\'s internal memory.\n'
                        'This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries '
                        'that use “cookies” to collect information and improve their services. You have the option to either accept or refuse '
                        'these cookies and know when a cookie is being sent to your device. '
                        'If you choose to refuse our cookies, you may not be able to use some portions of this Service.',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Service Providers   ',
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
                        'We may employ third-party companies and individuals due to the following reasons:\n'
                        '•	To facilitate our Service;\n'
                        '•	To provide the Service on our behalf;\n'
                        '•	To perform Service-related services; or\n'
                        '•	To assist us in analyzing how our Service is used.\n'
                        'We want to inform users of this Service that these third parties have access to your Personal Information.'
                        'The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose '
                        'or use the information for any other purpose.',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Security  ',
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
                        'We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Children’s Privacy',
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
                        'These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Changes to This Privacy Policy',
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
                        'We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Contact Us',
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
                        'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at remindmiapp@gmail.com',
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
