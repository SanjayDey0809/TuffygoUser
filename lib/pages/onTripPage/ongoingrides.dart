import 'package:flutter/material.dart';
import 'package:flutter_user/pages/loadingPage/loading.dart';
import 'package:flutter_user/pages/onTripPage/booking_confirmation.dart';
import 'package:flutter_user/pages/onTripPage/map_page.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/translations/translation.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../functions/functions.dart';

class OnGoingRides extends StatefulWidget {
  const OnGoingRides({super.key});

  @override
  State<OnGoingRides> createState() => _OnGoingRidesState();
}

class _OnGoingRidesState extends State<OnGoingRides> {
  bool _isLoading = true;
  final List _tripStops = [];
  @override
  void initState() {
    getHistoryData();
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

  getHistoryData() async {
    setState(() {
      _isLoading = true;
      myHistoryPage.clear();
      myHistory.clear();
    });
    var val = await getHistory('on_trip=1');
    if (val == 'success' && myHistory.isNotEmpty) {
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
        color: Colors.blue,
        onRefresh: () async {
          setState(() {
            _isLoading = true;
            myHistoryPage.clear();
            myHistory.clear();
          });
          var val = await getHistory('on_trip=1');
          if (val == 'success' && myHistory.isNotEmpty) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: SizedBox(
            height: media.height * 1,
            width: media.width * 1,
            child: Stack(
              children: [
                Container(
                  height: media.height * 1,
                  width: media.width * 1,
                  color: page,
                  padding: EdgeInsets.fromLTRB(media.width * 0.05,
                      media.width * 0.05, media.width * 0.05, 0),
                  child: Column(children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: media.width * 0.05),
                          width: media.width * 1,
                          alignment: Alignment.center,
                          child: MyText(
                            text: 'On Going Rides',
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

                                            //completed ride history
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    addressList.clear();
                                                    // selectedHistory = i;
                                                    addressList.add(AddressList(
                                                      id: '1',
                                                      type: 'pickup',
                                                      address: myHistory[i]
                                                          ['pick_address'],
                                                      pickup: true,
                                                      latlng: LatLng(
                                                          myHistory[i]
                                                              ['pick_lat'],
                                                          myHistory[i]
                                                              ['pick_lng']),
                                                    ));
                                                    if (_tripStops.isNotEmpty) {
                                                      for (var i = 0;
                                                          i < _tripStops.length;
                                                          i++) {
                                                        addressList.add(AddressList(
                                                            id: _tripStops[i]
                                                                    ['id']
                                                                .toString(),
                                                            type: 'drop',
                                                            address:
                                                                _tripStops[i]
                                                                    ['address'],
                                                            latlng: LatLng(
                                                                _tripStops[i][
                                                                    'latitude'],
                                                                _tripStops[i][
                                                                    'longitude']),
                                                            pickup: false));
                                                      }
                                                    }

                                                    if (myHistory[i][
                                                                'drop_address'] !=
                                                            null &&
                                                        _tripStops.isEmpty) {
                                                      addressList.add(AddressList(
                                                          id: '2',
                                                          type: 'drop',
                                                          pickup: false,
                                                          address: myHistory[i]
                                                              ['drop_address'],
                                                          latlng: LatLng(
                                                              myHistory[i]
                                                                  ['drop_lat'],
                                                              myHistory[i][
                                                                  'drop_lng'])));
                                                    }

                                                    ismulitipleride = true;

                                                    var val =
                                                        await getUserDetails(
                                                            id: myHistory[i]
                                                                ['id']);

                                                    //login page
                                                    if (val == true) {
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      if (myHistory[i]
                                                              ['is_rental'] ==
                                                          true) {
                                                        naviagterental();
                                                      } else if (myHistory[i][
                                                                  'is_rental'] ==
                                                              false &&
                                                          myHistory[i][
                                                                  'drop_address'] ==
                                                              null) {
                                                        naviagteridewithoutdestini();
                                                      } else {
                                                        navigate();
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top:
                                                            media.width * 0.025,
                                                        bottom:
                                                            media.width * 0.05,
                                                        left:
                                                            media.width * 0.015,
                                                        right: media.width *
                                                            0.015),
                                                    width: media.width * 0.85,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            media.width * 0.025,
                                                            media.width * 0.025,
                                                            media.width * 0.025,
                                                            media.width * 0.05),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          // mainAxisAlignment:
                                                          //     MainAxisAlignment
                                                          //         .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  media.width *
                                                                      0.3,
                                                            ),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              padding: EdgeInsets
                                                                  .all(media
                                                                          .width *
                                                                      0.01),
                                                              decoration: BoxDecoration(
                                                                  color: (myHistory[i]['accepted_at'] != null && myHistory[i]['is_driver_arrived'] == 0)
                                                                      ? Colors.yellow
                                                                      : (myHistory[i]['is_driver_arrived'] == 1 && myHistory[i]['is_trip_start'] == 0)
                                                                          ? Colors.orange
                                                                          : online,
                                                                  borderRadius: BorderRadius.circular(media.width * 0.01)),
                                                              child: MyText(
                                                                  text: (myHistory[i]['accepted_at'] !=
                                                                              null &&
                                                                          myHistory[i]['is_driver_arrived'] ==
                                                                              0)
                                                                      ? 'Accepted'
                                                                      : (myHistory[i]['is_driver_arrived'] == 1 &&
                                                                              myHistory[i]['is_trip_start'] ==
                                                                                  0)
                                                                          ? 'Arrived'
                                                                          : (myHistory[i]['is_completed'] ==
                                                                                  1)
                                                                              ? 'Completed'
                                                                              : 'Trip Started',
                                                                  size: media
                                                                          .width *
                                                                      fourteen),
                                                            ),
                                                            (userRequestData[
                                                                        'show_otp_feature'] ==
                                                                    true)
                                                                ? Expanded(
                                                                    child:
                                                                        MyText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .end,
                                                                      text:
                                                                          'Otp : ${myHistory[i]['ride_otp']}',
                                                                      size: media
                                                                              .width *
                                                                          twelve,
                                                                      fontweight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .all(media
                                                                          .width *
                                                                      0.02),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color:
                                                                          topBar,
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: textColor
                                                                            .withOpacity(0.1),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(media.width *
                                                                              0.01)),
                                                              child: MyText(
                                                                text: myHistory[
                                                                        i][
                                                                    'request_number'],
                                                                size: media
                                                                        .width *
                                                                    fourteen,
                                                                fontweight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: (isDarkTheme ==
                                                                        true)
                                                                    ? Colors
                                                                        .black
                                                                    : textColor,
                                                              ),
                                                            ),
                                                            MyText(
                                                              text: myHistory[i]
                                                                  [
                                                                  'accepted_at'],
                                                              size:
                                                                  media.width *
                                                                      twelve,
                                                              fontweight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height:
                                                                  media.width *
                                                                      0.13,
                                                              width:
                                                                  media.width *
                                                                      0.13,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(myHistory[i]['driverDetail']
                                                                              [
                                                                              'data']
                                                                          [
                                                                          'profile_picture']),
                                                                      fit: BoxFit
                                                                          .cover)),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  media.width *
                                                                      0.02,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.3,
                                                                  child: MyText(
                                                                    text: myHistory[i]['driverDetail']
                                                                            [
                                                                            'data']
                                                                        [
                                                                        'name'],
                                                                    size: media
                                                                            .width *
                                                                        eighteen,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Image
                                                                          .network(
                                                                        myHistory[i]['vehicle_type_image']
                                                                            .toString(),
                                                                        width: media.width *
                                                                            0.1,
                                                                      ),
                                                                      SizedBox(
                                                                        height: media.width *
                                                                            0.01,
                                                                      ),
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            2),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                topBar,
                                                                            borderRadius:
                                                                                BorderRadius.circular(media.width * 0.01)),
                                                                        child:
                                                                            MyText(
                                                                          text: myHistory[i]
                                                                              [
                                                                              'vehicle_type_name'],
                                                                          size: media.width *
                                                                              twelve,
                                                                          fontweight:
                                                                              FontWeight.w600,
                                                                          color: (isDarkTheme == true)
                                                                              ? Colors.black
                                                                              : textColor,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          width:
                                                              media.width * 0.9,
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                MyText(
                                                                  text: myHistory[i]['driverDetail']
                                                                              [
                                                                              'data']
                                                                          [
                                                                          'car_number']
                                                                      .toString(),
                                                                  size: media
                                                                          .width *
                                                                      twelve,
                                                                  fontweight:
                                                                      FontWeight
                                                                          .w600,
                                                                  maxLines: 1,
                                                                ),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.01,
                                                                ),
                                                                Container(
                                                                  height: media
                                                                          .width *
                                                                      0.05,
                                                                  width: 2,
                                                                  color:
                                                                      textColor,
                                                                ),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.01,
                                                                ),
                                                                MyText(
                                                                  text: myHistory[
                                                                              i]
                                                                          [
                                                                          'car_make_name']
                                                                      .toString(),
                                                                  size: media
                                                                          .width *
                                                                      twelve,
                                                                  fontweight:
                                                                      FontWeight
                                                                          .w600,
                                                                  maxLines: 1,
                                                                ),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.01,
                                                                ),
                                                                Container(
                                                                  height: media
                                                                          .width *
                                                                      0.05,
                                                                  width: 2,
                                                                  color:
                                                                      textColor,
                                                                ),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.01,
                                                                ),
                                                                MyText(
                                                                  text: myHistory[
                                                                              i]
                                                                          [
                                                                          'car_model_name']
                                                                      .toString(),
                                                                  size: media
                                                                          .width *
                                                                      twelve,
                                                                  fontweight:
                                                                      FontWeight
                                                                          .w600,
                                                                  maxLines: 1,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.03,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height:
                                                                  media.width *
                                                                      0.05,
                                                              width:
                                                                  media.width *
                                                                      0.05,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .green),
                                                              child: Container(
                                                                height: media
                                                                        .width *
                                                                    0.025,
                                                                width: media
                                                                        .width *
                                                                    0.025,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.8)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  media.width *
                                                                      0.06,
                                                            ),
                                                            Expanded(
                                                              child: MyText(
                                                                text: myHistory[
                                                                        i][
                                                                    'pick_address'],
                                                                // maxLines:
                                                                //     1,
                                                                size: media
                                                                        .width *
                                                                    twelve,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Column(
                                                          children: _tripStops
                                                              .asMap()
                                                              .map((i, value) {
                                                                return MapEntry(
                                                                    i,
                                                                    (i < _tripStops.length - 1)
                                                                        ? Column(
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    height: media.width * 0.06,
                                                                                    width: media.width * 0.06,
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.1)),
                                                                                    child: MyText(
                                                                                      text: (i + 1).toString(),
                                                                                      size: media.width * twelve,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: media.width * 0.05,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: MyText(
                                                                                      text: _tripStops[i]['address'],
                                                                                      size: media.width * twelve,
                                                                                      // maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: media.width * 0.02,
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : Container());
                                                              })
                                                              .values
                                                              .toList(),
                                                        ),
                                                        (myHistory[i][
                                                                    'drop_address'] !=
                                                                null)
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    height: media
                                                                            .width *
                                                                        0.06,
                                                                    width: media
                                                                            .width *
                                                                        0.06,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .red
                                                                            .withOpacity(0.1)),
                                                                    child: Icon(
                                                                      Icons
                                                                          .location_on_outlined,
                                                                      color: const Color(
                                                                          0xFFFF0000),
                                                                      size: media
                                                                              .width *
                                                                          eighteen,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: media
                                                                            .width *
                                                                        0.05,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        MyText(
                                                                      text: myHistory[
                                                                              i]
                                                                          [
                                                                          'drop_address'],
                                                                      size: media
                                                                              .width *
                                                                          twelve,
                                                                      // maxLines:
                                                                      //     1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 60,
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .cached_rounded,
                                                                      color:
                                                                          textColor),
                                                                  SizedBox(
                                                                    width: media
                                                                            .width *
                                                                        0.01,
                                                                  ),
                                                                  MyText(
                                                                    text:
                                                                        'Ride Type',
                                                                    size: media
                                                                            .width *
                                                                        fourteen,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w600,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                                flex: 30,
                                                                child: Row(
                                                                  children: [
                                                                    MyText(
                                                                      text: (myHistory[i]['is_out_station'] ==
                                                                              1)
                                                                          ? languages[choosenLanguage]
                                                                              [
                                                                              'text_outstation']
                                                                          : (myHistory[i]['is_rental'] == true)
                                                                              ? languages[choosenLanguage]['text_rental']
                                                                              : 'normal',
                                                                      size: media
                                                                              .width *
                                                                          fourteen,
                                                                      color: textColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                    ),
                                                                  ],
                                                                ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 60,
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .credit_card,
                                                                      color:
                                                                          textColor),
                                                                  SizedBox(
                                                                    width: media
                                                                            .width *
                                                                        0.01,
                                                                  ),
                                                                  MyText(
                                                                    text: languages[
                                                                            choosenLanguage]
                                                                        [
                                                                        'text_paymentmethod'],
                                                                    size: media
                                                                            .width *
                                                                        fourteen,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w600,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                                flex: 30,
                                                                child: Row(
                                                                  children: [
                                                                    MyText(
                                                                      text: (myHistory[i]['payment_opt'] ==
                                                                              '1')
                                                                          ? languages[choosenLanguage]
                                                                              [
                                                                              'text_cash']
                                                                          : (myHistory[i]['payment_opt'] == '2')
                                                                              ? languages[choosenLanguage]['text_wallet']
                                                                              : (myHistory[i]['payment_opt'] == '0')
                                                                                  ? languages[choosenLanguage]['text_card']
                                                                                  : '',
                                                                      size: media
                                                                              .width *
                                                                          fourteen,
                                                                      color: textColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                    ),
                                                                  ],
                                                                ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        (myHistory[i][
                                                                    'drop_address'] !=
                                                                null)
                                                            ? Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 60,
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .receipt,
                                                                            color:
                                                                                textColor),
                                                                        SizedBox(
                                                                          width:
                                                                              media.width * 0.01,
                                                                        ),
                                                                        MyText(
                                                                          text: languages[choosenLanguage]
                                                                              [
                                                                              'text_total'],
                                                                          size: media.width *
                                                                              fourteen,
                                                                          fontweight:
                                                                              FontWeight.w600,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                      flex: 30,
                                                                      child:
                                                                          MyText(
                                                                        text:
                                                                            '${userDetails['currency_symbol']} ${myHistory[i]['request_eta_amount'].toString()}',
                                                                        size: media.width *
                                                                            fourteen,
                                                                        fontweight:
                                                                            FontWeight.w600,
                                                                        maxLines:
                                                                            1,
                                                                      ))
                                                                ],
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ));
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
                                                    textAlign: TextAlign.center,
                                                    fontweight: FontWeight.w800,
                                                    size:
                                                        media.width * sixteen),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()
                        ],
                      ),
                    ))
                  ]),
                ),
                //loader
                (_isLoading == true)
                    ? const Positioned(top: 0, child: Loading())
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
