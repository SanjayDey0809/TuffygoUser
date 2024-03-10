import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../styles/styles.dart';
import '../../functions/functions.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import 'dart:math' as math;
import '../loadingPage/loading.dart';
import '../noInternet/nointernet.dart';
import 'agreement.dart';
import 'namepage.dart';
import 'otp_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

//code as int for getting phone dial code of choosen country
String phnumber = ''; // phone number as string entered in input field
// String phone = '';
List pages = [1, 2, 3, 4];
int currentPage = 0;
bool loginLoading = true;
var values = 0;
bool isfromomobile = true;
bool isLoginemail = false;

dynamic proImageFile;
ImagePicker picker = ImagePicker();
bool pickImage = false;
String _permission = '';

late StreamController profilepicturecontroller;
StreamSink get profilepicturesink => profilepicturecontroller.sink;
Stream get profilepicturestream => profilepicturecontroller.stream;

class _LoginState extends State<Login> with TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  // final _pinPutController2 = TextEditingController();
  dynamic aController;
  String _error = '';
  // bool _resend = false;

  String get timerString {
    Duration duration = aController.duration * aController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  bool terms = true; //terms and conditions true or false

  @override
  void initState() {
    currentPage = 0;
    controller.text = '';
    isfromomobile = true;
    proImageFile = null;
    isLoginemail = false;
    phnumber = '';
    email = '';
    values = 0;
    aController =
        AnimationController(vsync: this, duration: const Duration(seconds: 60));
    countryCode();
    super.initState();
  }

  getGalleryPermission() async {
    dynamic status;
    if (platform == TargetPlatform.android) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
        }

        /// use [Permissions.storage.status]
      } else {
        status = await Permission.photos.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.photos.request();
        }
      }
    } else {
      status = await Permission.photos.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.photos.request();
      }
    }
    return status;
  }

//get camera permission
  getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
    }
    return status;
  }

//pick image from gallery
  pickImageFromGallery() async {
    var permission = await getGalleryPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

      proImageFile = pickedFile?.path;
      pickImage = false;
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    } else {
      _permission = 'noPhotos';
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    }
  }

//pick image from camera
  pickImageFromCamera() async {
    var permission = await getCameraPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

      proImageFile = pickedFile?.path;
      pickImage = false;
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    } else {
      _permission = 'noPhotos';
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    }
  }

  countryCode() async {
    isverifyemail = false;
    isLoginemail = false;
    isfromomobile = true;
    var result = await getCountryCode();
    if (result == 'success') {
      setState(() {
        loginLoading = false;
      });
    } else {
      setState(() {
        loginLoading = false;
      });
    }
  }

  //navigate
  navigate() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Otp()));
  }

  var verifyEmailError = '';
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: ValueListenableBuilder(
              valueListenable: valueNotifierLogin.value,
              builder: (context, value, child) {
                return Stack(
                  children: [



                    Container(
                      color: page,
                      padding: EdgeInsets.only(
                          left: media.width * 0.05,
                          right: media.width * 0.05),
                      width: media.width * 1,
                      height: media.height * 1,
                      child: Column(


                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          //LOGO OF TUFFY RIDER

                          Container(
                            height: MediaQuery.of(context).size.height*.4,
                            child: Image.asset('assets/images/logo.png'),
                          ),



                          // SizedBox(height: media.height * 0.09),
                          // (currentPage != 0)
                          //     ? InkWell(
                          //         onTap: () {
                          //           if (currentPage == 2) {
                          //             setState(() {
                          //               controller.text = '';
                          //               currentPage = 0;
                          //               isverifyemail = false;
                          //               isLoginemail = false;
                          //               isfromomobile = true;
                          //             });
                          //           } else if (currentPage == 1) {
                          //             if (currentPage == 1 && isverifyemail) {
                          //               setState(() {
                          //                 isfromomobile = false;
                          //                 currentPage = 2;
                          //               });
                          //             } else {
                          //               setState(() {
                          //                 currentPage = currentPage - 1;
                          //               });
                          //             }
                          //           } else {
                          //             if (currentPage == 3 &&
                          //                 isverifyemail &&
                          //                 isLoginemail) {
                          //               setState(() {
                          //                 isfromomobile = false;
                          //               });
                          //             }
                          //             setState(() {
                          //               currentPage = currentPage - 1;
                          //             });
                          //           }
                          //         },
                          //         child: Icon(
                          //           Icons.arrow_back_ios,
                          //           color: textColor,
                          //           size: media.height * eighteen,
                          //         ))
                          //     : Container(),
                          // SizedBox(
                          //   height: media.height * 0.05,
                          // ),
                          // AnimatedContainer(
                          //   duration: const Duration(milliseconds: 1000),
                          //   margin: EdgeInsets.only(
                          //       left: (languageDirection == 'rtl')
                          //           ? 0
                          //           : (media.width * 0.25) * currentPage,
                          //       right: (languageDirection == 'ltr')
                          //           ? 0
                          //           : (media.width * 0.25) * currentPage),
                          //   child: Image.asset(
                          //     (languageDirection == 'ltr')
                          //         ? 'assets/images/car.png'
                          //         : 'assets/images/car_rtl.png',
                          //     width: media.width * 0.15,
                          //   ),
                          // ),
                          // Row(
                          //   children: pages
                          //       .asMap()
                          //       .map((key, value) {
                          //         return MapEntry(
                          //           key,
                          //           // Row(
                          //           //   children: [
                          //           //     // Column(
                          //           //     //   children: [
                          //           //     //     // AnimatedContainer(
                          //           //     //     //   duration: const Duration(
                          //           //     //     //       milliseconds: 1000),
                          //           //     //     //   height:
                          //           //     //     //       (media.width * 0.9 / 4) / 8,
                          //           //     //     //   width:
                          //           //     //     //       (media.width * 0.9 / 4) / 8,
                          //           //     //     //   color: (currentPage >= key)
                          //           //     //     //       ? const Color(0xff000000)
                          //           //     //     //       : const Color(0xff000000)
                          //           //     //     //           .withOpacity(0.4),
                          //           //     //     // ),
                          //           //     // //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? buttonColor
                          //           //     //           : buttonColor
                          //           //     //               .withOpacity(0.4),
                          //           //     //     )
                          //           //     //   ],
                          //           //     // ),
                          //           //     // Column(
                          //           //     //   children: [
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? const Color(0xffFFFFFF)
                          //           //     //           : const Color(0xffFFFFFF)
                          //           //     //               .withOpacity(0.4),
                          //           //     //     ),
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? const Color(0xff000000)
                          //           //     //           : const Color(0xff000000)
                          //           //     //               .withOpacity(0.4),
                          //           //     //     )
                          //           //     //   ],
                          //           //     // ),
                          //           //     // Column(
                          //           //     //   children: [
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? const Color(0xff000000)
                          //           //     //           : const Color(0xff000000)
                          //           //     //               .withOpacity(0.4),
                          //           //     //     ),
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? const Color(0xffFFFFFF)
                          //           //     //           : const Color(0xffFFFFFF)
                          //           //     //               .withOpacity(0.4),
                          //           //     //     )
                          //           //     //   ],
                          //           //     // ),
                          //           //     // Column(
                          //           //     //   children: [
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? buttonColor
                          //           //     //           : buttonColor
                          //           //     //               .withOpacity(0.4),
                          //           //     //     ),
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? const Color(0xff000000)
                          //           //     //           : const Color(0xff000000)
                          //           //     //               .withOpacity(0.4),
                          //           //     //     )
                          //           //     //   ],
                          //           //     // ),
                          //           //     // Column(
                          //           //     //   children: [
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? const Color(0xff000000)
                          //           //     //           : const Color(0xff000000)
                          //           //     //               .withOpacity(0.4),
                          //           //     //     ),
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? buttonColor
                          //           //     //           : buttonColor
                          //           //     //               .withOpacity(0.4),
                          //           //     //     )
                          //           //     //   ],
                          //           //     // ),
                          //           //     // Column(
                          //           //     //   children: [
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? const Color(0xffFFFFFF)
                          //           //     //           : const Color(0xffFFFFFF)
                          //           //     //               .withOpacity(0.4),
                          //           //     //     ),
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? const Color(0xff000000)
                          //           //     //           : const Color(0xff000000)
                          //           //     //               .withOpacity(0.4),
                          //           //     //     )
                          //           //     //   ],
                          //           //     // ),
                          //           //     // Column(
                          //           //     //   children: [
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? const Color(0xff000000)
                          //           //     //           : const Color(0xff000000)
                          //           //     //               .withOpacity(0.4),
                          //           //     //     ),
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? const Color(0xffFFFFFF)
                          //           //     //           : const Color(0xffFFFFFF)
                          //           //     //               .withOpacity(0.4),
                          //           //     //     )
                          //           //     //   ],
                          //           //     // ),
                          //           //     // Column(
                          //           //     //   children: [
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? buttonColor
                          //           //     //           : buttonColor
                          //           //     //               .withOpacity(0.4),
                          //           //     //     ),
                          //           //     //     AnimatedContainer(
                          //           //     //       duration: const Duration(
                          //           //     //           milliseconds: 1000),
                          //           //     //       height:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       width:
                          //           //     //           (media.width * 0.9 / 4) / 8,
                          //           //     //       color: (currentPage >= key)
                          //           //     //           ? const Color(0xff000000)
                          //           //     //           : const Color(0xff000000)
                          //           //     //               .withOpacity(0.4),
                          //           //     //     )
                          //           //     //   ],
                          //           //     // ),
                          //           //   ],
                          //           // ),
                          //         );
                          //       })
                          //       .values
                          //       .toList(),
                          // ),



                          //Enter your phone number
                          (countries.isNotEmpty && currentPage == 0)
                              ? (isLoginemail == false)
                                  ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyText(

                                          text: languages[choosenLanguage]
                                              ['text_what_mobilenum'],

                                          size: media.width * twenty,
                                          fontweight: FontWeight.bold,


                                        ),
                                        SizedBox(
                                          height: media.height * 0.02,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          height: 55,
                                          width: media.width * 0.9,
                                          // decoration: BoxDecoration(
                                          //   borderRadius:
                                          //       BorderRadius.circular(10),
                                          //   border:
                                          //       Border.all(color: textColor),
                                          // ),
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
                                                            backgroundColor:
                                                                page,
                                                            insetPadding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            content: StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                              return Container(
                                                                width: media
                                                                        .width *
                                                                    0.9,
                                                                color: page,
                                                                child:
                                                                    Directionality(
                                                                  textDirection: (languageDirection ==
                                                                          'rtl')
                                                                      ? TextDirection
                                                                          .rtl
                                                                      : TextDirection
                                                                          .ltr,
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                20,
                                                                            right:
                                                                                20),
                                                                        height:
                                                                            40,
                                                                        width: media.width *
                                                                            0.9,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                            border: Border.all(color: Colors.grey, width: 1.5)),
                                                                        child:
                                                                            TextField(
                                                                          decoration: InputDecoration(
                                                                              contentPadding: (languageDirection == 'rtl') ? EdgeInsets.only(bottom: media.width * 0.035) : EdgeInsets.only(bottom: media.width * 0.04),
                                                                              border: InputBorder.none,

                                                                              hintText: languages[choosenLanguage]['text_search'],
                                                                              hintStyle: GoogleFonts.notoSans(fontSize: media.width * sixteen, color: hintColor)),
                                                                          style: GoogleFonts.notoSans(
                                                                              fontSize: media.width * sixteen,
                                                                              color: textColor),
                                                                          onChanged:
                                                                              (val) {
                                                                            setState(() {
                                                                              searchVal = val;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              20),
                                                                      Expanded(
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
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
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(16),

                                                      border: Border.all(
                                                        color: Colors.white,
                                                      )

                                                  ),
                                                  height: 50,
                                                  width: 80,
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [

                                                      //flag to IN
                                                      Text('IN',
                                                        style: GoogleFonts.notoSans(
                                                        fontWeight: FontWeight.w500,
                                                          fontSize: 16,
                                                          color: Colors.white
                                                      ),),
                                                      // Image.network(
                                                      //     countries[phcode]
                                                      //         ['flag']),
                                                      SizedBox(
                                                        width:
                                                            media.width * 0.02,
                                                      ),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),

                                                      Text('+91',
                                                        style: GoogleFonts.notoSans(
                                                            fontWeight: FontWeight.w300,
                                                            fontSize: 16,
                                                            color: Colors.white
                                                        ),),

                                                      // Icon(
                                                      //   Icons.arrow_drop_down,
                                                      //   size: 28,
                                                      //   color: textColor,
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Container(
                                              //   width: 1,
                                              //   height: 55,
                                              //   color: underline,
                                              // ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16),

                                                    border: Border.all(
                                                      color: Colors.white,
                                                    )

                                                  ),
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  height: 50,
                                                  child: TextFormField(
                                                    textAlign: TextAlign.start,
                                                    controller: controller,
                                                    cursorColor: Colors.white,


                                                    onChanged: (val) {
                                                      setState(() {
                                                        phnumber =
                                                            controller.text;
                                                      });
                                                      if (controller
                                                              .text.length ==
                                                          countries[phcode][
                                                              'dial_max_length']) {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      }
                                                    },
                                                    maxLength: countries[phcode]
                                                        ['dial_max_length'],
                                                    style: GoogleFonts.notoSans(
                                                        color: textColor,
                                                        fontSize: media.width *
                                                            sixteen,
                                                        letterSpacing: 1),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      counterText: '',

                                                      hintText: ' X X X X X X X X X X',

                                                      hintStyle:
                                                          GoogleFonts.notoSans(
                                                        color: textColor
                                                            .withOpacity(0.5),
                                                        fontSize: media.width *
                                                            sixteen,
                                                      ),
                                                      border: InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        // SizedBox(height: media.height * 0.02),
                                        // MyText(
                                        //   text: languages[choosenLanguage]
                                        //       ['text_you_get_otp'],
                                        //   size: media.width * fourteen,
                                        //   color: textColor.withOpacity(0.5),
                                        // ),
                                        // SizedBox(height: media.height * 0.03),
                                        // (isemailmodule == '1')
                                            // ? Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.center,
                                            //     children: [
                                            //       InkWell(
                                            //           onTap: () {
                                            //             controller.clear();
                                            //             if (isLoginemail ==
                                            //                 false) {
                                            //               setState(() {
                                            //                 _error = '';
                                            //                 isLoginemail = true;
                                            //               });
                                            //             } else {
                                            //               setState(() {
                                            //                 _error = '';
                                            //                 isLoginemail =
                                            //                     false;
                                            //               });
                                            //             }
                                            //           },
                                            //           child: MyText(
                                            //             text: languages[
                                            //                         choosenLanguage]
                                            //                     [
                                            //                     'text_continue_with'] +
                                            //                 ' ' +
                                            //                 languages[
                                            //                         choosenLanguage]
                                            //                     ['text_email'],
                                            //             size: media.width *
                                            //                 sixteen,
                                            //             color: textColor
                                            //                 .withOpacity(0.7),
                                            //             fontweight:
                                            //                 FontWeight.w400,
                                            //           )),
                                            //       SizedBox(
                                            //           width:
                                            //               media.width * 0.02),
                                            //       Icon(Icons.email_outlined,
                                            //           size: media.width *
                                            //               eighteen,
                                            //           color: textColor
                                            //               .withOpacity(0.7)),
                                            //     ],
                                            //   )
                                            // : Container(),
                                        SizedBox(
                                          height: media.height * 0.03,
                                        ),
                                        if (_error != '')
                                          Column(
                                            children: [
                                              SizedBox(
                                                  width: media.width * 0.9,
                                                  child: MyText(
                                                    text: _error,
                                                    color: Colors.red,
                                                    size:
                                                        media.width * fourteen,
                                                    textAlign: TextAlign.center,
                                                  )),
                                              SizedBox(
                                                height: media.width * 0.025,
                                              )
                                            ],
                                          ),
                                        (controller.text.length >=
                                                countries[phcode]
                                                    ['dial_min_length'])
                                            ? Container(
                                                width: media.width * 1 -
                                                    media.width * 0.08,
                                                alignment: Alignment.center,
                                                child: Button(
                                                  onTap: () async {
                                                    if (controller
                                                            .text.length >=
                                                        countries[phcode][
                                                            'dial_min_length']) {
                                                      _error = '';
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                      setState(() {
                                                        loginLoading = true;
                                                      });
                                                      //check if otp is true or false
                                                      var val = await otpCall();
                                                      //otp is true
                                                      if (val.value == true) {
                                                        phoneAuthCheck = true;
                                                        await phoneAuth(countries[
                                                                    phcode]
                                                                ['dial_code'] +
                                                            phnumber);
                                                        values = 0;
                                                        currentPage = 1;
                                                        loginLoading = false;
                                                        setState(() {});
                                                      }
                                                      //otp is false
                                                      else if (val.value ==
                                                          false) {
                                                        phoneAuthCheck = false;
                                                        currentPage = 1;
                                                        loginLoading = false;
                                                        setState(() {});
                                                      }
                                                    }
                                                  },
                                                  text:
                                                      'SEND OTP',
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        MyText(
                                          text: languages[choosenLanguage]
                                              ['text_what_email'],
                                          size: media.width * twenty,
                                          fontweight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: media.height * 0.02,
                                        ),
                                        Container(
                                            height: media.width * 0.13,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: (isDarkTheme == true)
                                                        ? textColor
                                                            .withOpacity(0.4)
                                                        : underline),
                                                color: (isDarkTheme == true)
                                                    ? page
                                                    : const Color(0xffF8F8F8)),
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: MyTextField(
                                              textController: controller,
                                              hinttext:
                                                  languages[choosenLanguage]
                                                      ['text_enter_email'],
                                              onTap: (val) {
                                                setState(() {
                                                  email = controller.text;
                                                });
                                              },
                                            )),
                                        SizedBox(height: media.height * 0.02),
                                        MyText(
                                          text: languages[choosenLanguage]
                                              ['text_you_get_otp'],
                                          size: media.width * fourteen,
                                          color: textColor.withOpacity(0.5),
                                        ),
                                        SizedBox(height: media.height * 0.05),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  controller.clear();
                                                  if (isLoginemail == false) {
                                                    setState(() {
                                                      _error = '';
                                                      isLoginemail = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _error = '';
                                                      isLoginemail = false;
                                                    });
                                                  }
                                                },
                                                child: MyText(
                                                  text: languages[
                                                              choosenLanguage][
                                                          'text_continue_with'] +
                                                      ' ' +
                                                      languages[choosenLanguage]
                                                          ['text_mob_num'],
                                                  size: media.width * sixteen,
                                                  color: textColor
                                                      .withOpacity(0.7),
                                                  fontweight: FontWeight.w400,
                                                )),
                                            SizedBox(
                                              width: media.width * 0.03,
                                            ),
                                            Icon(Icons.call,
                                                size: media.width * eighteen,
                                                color:
                                                    textColor.withOpacity(0.7)),
                                            // SizedBox(
                                            //     width: media.width * 0.03),
                                          ],
                                        ),
                                        SizedBox(
                                          height: media.height * 0.05,
                                        ),
                                        if (_error != '')
                                          Column(
                                            children: [
                                              SizedBox(
                                                  width: media.width * 0.9,
                                                  child: MyText(
                                                    text: _error,
                                                    color: Colors.red,
                                                    size:
                                                        media.width * fourteen,
                                                    textAlign: TextAlign.center,
                                                  )),
                                              SizedBox(
                                                height: media.width * 0.025,
                                              )
                                            ],
                                          ),
                                        (controller.text.isNotEmpty)
                                            ? Container(
                                                width: media.width * 1,
                                                alignment: Alignment.center,
                                                child: Button(
                                                    onTap: () async {
                                                      setState(() {
                                                        _error = '';
                                                      });
                                                      var remail = controller
                                                          .text
                                                          .replaceAll(' ', '');
                                                      String pattern =
                                                          r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])*$";
                                                      RegExp regex =
                                                          RegExp(pattern);
                                                      if (regex
                                                          .hasMatch(remail)) {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();

                                                        setState(() {
                                                          verifyEmailError = '';
                                                          loginLoading = true;
                                                        });
                                                        email = remail;

                                                        phoneAuthCheck = true;
                                                        await sendOTPtoEmail(
                                                            email);
                                                        values = 1;
                                                        isfromomobile = false;
                                                        currentPage = 1;

                                                        // navigate();

                                                        setState(() {
                                                          loginLoading = false;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          loginLoading = false;
                                                          _error = languages[
                                                                  choosenLanguage]
                                                              [
                                                              'text_email_validation'];
                                                        });
                                                      }
                                                    },
                                                    text: languages[
                                                            choosenLanguage]
                                                        ['text_login']))
                                            : Container(),
                                      ],
                                    )
                              : (currentPage == 1)
                                  ? const Expanded(child: Otp())
                                  : (currentPage == 2)
                                      ? const Expanded(child: NamePage())
                                      : (currentPage == 3)
                                          ? const Expanded(
                                              child: AggreementPage())
                                          : Container(),
                        ],
                      ),
                    ),

                    (pickImage == true)
                        ? Positioned(
                            bottom: 0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  pickImage = false;
                                });
                              },
                              child: Container(
                                height: media.height * 1,
                                width: media.width * 1,
                                color: Colors.transparent.withOpacity(0.6),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.all(media.width * 0.05),
                                      width: media.width * 1,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25)),
                                          border: Border.all(
                                            color: borderLines,
                                            width: 1.2,
                                          ),
                                          color: page),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: media.width * 0.02,
                                            width: media.width * 0.15,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      media.width * 0.01),
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      pickImageFromCamera();
                                                    },
                                                    child: Container(
                                                        height:
                                                            media.width * 0.171,
                                                        width:
                                                            media.width * 0.171,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    borderLines,
                                                                width: 1.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          size: media.width *
                                                              0.064,
                                                          color: textColor,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: media.width * 0.02,
                                                  ),
                                                  MyText(
                                                    text: languages[
                                                            choosenLanguage]
                                                        ['text_camera'],
                                                    size: media.width * ten,
                                                    color: textColor
                                                        .withOpacity(0.4),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      pickImageFromGallery();
                                                    },
                                                    child: Container(
                                                        height:
                                                            media.width * 0.171,
                                                        width:
                                                            media.width * 0.171,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    borderLines,
                                                                width: 1.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: Icon(
                                                          Icons.image_outlined,
                                                          size: media.width *
                                                              0.064,
                                                          color: textColor,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: media.width * 0.02,
                                                  ),
                                                  MyText(
                                                    text: languages[
                                                            choosenLanguage]
                                                        ['text_gallery'],
                                                    size: media.width * ten,
                                                    color: textColor
                                                        .withOpacity(0.4),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        : Container(),
                    (_permission != '')
                        ? Positioned(
                            child: Container(
                            height: media.height * 1,
                            width: media.width * 1,
                            color: Colors.transparent.withOpacity(0.6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: media.width * 0.9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _permission = '';
                                            pickImage = false;
                                          });
                                        },
                                        child: Container(
                                          height: media.width * 0.1,
                                          width: media.width * 0.1,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: page),
                                          child: Icon(Icons.cancel_outlined,
                                              color: textColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                Container(
                                  padding: EdgeInsets.all(media.width * 0.05),
                                  width: media.width * 0.9,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: page,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2.0,
                                            spreadRadius: 2.0,
                                            color:
                                                Colors.black.withOpacity(0.2))
                                      ]),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          width: media.width * 0.8,
                                          child: MyText(
                                            text: (_permission == 'noPhotos')
                                                ? languages[choosenLanguage]
                                                    ['text_open_photos_setting']
                                                : languages[choosenLanguage][
                                                    'text_open_camera_setting'],
                                            size: media.width * sixteen,
                                            fontweight: FontWeight.w600,
                                          )),
                                      SizedBox(height: media.width * 0.05),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                              onTap: () async {
                                                await openAppSettings();
                                              },
                                              child: MyText(
                                                text: languages[choosenLanguage]
                                                    ['text_open_settings'],
                                                size: media.width * sixteen,
                                                fontweight: FontWeight.w600,
                                              )),
                                          InkWell(
                                              onTap: () async {
                                                (_permission == 'noCamera')
                                                    ? pickImageFromCamera()
                                                    : pickImageFromGallery();
                                                setState(() {
                                                  _permission = '';
                                                });
                                              },
                                              child: MyText(
                                                text: languages[choosenLanguage]
                                                    ['text_done'],
                                                size: media.width * sixteen,
                                                color: buttonColor,
                                                fontweight: FontWeight.w600,
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ))
                        : Container(),

                    //No internet
                    (internet == false)
                        ? Positioned(
                            top: 0,
                            child: NoInternet(onTap: () {
                              setState(() {
                                loginLoading = true;
                                internet = true;
                                countryCode();
                              });
                            }))
                        : Container(),

                    //loader
                    (loginLoading == true)
                        ? const Positioned(top: 0, child: Loading())
                        : Container(),

                    Positioned(
                      top: MediaQuery.of(context).size.height*.3,
                      left: MediaQuery.of(context).size.width*.2,
                      child: Text('Book Rides Like a Pro',
                        style: GoogleFonts.notoSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.white24
                        ),),),

                    Positioned(
                      top: MediaQuery.of(context).size.height*.07,
                      left: MediaQuery.of(context).size.height*.15,
                      child: Text('WELCOME TO',
                        style: GoogleFonts.notoSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.white24
                        ),),),


                  ],
                );
              })),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
