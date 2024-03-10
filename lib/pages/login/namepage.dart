// import 'dart:async';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import 'login.dart';

String name = ''; //name of user

class NamePage extends StatefulWidget {
  const NamePage({Key? key}) : super(key: key);

  @override
  State<NamePage> createState() => _NamePageState();
}

bool isverifyemail = false;
String email = ''; // email of user
String _error = '';

class _NamePageState extends State<NamePage> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController emailtext = TextEditingController();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    profilepicturecontroller = StreamController.broadcast();
    proImageFile = null;
    _error = '';

    if (isLoginemail == true) {
      emailtext.text = email;
    }
    super.initState();
  }

  showToast() {
    setState(() {
      showtoast = true;
    });
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        showtoast = false;
      });
    });
  }

  bool showtoast = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      color: page,
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Scaffold(
                    backgroundColor: page,
                    body: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: media.height * 0.02),
                          StreamBuilder(
                              stream: profilepicturestream,
                              builder: (context, snapshot) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        pickImage = true;
                                        valueNotifierLogin.incrementNotifier();
                                      },
                                      child: Stack(
                                        children: [
                                          ShowUp(
                                            delay: 100,
                                            child: Container(
                                              height: media.width * 0.3,
                                              width: media.width * 0.3,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: page,
                                                  image: (proImageFile == null)
                                                      ? const DecorationImage(
                                                          image: AssetImage(
                                                            'assets/images/profile.png',
                                                          ),
                                                          fit: BoxFit.cover)
                                                      : DecorationImage(
                                                          image: FileImage(File(
                                                              proImageFile)),
                                                          fit: BoxFit.cover)),
                                            ),
                                          ),
                                          Positioned(
                                              right: media.width * 0.04,
                                              bottom: media.width * 0.02,
                                              child: Container(
                                                height: media.width * 0.05,
                                                width: media.width * 0.05,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xff898989)),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: topBar,
                                                  size: media.width * 0.04,
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          SizedBox(
                            height: media.width * 0.04,
                          ),
                          MyText(
                            text: languages[choosenLanguage]['text_your_name'],
                            size: media.width * twenty,
                            fontweight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: media.width * 0.9,
                            child: MyText(
                              text: languages[choosenLanguage]
                                  ['text_prob_name'],
                              size: media.width * twelve,
                              color: textColor.withOpacity(0.5),
                              fontweight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    height: media.width * 0.13,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: textColor),
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: MyTextField(
                                        textController: firstname,
                                        hinttext: languages[choosenLanguage]
                                            ['text_first_name'],
                                        onTap: (val) {
                                          setState(() {});
                                        })),
                              ),
                              SizedBox(
                                width: media.height * 0.02,
                              ),
                              Expanded(
                                child: Container(
                                    height: media.width * 0.13,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: textColor),
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: MyTextField(
                                      hinttext: languages[choosenLanguage]
                                          ['text_last_name'],
                                      textController: lastname,
                                      onTap: (val) {
                                        setState(() {});
                                      },
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: media.height * 0.02,
                          ),
                          Container(
                              height: media.width * 0.13,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: textColor),
                              ),
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: MyTextField(
                                textController: emailtext,
                                readonly:
                                    (isfromomobile == false) ? true : false,
                                hinttext: languages[choosenLanguage]
                                    ['text_enter_email'],
                                onTap: (val) {
                                  setState(() {});
                                },
                              )),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          (isfromomobile == false)
                              ? Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  height: 55,
                                  width: media.width * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: textColor),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (countries.isNotEmpty) {
                                            //dialod box for select country for dial code
                                            await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  var searchVal = '';
                                                  return AlertDialog(
                                                    backgroundColor: page,
                                                    insetPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    content: StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return Container(
                                                        width:
                                                            media.width * 0.9,
                                                        color: page,
                                                        child: Directionality(
                                                          textDirection:
                                                              (languageDirection ==
                                                                      'rtl')
                                                                  ? TextDirection
                                                                      .rtl
                                                                  : TextDirection
                                                                      .ltr,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                height: 40,
                                                                width: media
                                                                        .width *
                                                                    0.9,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1.5)),
                                                                child:
                                                                    TextField(
                                                                  decoration: InputDecoration(
                                                                      contentPadding: (languageDirection ==
                                                                              'rtl')
                                                                          ? EdgeInsets.only(
                                                                              bottom: media.width *
                                                                                  0.035)
                                                                          : EdgeInsets.only(
                                                                              bottom: media.width *
                                                                                  0.04),
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          languages[choosenLanguage][
                                                                              'text_search'],
                                                                      hintStyle: GoogleFonts.notoSans(
                                                                          fontSize: media.width *
                                                                              sixteen,
                                                                          color:
                                                                              hintColor)),
                                                                  style: GoogleFonts.notoSans(
                                                                      fontSize:
                                                                          media.width *
                                                                              sixteen,
                                                                      color:
                                                                          textColor),
                                                                  onChanged:
                                                                      (val) {
                                                                    setState(
                                                                        () {
                                                                      searchVal =
                                                                          val;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 20),
                                                              Expanded(
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    children: countries
                                                                        .asMap()
                                                                        .map((i, value) {
                                                                          return MapEntry(
                                                                              i,
                                                                              SizedBox(
                                                                                width: media.width * 0.9,
                                                                                child: (searchVal == '' && countries[i]['flag'] != null)
                                                                                    ? InkWell(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            phcode = i;
                                                                                          });
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                          color: page,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Row(
                                                                                                children: [
                                                                                                  Image.network(countries[i]['flag']),
                                                                                                  SizedBox(
                                                                                                    width: media.width * 0.02,
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    width: media.width * 0.4,
                                                                                                    child: MyText(
                                                                                                      text: countries[i]['name'],
                                                                                                      size: media.width * sixteen,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              MyText(text: countries[i]['dial_code'], size: media.width * sixteen)
                                                                                            ],
                                                                                          ),
                                                                                        ))
                                                                                    : (countries[i]['flag'] != null && countries[i]['name'].toLowerCase().contains(searchVal.toLowerCase()))
                                                                                        ? InkWell(
                                                                                            onTap: () {
                                                                                              setState(() {
                                                                                                phcode = i;
                                                                                              });
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: Container(
                                                                                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                              color: page,
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  Row(
                                                                                                    children: [
                                                                                                      Image.network(countries[i]['flag']),
                                                                                                      SizedBox(
                                                                                                        width: media.width * 0.02,
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        width: media.width * 0.4,
                                                                                                        child: MyText(text: countries[i]['name'], size: media.width * sixteen),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  MyText(text: countries[i]['dial_code'], size: media.width * sixteen)
                                                                                                ],
                                                                                              ),
                                                                                            ))
                                                                                        : Container(),
                                                                              ));
                                                                        })
                                                                        .values
                                                                        .toList(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  );
                                                });
                                          } else {
                                            getCountryCode();
                                          }
                                          setState(() {});
                                        },
                                        //input field
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                  countries[phcode]['flag']),
                                              SizedBox(
                                                width: media.width * 0.02,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                size: 28,
                                                color: textColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        width: 1,
                                        height: 55,
                                        color: underline,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          height: 50,
                                          child: TextFormField(
                                            textAlign: TextAlign.start,
                                            controller: controller,
                                            onChanged: (val) {
                                              setState(() {
                                                phnumber = controller.text;
                                              });
                                              if (controller.text.length ==
                                                  countries[phcode]
                                                      ['dial_max_length']) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              }
                                            },
                                            maxLength: countries[phcode]
                                                ['dial_max_length'],
                                            style: GoogleFonts.notoSans(
                                                color: textColor,
                                                fontSize: media.width * sixteen,
                                                letterSpacing: 1),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12),
                                                child: MyText(
                                                  text: countries[phcode]
                                                          ['dial_code']
                                                      .toString(),
                                                  size: media.width * sixteen,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              hintStyle: GoogleFonts.notoSans(
                                                color:
                                                    textColor.withOpacity(0.7),
                                                fontSize: media.width * sixteen,
                                              ),
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_error != '')
                  Column(
                    children: [
                      SizedBox(
                          width: media.width * 0.9,
                          child: MyText(
                            text: _error,
                            color: Colors.red,
                            size: media.width * fourteen,
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: media.width * 0.025,
                      )
                    ],
                  ),
                (isfromomobile == true)
                    ? Column(
                        children: [
                          Button(
                              onTap: () async {
                                if (firstname.text.isNotEmpty &&
                                    emailtext.text.isNotEmpty) {
                                  setState(() {
                                    _error = '';
                                  });
                                  loginLoading = true;
                                  valueNotifierLogin.incrementNotifier();
                                  var remail =
                                      emailtext.text.replaceAll(' ', '');
                                  String pattern =
                                      r"^[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])*$";
                                  RegExp regex = RegExp(pattern);
                                  if (regex.hasMatch(remail)) {
                                    setState(() {
                                      _error = '';
                                    });
                                    FocusScope.of(context).unfocus();
                                    if (lastname.text != '') {
                                      name =
                                          '${firstname.text} ${lastname.text}';
                                    } else {
                                      name = firstname.text;
                                    }
                                    email = remail;
                                    values = 1;
                                    var result = await validateEmail(remail);
                                    if (result == 'success') {
                                      isfromomobile = true;
                                      isverifyemail = true;
                                      currentPage = 3;
                                    } else {
                                      setState(() {
                                        _error = result.toString();
                                      });
                                      // showToast();
                                    }
                                  } else {
                                    // showToast();
                                    setState(() {
                                      _error = languages[choosenLanguage]
                                          ['text_email_validation'];
                                    });
                                    // showToast();
                                  }
                                  loginLoading = false;
                                  valueNotifierLogin.incrementNotifier();
                                }
                              },
                              color: (firstname.text.isNotEmpty &&
                                      emailtext.text.isNotEmpty)
                                  ? buttonColor
                                  : Colors.grey,
                              text: languages[choosenLanguage]['text_next'])
                        ],
                      )
                    : Container(
                        width: media.width * 1 - media.width * 0.08,
                        alignment: Alignment.center,
                        child: Button(
                          onTap: () async {
                            if (firstname.text.isNotEmpty &&
                                controller.text.length >=
                                    countries[phcode]['dial_min_length']) {
                              if (lastname.text != '') {
                                name = '${firstname.text} ${lastname.text}';
                              } else {
                                name = firstname.text;
                              }
                              FocusManager.instance.primaryFocus?.unfocus();
                              loginLoading = true;
                              valueNotifierLogin.incrementNotifier();
                              values = 0;
                              var val = await validateEmail(phnumber);
                              if (val == 'success') {
                                var result = await verifyUser(phnumber);
                                if (result == false) {
                                  var val = await otpCall();
                                  if (val.value == true) {
                                    phoneAuthCheck = true;
                                    await phoneAuth(countries[phcode]
                                            ['dial_code'] +
                                        phnumber);
                                    currentPage = 1;
                                    isfromomobile = true;
                                    isverifyemail = true;
                                  } else {
                                    isverifyemail = true;
                                    phoneAuthCheck = false;
                                    isfromomobile = true;
                                    currentPage = 1;
                                  }
                                } else {
                                  setState(() {
                                    _error = languages[choosenLanguage]
                                        ['text_mobile_already_taken'];
                                  });
                                }
                              } else {
                                setState(() {
                                  _error = languages[choosenLanguage]
                                      ['text_mobile_already_taken'];
                                });
                              }

                              loginLoading = false;
                              valueNotifierLogin.incrementNotifier();
                            }
                          },
                          color: (firstname.text.isNotEmpty &&
                                  controller.text.length >=
                                      countries[phcode]['dial_min_length'])
                              ? buttonColor
                              : Colors.grey,
                          text: languages[choosenLanguage]['text_next'],
                        ),
                      ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
            //display toast
            (showtoast == true)
                ? Positioned(
                    bottom: media.width * 0.1,
                    left: media.width * 0.06,
                    right: media.width * 0.06,
                    child: Container(
                        padding: EdgeInsets.all(media.width * 0.04),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2.0,
                                  spreadRadius: 2.0,
                                  color: Colors.black.withOpacity(0.2))
                            ],
                            color: verifyDeclined),
                        child: MyText(
                          text: _error,
                          size: media.width * fourteen,
                          color: textColor,
                          fontweight: FontWeight.w600,
                        )))
                : Container()
          ],
        ),
      ),
    );
  }
}
