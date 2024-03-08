import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../referralcode/referral_code.dart';
import 'login.dart';

class AggreementPage extends StatefulWidget {
  const AggreementPage({Key? key}) : super(key: key);

  @override
  State<AggreementPage> createState() => _AggreementPageState();
}

class _AggreementPageState extends State<AggreementPage> {
  //navigate
  navigate() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Referral()),
        (route) => false);
  }

  bool ischeck = false;
  // ignore: unused_field
  String _error = '';
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      color: page,
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: media.height * 0.01,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: MyText(
                      text: languages[choosenLanguage]['text_accept_head'],
                      size: media.width * twenty,
                      fontweight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: media.width * 0.416,
                    width: media.width * 0.416,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/privacyimage.png'),
                            fit: BoxFit.contain)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: media.width * 0.9,
                      child: RichText(
                        text: TextSpan(
                          // text: 'Hello ',
                          style: GoogleFonts.notoSans(
                            color: textColor,
                            fontSize: media.width * fourteen,
                          ),
                          children: [
                            TextSpan(
                                text: languages[choosenLanguage]
                                    ['text_agree_text1']),
                            TextSpan(
                                text: languages[choosenLanguage]
                                    ['text_terms_of_use'],
                                style: GoogleFonts.notoSans(
                                  color: buttonColor,
                                  fontSize: media.width * fourteen,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    openBrowser(
                                        'your terms and condition url here');
                                  }),
                            TextSpan(
                                text: languages[choosenLanguage]
                                    ['text_agree_text2']),
                            TextSpan(
                                text: languages[choosenLanguage]
                                    ['text_privacy'],
                                style: GoogleFonts.notoSans(
                                  color: buttonColor,
                                  fontSize: media.width * fourteen,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    openBrowser('your privacy policy url here');
                                  }),
                          ],
                        ),
                      )),
                  Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      children: [
                        MyText(
                            text: languages[choosenLanguage]['text_iagree'],
                            size: media.width * sixteen),
                        SizedBox(
                          width: media.width * 0.05,
                        ),
                        InkWell(
                          onTap: () {
                            if (ischeck == false) {
                              setState(() {
                                ischeck = true;
                              });
                            } else {
                              setState(() {
                                ischeck = false;
                              });
                            }
                          },
                          child: Container(
                            height: media.width * 0.05,
                            width: media.width * 0.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: buttonColor, width: 2)),
                            child: ischeck == false
                                ? null
                                : Icon(
                                    Icons.done,
                                    size: media.width * 0.04,
                                    color: buttonColor,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            (_error != '')
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: _error,
                        size: media.width * fourteen,
                        color: verifyDeclined,
                      ),
                    ],
                  )
                : Container(),
            (ischeck == true)
                ? Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Button(
                        onTap: () async {
                          loginLoading = true;
                          _error = '';
                          valueNotifierLogin.incrementNotifier();
                          var register = await registerUser();
                          if (register == 'true') {
                            //referral page
                            navigate();
                          } else {
                            setState(() {
                              _error = register.toString();
                            });
                          }
                          loginLoading = false;
                          valueNotifierLogin.incrementNotifier();
                        },
                        text: languages[choosenLanguage]['text_next']),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Button(
                        onTap: () async {},
                        text: languages[choosenLanguage]['text_next'],
                        color: Colors.grey,
                        textcolor: textColor.withOpacity(0.5)),
                  )
          ],
        ),
      ),
    );
  }
}
