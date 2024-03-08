import 'package:flutter/material.dart';
import 'package:flutter_user/pages/NavigatorPages/makecomplaint.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../NavigatorPages/editprofile.dart';
import '../NavigatorPages/favourite.dart';
import '../NavigatorPages/history.dart';
import '../NavigatorPages/notification.dart';
import '../NavigatorPages/referral.dart';
import '../NavigatorPages/settings.dart';
import '../NavigatorPages/sos.dart';
import '../NavigatorPages/support.dart';
import '../NavigatorPages/walletpage.dart';
import '../onTripPage/map_page.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ValueListenableBuilder(
        valueListenable: valueNotifierHome.value,
        builder: (context, value, child) {
          return SizedBox(
            width: media.width * 0.8,
            child: Directionality(
              textDirection: (languageDirection == 'rtl')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Drawer(
                  backgroundColor: page,
                  child: SizedBox(
                    width: media.width * 0.7,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: media.width * 0.05 +
                                        MediaQuery.of(context).padding.top,
                                  ),
                                  SizedBox(
                                    width: media.width * 0.7,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: media.width * 0.2,
                                          width: media.width * 0.2,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      userDetails[
                                                          'profile_picture']),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          width: media.width * 0.025,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: media.width * 0.45,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: media.width * 0.3,
                                                    child: MyText(
                                                      text: userDetails['name'],
                                                      size: media.width *
                                                          eighteen,
                                                      fontweight:
                                                          FontWeight.w600,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      var val = await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const EditProfile()));
                                                      if (val) {
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          media.width * 0.01),
                                                      width: media.width * 0.15,
                                                      decoration: BoxDecoration(
                                                          color: textColor
                                                              .withOpacity(0.1),
                                                          border: Border.all(
                                                              color: textColor
                                                                  .withOpacity(
                                                                      0.15)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(media
                                                                          .width *
                                                                      0.01)),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.edit,
                                                              size:
                                                                  media.width *
                                                                      fourteen,
                                                              color: textColor
                                                              // const Color(0xFFFF0000),
                                                              ),
                                                          Expanded(
                                                            child: MyText(
                                                                text: languages[
                                                                        choosenLanguage]
                                                                    [
                                                                    'text_edit'],
                                                                size: media
                                                                        .width *
                                                                    twelve,
                                                                maxLines: 1,
                                                                color: textColor
                                                                // const Color(0xFFFF0000),
                                                                ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.01,
                                            ),
                                            SizedBox(
                                              width: media.width * 0.45,
                                              child: MyText(
                                                text: userDetails['mobile'],
                                                size: media.width * fourteen,
                                                maxLines: 1,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: media.width * 0.05),
                                    width: media.width * 0.7,
                                    child: Column(
                                      children: [
                                        //My orders

                                        NavMenu(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const History()));
                                          },
                                          text: languages[choosenLanguage]
                                              ['text_my_orders'],
                                          image: 'assets/images/history.png',
                                        ),

                                        ValueListenableBuilder(
                                            valueListenable:
                                                valueNotifierNotification.value,
                                            builder: (context, value, child) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const NotificationPage()));
                                                  setState(() {
                                                    userDetails[
                                                        'notifications_count'] = 0;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: media.width * 0.025),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .notifications_none,
                                                            size: media.width *
                                                                0.075,
                                                            color: textColor
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                          SizedBox(
                                                            width: media.width *
                                                                0.025,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: (userDetails[
                                                                            'notifications_count'] ==
                                                                        0)
                                                                    ? media.width *
                                                                        0.55
                                                                    : media.width *
                                                                        0.495,
                                                                child: MyText(
                                                                  text: languages[
                                                                              choosenLanguage]
                                                                          [
                                                                          'text_notification']
                                                                      .toString(),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  size: media
                                                                          .width *
                                                                      sixteen,
                                                                  color: textColor
                                                                      .withOpacity(
                                                                          0.8),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  (userDetails[
                                                                              'notifications_count'] ==
                                                                          0)
                                                                      ? Container()
                                                                      : Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                buttonColor,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            userDetails['notifications_count'].toString(),
                                                                            style:
                                                                                GoogleFonts.notoSans(fontSize: media.width * fourteen, color: (isDarkTheme) ? Colors.black : buttonText),
                                                                          ),
                                                                        ),
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_right_rounded,
                                                                    size: media
                                                                            .width *
                                                                        0.05,
                                                                    color: textColor
                                                                        .withOpacity(
                                                                            0.8),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: media.width *
                                                              0.02,
                                                          left: media.width *
                                                              0.09,
                                                        ),
                                                        child: Container(
                                                          color: textColor
                                                              .withOpacity(0.1),
                                                          height: 1,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                        //wallet page
                                        if (userDetails[
                                                'show_wallet_feature_on_mobile_app'] ==
                                            "1")
                                          NavMenu(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const WalletPage()));
                                            },
                                            text: languages[choosenLanguage]
                                                ['text_enable_wallet'],
                                            icon: Icons.payment,
                                          ),

                                        //sos
                                        NavMenu(
                                          onTap: () async {
                                            var nav = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Sos()));
                                            if (nav) {
                                              setState(() {});
                                            }
                                          },
                                          text: languages[choosenLanguage]
                                              ['text_sos'],
                                          icon: Icons.connect_without_contact,
                                        ),
                                        //makecomplaints
                                        NavMenu(
                                          icon: Icons.toc,
                                          text: languages[choosenLanguage]
                                              ['text_make_complaints'],
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MakeComplaint()));
                                          },
                                        ),

                                        //saved address
                                        NavMenu(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Favorite()));
                                          },
                                          text: languages[choosenLanguage]
                                              ['text_favourites'],
                                          icon: Icons.bookmark,
                                        ),

                                        //settings
                                        NavMenu(
                                          onTap: () async {
                                            var nav = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SettingsPage()));
                                            if (nav) {
                                              setState(() {});
                                            }
                                          },
                                          text: languages[choosenLanguage]
                                              ['text_settings'],
                                          icon: Icons.settings,
                                        ),
                                        //support

                                        ValueListenableBuilder(
                                            valueListenable:
                                                valueNotifierChat.value,
                                            builder: (context, value, child) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SupportPage()));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: media.width * 0.025),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .support_agent,
                                                              size:
                                                                  media.width *
                                                                      0.075,
                                                              color: textColor
                                                                  .withOpacity(
                                                                      0.5)),
                                                          SizedBox(
                                                            width: media.width *
                                                                0.025,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: (unSeenChatCount == '0')
                                                                    ? media.width *
                                                                        0.55
                                                                    : media.width *
                                                                        0.495,
                                                                child: ShowUp(
                                                                  delay: 200,
                                                                  child: MyText(
                                                                    text: languages[
                                                                            choosenLanguage]
                                                                        [
                                                                        'text_support'],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    size: media
                                                                            .width *
                                                                        sixteen,
                                                                    color: textColor
                                                                        .withOpacity(
                                                                            0.8),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  (unSeenChatCount ==
                                                                          '0')
                                                                      ? Container()
                                                                      : Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                buttonColor,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            unSeenChatCount,
                                                                            style:
                                                                                GoogleFonts.notoSans(fontSize: media.width * fourteen, color: buttonText),
                                                                          ),
                                                                        ),
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_right_rounded,
                                                                    size: media
                                                                            .width *
                                                                        0.05,
                                                                    color: textColor
                                                                        .withOpacity(
                                                                            0.8),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: media.width *
                                                              0.01,
                                                          left: media.width *
                                                              0.09,
                                                        ),
                                                        child: Container(
                                                          color: textColor
                                                              .withOpacity(0.1),
                                                          height: 1,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),

                                        //referral page
                                        NavMenu(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ReferralPage()));
                                          },
                                          text: languages[choosenLanguage]
                                              ['text_enable_referal'],
                                          image: 'assets/images/referral.png',
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              logout = true;
                            });
                            valueNotifierHome.incrementNotifier();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              left: media.width * 0.25,
                            ),
                            height: media.width * 0.13,
                            width: media.width * 0.8,
                            color: Colors.grey.withOpacity(0.3),
                            child: Row(
                              mainAxisAlignment: (languageDirection == 'ltr')
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Icon(Icons.logout,
                                    size: media.width * 0.05, color: textColor),
                                SizedBox(
                                  width: media.width * 0.025,
                                ),
                                MyText(
                                  text: languages[choosenLanguage]
                                      ['text_sign_out'],
                                  size: media.width * sixteen,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        )
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}
