import 'package:flutter/material.dart';
import 'package:flutter_user/pages/onTripPage/booking_confirmation.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../noInternet/noInternet.dart';
import 'historydetails.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

dynamic selectedHistory;
dynamic selectedOutStation;

class _HistoryState extends State<History> {
  int _showHistory = 0;
  bool _isLoading = true;
  dynamic isCompleted;
  bool _cancelRide = false;
  var _cancelId = '';
  int? inti;
  @override
  void initState() {
    _isLoading = true;
    _getHistory();
    super.initState();
  }

  navigate() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => BookingConfirmation()));
  }

  naviagteridewithoutdestini() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BookingConfirmation(
                  type: 2,
                )));
  }

  naviagterental() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BookingConfirmation(
                  type: 1,
                )));
  }

//get history datas
  _getHistory() async {
    setState(() {
      myHistoryPage.clear();
      myHistory.clear();
    });
    var val = await getHistory('is_later=1');
    if (val == 'success') {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
        child: RefreshIndicator(
      onRefresh: () async {
        if (_showHistory == 0) {
          setState(() {
            myHistory.clear();
            myHistoryPage.clear();
            _showHistory = 0;
            _isLoading = true;
          });

          await getHistory('is_later=1');
          setState(() {
            _isLoading = false;
          });
        }
        if (_showHistory == 1) {
          setState(() {
            myHistory.clear();
            myHistoryPage.clear();
            _showHistory = 1;
            _isLoading = true;
          });

          await getHistory('is_completed=1');
          setState(() {
            _isLoading = false;
          });
        }
        if (_showHistory == 2) {
          setState(() {
            myHistory.clear();
            myHistoryPage.clear();
            _showHistory = 2;
            _isLoading = true;
          });

          await getHistory('is_cancelled=1');
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: ValueListenableBuilder(
          valueListenable: valueNotifierBook.value,
          builder: (context, value, child) {
            return Directionality(
              textDirection: (languageDirection == 'rtl')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Stack(
                children: [
                  Container(
                    height: media.height * 1,
                    width: media.width * 1,
                    color: page,
                    padding: EdgeInsets.fromLTRB(media.width * 0.05,
                        media.width * 0.05, media.width * 0.05, 0),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top),
                        Stack(
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.only(bottom: media.width * 0.05),
                              width: media.width * 1,
                              alignment: Alignment.center,
                              child: MyText(
                                text: languages[choosenLanguage]
                                    ['text_enable_history'],
                                size: media.width * twenty,
                                fontweight: FontWeight.w600,
                              ),
                            ),
                            Positioned(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.arrow_back_ios,
                                        color: textColor)))
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Container(
                          padding: EdgeInsets.all(media.width * 0.01),
                          height: media.width * 0.12,
                          width: media.width * 0.85,
                          decoration: BoxDecoration(
                              color: page,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    color: Colors.grey.withOpacity(0.2))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    myHistory.clear();
                                    myHistoryPage.clear();
                                    _showHistory = 0;
                                    _isLoading = true;
                                  });

                                  await getHistory('is_later=1');
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                                child: Container(
                                    height: media.width * 0.1,
                                    alignment: Alignment.center,
                                    width: media.width * 0.28,
                                    decoration: BoxDecoration(
                                        borderRadius: (_showHistory == 0)
                                            ? BorderRadius.circular(12)
                                            : null,
                                        boxShadow: [
                                          BoxShadow(
                                              color: (_showHistory == 0)
                                                  ? Colors.black
                                                      .withOpacity(0.2)
                                                  : page,
                                              spreadRadius: 2,
                                              blurRadius: 2)
                                        ],
                                        color: (_showHistory == 0)
                                            ? textColor
                                            : page),
                                    child: MyText(
                                        text: languages[choosenLanguage]
                                            ['text_upcoming'],
                                        size: media.width * fifteen,
                                        fontweight: FontWeight.w600,
                                        color: (_showHistory == 0)
                                            ? page
                                            : textColor)),
                              ),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    myHistory.clear();
                                    myHistoryPage.clear();
                                    _showHistory = 1;
                                    _isLoading = true;
                                  });

                                  await getHistory('is_completed=1');
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                                child: Container(
                                    height: media.width * 0.1,
                                    alignment: Alignment.center,
                                    width: media.width * 0.26,
                                    decoration: BoxDecoration(
                                        borderRadius: (_showHistory == 1)
                                            ? BorderRadius.circular(12)
                                            : null,
                                        boxShadow: [
                                          BoxShadow(
                                              color: (_showHistory == 1)
                                                  ? Colors.black
                                                      .withOpacity(0.2)
                                                  : page,
                                              spreadRadius: 2,
                                              blurRadius: 2)
                                        ],
                                        color: (_showHistory == 1)
                                            ? textColor
                                            : page),
                                    child: MyText(
                                        text: languages[choosenLanguage]
                                            ['text_completed'],
                                        size: media.width * fifteen,
                                        fontweight: FontWeight.w600,
                                        color: (_showHistory == 1)
                                            ? page
                                            : textColor)),
                              ),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    myHistory.clear();
                                    myHistoryPage.clear();
                                    _showHistory = 2;
                                    _isLoading = true;
                                  });

                                  await getHistory('is_cancelled=1');
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                                child: Container(
                                    height: media.width * 0.1,
                                    alignment: Alignment.center,
                                    width: media.width * 0.27,
                                    decoration: BoxDecoration(
                                        borderRadius: (_showHistory == 2)
                                            ? BorderRadius.circular(12)
                                            : null,
                                        boxShadow: [
                                          BoxShadow(
                                              color: (_showHistory == 2)
                                                  ? Colors.black
                                                      .withOpacity(0.2)
                                                  : page,
                                              spreadRadius: 2,
                                              blurRadius: 2)
                                        ],
                                        color: (_showHistory == 2)
                                            ? textColor
                                            : page),
                                    child: MyText(
                                        text: languages[choosenLanguage]
                                            ['text_cancelled'],
                                        size: media.width * fifteen,
                                        fontweight: FontWeight.w600,
                                        color: (_showHistory == 2)
                                            ? page
                                            : textColor)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.1,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              (myHistory.isNotEmpty)
                                  ? Column(
                                      children: myHistory
                                          .asMap()
                                          .map((i, value) {
                                            return MapEntry(
                                                i,
                                                (_showHistory == 1)
                                                    ?
                                                    //completed ride history
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              selectedHistory =
                                                                  i;

                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const HistoryDetails()));
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets.only(
                                                                  top: media
                                                                          .width *
                                                                      0.025,
                                                                  bottom: media
                                                                          .width *
                                                                      0.05,
                                                                  left: media
                                                                          .width *
                                                                      0.015,
                                                                  right: media
                                                                          .width *
                                                                      0.015),
                                                              width:
                                                                  media.width *
                                                                      0.85,
                                                              padding: EdgeInsets.fromLTRB(
                                                                  media.width *
                                                                      0.025,
                                                                  media.width *
                                                                      0.05,
                                                                  media.width *
                                                                      0.025,
                                                                  media.width *
                                                                      0.05),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(media.width *
                                                                                0.02),
                                                                        decoration: BoxDecoration(
                                                                            color: topBar,
                                                                            border: Border.all(
                                                                              color: textColor.withOpacity(0.1),
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(media.width * 0.01)),
                                                                        child:
                                                                            MyText(
                                                                          text: myHistory[i]
                                                                              [
                                                                              'request_number'],
                                                                          size: media.width *
                                                                              fourteen,
                                                                          fontweight:
                                                                              FontWeight.w600,
                                                                          color: (isDarkTheme == true)
                                                                              ? Colors.black
                                                                              : textColor,
                                                                        ),
                                                                      ),
                                                                      MyText(
                                                                        text: myHistory[i]
                                                                            [
                                                                            'accepted_at'],
                                                                        size: media.width *
                                                                            twelve,
                                                                        fontweight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: media
                                                                            .width *
                                                                        0.02,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        height: media.width *
                                                                            0.13,
                                                                        width: media.width *
                                                                            0.13,
                                                                        decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            image: DecorationImage(image: NetworkImage(myHistory[i]['driverDetail']['data']['profile_picture']), fit: BoxFit.cover)),
                                                                      ),
                                                                      SizedBox(
                                                                        width: media.width *
                                                                            0.02,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                media.width * 0.3,
                                                                            child:
                                                                                MyText(
                                                                              text: myHistory[i]['driverDetail']['data']['name'],
                                                                              size: media.width * eighteen,
                                                                              fontweight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Image.network(
                                                                              myHistory[i]['vehicle_type_image'].toString(),
                                                                              height: media.width * 0.1,
                                                                              width: media.width * 0.1,
                                                                              fit: BoxFit.contain,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: media
                                                                            .width *
                                                                        0.05,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        height: media.width *
                                                                            0.05,
                                                                        width: media.width *
                                                                            0.05,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration: const BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color: Colors.green),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              media.width * 0.025,
                                                                          width:
                                                                              media.width * 0.025,
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Colors.white.withOpacity(0.8)),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: media.width *
                                                                            0.06,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            MyText(
                                                                          text: myHistory[i]
                                                                              [
                                                                              'pick_address'],
                                                                          // maxLines:
                                                                          //     1,
                                                                          size: media.width *
                                                                              twelve,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: media
                                                                            .width *
                                                                        0.03,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        height: media.width *
                                                                            0.06,
                                                                        width: media.width *
                                                                            0.06,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color: Colors.red.withOpacity(0.1)),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .location_on_outlined,
                                                                          color:
                                                                              const Color(0xFFFF0000),
                                                                          size: media.width *
                                                                              eighteen,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: media.width *
                                                                            0.05,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            MyText(
                                                                          text: myHistory[i]
                                                                              [
                                                                              'drop_address'],
                                                                          size: media.width *
                                                                              twelve,
                                                                          // maxLines:
                                                                          //     1,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: media
                                                                            .width *
                                                                        0.02,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex:
                                                                            75,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.credit_card,
                                                                                color: textColor),
                                                                            SizedBox(
                                                                              width: media.width * 0.01,
                                                                            ),
                                                                            MyText(
                                                                              text: languages[choosenLanguage]['text_paymentmethod'],
                                                                              size: media.width * fourteen,
                                                                              fontweight: FontWeight.w600,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              25,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              MyText(
                                                                                text: (myHistory[i]['payment_opt'] == '1')
                                                                                    ? languages[choosenLanguage]['text_cash']
                                                                                    : (myHistory[i]['payment_opt'] == '2')
                                                                                        ? languages[choosenLanguage]['text_wallet']
                                                                                        : (myHistory[i]['payment_opt'] == '0')
                                                                                            ? languages[choosenLanguage]['text_card']
                                                                                            : '',
                                                                                size: media.width * fourteen,
                                                                                color: textColor.withOpacity(0.5),
                                                                              ),
                                                                            ],
                                                                          ))
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: media
                                                                            .width *
                                                                        0.02,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex:
                                                                            75,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.timer_sharp,
                                                                                color: textColor),
                                                                            SizedBox(
                                                                              width: media.width * 0.01,
                                                                            ),
                                                                            MyText(
                                                                              text: languages[choosenLanguage]['text_duration'],
                                                                              size: media.width * fourteen,
                                                                              fontweight: FontWeight.w600,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              25,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              MyText(
                                                                                text: (myHistory[i]['total_time'] < 50) ? '${myHistory[i]['total_time']} mins' : '${(myHistory[i]['total_time'] / 60).round()} hr',
                                                                                size: media.width * fourteen,
                                                                                color: textColor.withOpacity(0.5),
                                                                              ),
                                                                            ],
                                                                          ))
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: media
                                                                            .width *
                                                                        0.02,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex:
                                                                            75,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.route_sharp,
                                                                                color: textColor),
                                                                            SizedBox(
                                                                              width: media.width * 0.01,
                                                                            ),
                                                                            MyText(
                                                                              text: languages[choosenLanguage]['text_distance'],
                                                                              size: media.width * fourteen,
                                                                              fontweight: FontWeight.w600,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              25,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              MyText(
                                                                                text: (myHistory[i]['total_time'] < 50) ? myHistory[i]['total_distance'] + myHistory[i]['unit'] : myHistory[i]['total_distance'] + myHistory[i]['unit'],
                                                                                size: media.width * fourteen,
                                                                                color: textColor.withOpacity(0.5),
                                                                              ),
                                                                            ],
                                                                          ))
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: media
                                                                            .width *
                                                                        0.02,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex:
                                                                            75,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.receipt,
                                                                                color: textColor),
                                                                            SizedBox(
                                                                              width: media.width * 0.01,
                                                                            ),
                                                                            MyText(
                                                                              text: languages[choosenLanguage]['text_total'],
                                                                              size: media.width * fourteen,
                                                                              fontweight: FontWeight.w600,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              25,
                                                                          child:
                                                                              MyText(
                                                                            text:
                                                                                '${myHistory[i]['requestBill']['data']['requested_currency_symbol']} ${myHistory[i]['requestBill']['data']['total_amount'].toString()}',
                                                                            size:
                                                                                media.width * fourteen,
                                                                            fontweight:
                                                                                FontWeight.w600,
                                                                            maxLines:
                                                                                1,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : (_showHistory == 2)
                                                        ?

                                                        //rejected ride
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    top: media
                                                                            .width *
                                                                        0.025,
                                                                    bottom: media
                                                                            .width *
                                                                        0.05,
                                                                    left: media
                                                                            .width *
                                                                        0.015,
                                                                    right: media
                                                                            .width *
                                                                        0.015),
                                                                width: media
                                                                        .width *
                                                                    0.85,
                                                                padding: EdgeInsets.fromLTRB(
                                                                    media.width *
                                                                        0.025,
                                                                    media.width *
                                                                        0.05,
                                                                    media.width *
                                                                        0.025,
                                                                    media.width *
                                                                        0.05),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.1),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.all(media.width * 0.02),
                                                                          decoration: BoxDecoration(
                                                                              color: topBar,
                                                                              border: Border.all(
                                                                                color: textColor.withOpacity(0.1),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(media.width * 0.01)),
                                                                          child:
                                                                              MyText(
                                                                            text:
                                                                                myHistory[i]['request_number'],
                                                                            size:
                                                                                media.width * fourteen,
                                                                            fontweight:
                                                                                FontWeight.w600,
                                                                            color: (isDarkTheme == true)
                                                                                ? Colors.black
                                                                                : textColor,
                                                                          ),
                                                                        ),
                                                                        MyText(
                                                                          text:
                                                                              myHistory[i]['converted_cancelled_at'].toString(),
                                                                          size: media.width *
                                                                              twelve,
                                                                          fontweight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              textColor.withOpacity(0.3),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: media
                                                                              .width *
                                                                          0.02,
                                                                    ),
                                                                    (myHistory[i]['driverDetail'] !=
                                                                            null)
                                                                        ? Container(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: media.width * 0.05),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  height: media.width * 0.13,
                                                                                  width: media.width * 0.13,
                                                                                  decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(myHistory[i]['driverDetail']['data']['profile_picture']), fit: BoxFit.cover)),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: media.width * 0.02,
                                                                                ),
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                        width: media.width * 0.3,
                                                                                        child: MyText(
                                                                                          text: myHistory[i]['driverDetail']['data']['name'],
                                                                                          size: media.width * eighteen,
                                                                                          fontweight: FontWeight.w600,
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                                Expanded(
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      Image.network(
                                                                                        myHistory[i]['vehicle_type_image'].toString(),
                                                                                        height: media.width * 0.1,
                                                                                        width: media.width * 0.1,
                                                                                        fit: BoxFit.contain,
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              Image.asset(
                                                                                'assets/images/taxiride.png',
                                                                                height: media.width * 0.05,
                                                                                width: media.width * 0.1,
                                                                                fit: BoxFit.contain,
                                                                              )
                                                                            ],
                                                                          ),
                                                                    SizedBox(
                                                                      height: media
                                                                              .width *
                                                                          0.05,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              height: media.width * 0.05,
                                                                              width: media.width * 0.05,
                                                                              alignment: Alignment.center,
                                                                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                                                                              child: Container(
                                                                                height: media.width * 0.025,
                                                                                width: media.width * 0.025,
                                                                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.8)),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: media.width * 0.06,
                                                                            ),
                                                                            SizedBox(
                                                                              width: media.width * 0.5,
                                                                              child: MyText(
                                                                                text: myHistory[i]['pick_address'],
                                                                                size: media.width * twelve,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.all(media.width * 0.01),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.red.withOpacity(0.1),
                                                                              borderRadius: BorderRadius.circular(media.width * 0.01)),
                                                                          child:
                                                                              MyText(
                                                                            text:
                                                                                languages[choosenLanguage]['text_cancelled'],
                                                                            size:
                                                                                media.width * twelve,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    (myHistory[i]['drop_address'] !=
                                                                            null)
                                                                        ? Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(
                                                                                height: media.width * 0.03,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    height: media.width * 0.06,
                                                                                    width: media.width * 0.06,
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.1)),
                                                                                    child: Icon(Icons.location_on_outlined, color: const Color(0xFFFF0000), size: media.width * eighteen),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: media.width * 0.05,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: MyText(
                                                                                      text: myHistory[i]['drop_address'],
                                                                                      // overflow: TextOverflow.ellipsis,
                                                                                      size: media.width * twelve,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : Container(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : (_showHistory == 0)
                                                            ?

                                                            //upcoming ride
                                                            Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      (myHistory[i]['is_out_station'] ==
                                                                              1)
                                                                          ? MyText(
                                                                              text: languages[choosenLanguage]['text_outstation_ride'],
                                                                              size: media.width * sixteen,
                                                                              fontweight: FontWeight.w600,
                                                                            )
                                                                          : Container(),
                                                                      (myHistory[i]['is_driver_started'] ==
                                                                              1)
                                                                          ? Container()
                                                                          : InkWell(
                                                                              onTap: () async {
                                                                                setState(() {
                                                                                  _cancelRide = true;
                                                                                  inti = i;
                                                                                  _cancelId = myHistory[i]['id'];
                                                                                });
                                                                              },
                                                                              child: MyText(
                                                                                text: languages[choosenLanguage]['text_cancel_ride'],
                                                                                size: media.width * sixteen,
                                                                                fontweight: FontWeight.w600,
                                                                                color: buttonColor,
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {},
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: media.width *
                                                                              0.025,
                                                                          bottom: media.width *
                                                                              0.05,
                                                                          left: media.width *
                                                                              0.015,
                                                                          right:
                                                                              media.width * 0.015),
                                                                      width: media
                                                                              .width *
                                                                          0.85,
                                                                      padding: EdgeInsets.fromLTRB(
                                                                          media.width *
                                                                              0.025,
                                                                          media.width *
                                                                              0.05,
                                                                          media.width *
                                                                              0.025,
                                                                          media.width *
                                                                              0.05),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.1),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          (myHistory[i]['driverDetail'] != null)
                                                                              ? Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: media.width * 0.3,
                                                                                    ),
                                                                                    Container(
                                                                                      alignment: Alignment.centerRight,
                                                                                      padding: EdgeInsets.all(media.width * 0.01),
                                                                                      decoration: BoxDecoration(
                                                                                          color: (myHistory[i]['accepted_at'] != null && myHistory[i]['is_driver_arrived'] == 0)
                                                                                              ? Colors.yellow
                                                                                              : (myHistory[i]['is_driver_arrived'] == 1 && myHistory[i]['is_trip_start'] == 0)
                                                                                                  ? Colors.orange
                                                                                                  : online,
                                                                                          borderRadius: BorderRadius.circular(media.width * 0.01)),
                                                                                      child: MyText(
                                                                                          text: (myHistory[i]['accepted_at'] != null && myHistory[i]['is_driver_arrived'] == 0)
                                                                                              ? 'Accepted'
                                                                                              : (myHistory[i]['is_driver_arrived'] == 1 && myHistory[i]['is_trip_start'] == 0)
                                                                                                  ? 'Arrived'
                                                                                                  : (myHistory[i]['is_completed'] == 1)
                                                                                                      ? 'Completed'
                                                                                                      : 'Trip Started',
                                                                                          size: media.width * fourteen),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: MyText(
                                                                                        textAlign: TextAlign.end,
                                                                                        text: 'Otp : ${myHistory[i]['ride_otp']}',
                                                                                        size: media.width * twelve,
                                                                                        fontweight: FontWeight.w600,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              : Container(),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              MyText(text: myHistory[i]['request_number'], size: media.width * sixteen, fontweight: FontWeight.w600, color: textColor),
                                                                              (myHistory[i]['driverDetail'] != null)
                                                                                  ? Image.network(
                                                                                      myHistory[i]['vehicle_type_image'].toString(),
                                                                                      height: media.width * 0.1,
                                                                                      width: media.width * 0.1,
                                                                                      fit: BoxFit.contain,
                                                                                    )
                                                                                  : Container()
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                media.width * 0.02,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              MyText(
                                                                                text: myHistory[i]['trip_start_time'],
                                                                                size: media.width * fourteen,
                                                                                fontweight: FontWeight.w600,
                                                                              ),
                                                                              (myHistory[i]['is_round_trip'] == 1)
                                                                                  ? MyText(
                                                                                      text: ' TO ${myHistory[i]['return_time']}',
                                                                                      size: media.width * fourteen,
                                                                                      fontweight: FontWeight.w600,
                                                                                    )
                                                                                  : Container(),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                media.width * 0.02,
                                                                          ),
                                                                          (myHistory[i]['driverDetail'] != null)
                                                                              ? Container(
                                                                                  padding: EdgeInsets.only(bottom: media.width * 0.05),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: media.width * 0.16,
                                                                                        width: media.width * 0.16,
                                                                                        decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(myHistory[i]['driverDetail']['data']['profile_picture']), fit: BoxFit.cover)),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: media.width * 0.02,
                                                                                      ),
                                                                                      Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: media.width * 0.3,
                                                                                            child: MyText(
                                                                                              text: myHistory[i]['driverDetail']['data']['name'],
                                                                                              size: media.width * eighteen,
                                                                                              fontweight: FontWeight.w600,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                                          children: [
                                                                                            MyText(
                                                                                              text: languages[choosenLanguage]['text_assigned'],
                                                                                              size: media.width * fourteen,
                                                                                              fontweight: FontWeight.w600,
                                                                                              color: online,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              : Container(),
                                                                          (myHistory[i]['drop_address'] != null)
                                                                              ? Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      flex: 60,
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Icon(Icons.receipt, color: textColor),
                                                                                          SizedBox(
                                                                                            width: media.width * 0.01,
                                                                                          ),
                                                                                          MyText(
                                                                                            text: languages[choosenLanguage]['text_total'],
                                                                                            size: media.width * fourteen,
                                                                                            fontweight: FontWeight.w600,
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                        flex: 30,
                                                                                        child: MyText(
                                                                                          textAlign: TextAlign.end,
                                                                                          text: '${userDetails['currency_symbol']} ${myHistory[i]['request_eta_amount'].toString()}',
                                                                                          size: media.width * fourteen,
                                                                                          fontweight: FontWeight.w600,
                                                                                          maxLines: 1,
                                                                                        ))
                                                                                  ],
                                                                                )
                                                                              : Container(),
                                                                          SizedBox(
                                                                            height:
                                                                                media.width * 0.02,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                height: media.width * 0.05,
                                                                                width: media.width * 0.05,
                                                                                alignment: Alignment.center,
                                                                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                                                                                child: Container(
                                                                                  height: media.width * 0.025,
                                                                                  width: media.width * 0.025,
                                                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.8)),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: media.width * 0.06,
                                                                              ),
                                                                              Expanded(
                                                                                child: MyText(
                                                                                  text: myHistory[i]['pick_address'],
                                                                                  // maxLines: 1,
                                                                                  size: media.width * twelve,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                media.width * 0.02,
                                                                          ),
                                                                          (myHistory[i]['drop_address'] != null)
                                                                              ? Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      height: media.width * 0.03,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                          height: media.width * 0.06,
                                                                                          width: media.width * 0.06,
                                                                                          alignment: Alignment.center,
                                                                                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.1)),
                                                                                          child: Icon(Icons.location_on_outlined, color: const Color(0xFFFF0000), size: media.width * eighteen),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: media.width * 0.05,
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: MyText(
                                                                                            text: myHistory[i]['drop_address'],
                                                                                            size: media.width * twelve,
                                                                                            // maxLines: 1,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              : Container(),
                                                                          (myHistory[i]['goods_type'] != '-')
                                                                              ? MyText(
                                                                                  text: myHistory[i]['goods_type'],
                                                                                  size: media.width * twelve,
                                                                                  color: verifyDeclined,
                                                                                )
                                                                              : Container(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container());
                                          })
                                          .values
                                          .toList(),
                                    )
                                  : (_isLoading == false)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: media.width * 0.05,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: media.width * 0.7,
                                              width: media.width * 0.7,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/noorder.png'),
                                                      fit: BoxFit.contain)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: media.width * 0.07,
                                                  ),
                                                  SizedBox(
                                                    width: media.width * 0.2,
                                                    child: MyText(
                                                        text: languages[
                                                                choosenLanguage]
                                                            ['text_noorder'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        fontweight:
                                                            FontWeight.w800,
                                                        size: media.width *
                                                            sixteen),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                              (myHistoryPage['pagination'] != null)
                                  ? (myHistoryPage['pagination']
                                              ['current_page'] <
                                          myHistoryPage['pagination']
                                              ['total_pages'])
                                      ? InkWell(
                                          onTap: () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            if (_showHistory == 0) {
                                              await getHistoryPages(
                                                  'is_later=1&page=${myHistoryPage['pagination']['current_page'] + 1}');
                                            } else if (_showHistory == 1) {
                                              await getHistoryPages(
                                                  'is_completed=1&page=${myHistoryPage['pagination']['current_page'] + 1}');
                                            } else if (_showHistory == 2) {
                                              await getHistoryPages(
                                                  'is_cancelled=1&page=${myHistoryPage['pagination']['current_page'] + 1}');
                                            }
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                media.width * 0.025),
                                            margin: EdgeInsets.only(
                                                bottom: media.width * 0.05),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: page,
                                                border: Border.all(
                                                    color: borderLines,
                                                    width: 1.2)),
                                            child: MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_loadmore'],
                                              size: media.width * sixteen,
                                            ),
                                          ),
                                        )
                                      : Container()
                                  : Container()
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),

                  (_cancelRide == true)
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
                                      Container(
                                          height: media.height * 0.1,
                                          width: media.width * 0.1,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: page),
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _cancelRide = false;
                                                  _cancelId = '';
                                                });
                                              },
                                              child: Icon(
                                                Icons.cancel_outlined,
                                                color: textColor,
                                              ))),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(media.width * 0.05),
                                  width: media.width * 0.9,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: page),
                                  child: Column(
                                    children: [
                                      MyText(
                                        text: languages[choosenLanguage]
                                            ['text_ridecancel'],
                                        size: media.width * eighteen,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      Button(
                                          onTap: () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            await cancelLaterRequest(_cancelId);
                                            // if (myHistory[inti!]
                                            //         ['is_out_station'] ==
                                            //     1) {
                                            //   FirebaseDatabase.instance
                                            //       .ref('bid-meta/$_cancelId')
                                            //       .remove();
                                            // }
                                            await _getHistory();
                                            setState(() {
                                              _cancelRide = false;
                                              _cancelId = '';
                                            });
                                          },
                                          text: languages[choosenLanguage]
                                              ['text_cancel_ride'])
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),

                  //no internet
                  (internet == false)
                      ? Positioned(
                          top: 0,
                          child: NoInternet(
                            onTap: () {
                              setState(() {
                                internetTrue();
                              });
                            },
                          ))
                      : Container(),

                  //loader
                  (_isLoading == true)
                      ? const Positioned(top: 0, child: Loading())
                      : Container()
                ],
              ),
            );
          }),
    ));
  }
}
