import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocs;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/login.dart';
import '../noInternet/noInternet.dart';
import 'booking_confirmation.dart';
import 'map_page.dart';

// ignore: must_be_immutable
class DropLocation extends StatefulWidget {
  dynamic from;
  DropLocation({Key? key, this.from}) : super(key: key);

  @override
  State<DropLocation> createState() => _DropLocationState();
}

class _DropLocationState extends State<DropLocation>
    with WidgetsBindingObserver {
  GoogleMapController? _controller;
  late PermissionStatus permission;
  Location location = Location();
  String _state = '';
  dynamic _lastCenter;
  bool _isLoading = false;
  String sessionToken = const Uuid().v4();
  LatLng _center = const LatLng(41.4219057, -102.0840772);
  LatLng _centerLocation = const LatLng(41.4219057, -102.0840772);
  TextEditingController search = TextEditingController();
  String favNameText = '';
  bool _locationDenied = false;
  bool favAddressAdd = false;
  final _debouncer = Debouncer(milliseconds: 1000);

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      _controller?.setMapStyle(mapStyle);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    dropAddressConfirmation = '';
    getLocs();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        _controller?.setMapStyle(mapStyle);
      }
      if (locationAllowed == true) {
        if (positionStream == null || positionStream!.isPaused) {
          positionStreamData();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;

    super.dispose();
  }

  getLocs() async {
    permission = await location.hasPermission();

    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      setState(() {
        _state = '3';
        _isLoading = false;
      });
    } else if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited) {
      var locs = await geolocs.Geolocator.getLastKnownPosition();
      if (addressList.length != 2 && widget.from == null) {
        if (locs != null) {
          setState(() {
            _center = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));
            _centerLocation = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));
          });
        } else {
          var loc = await geolocs.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocs.LocationAccuracy.low);
          setState(() {
            _center = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
            _centerLocation = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
          });
        }
        var val = await geoCoding(
            _centerLocation.latitude, _centerLocation.longitude);
        setState(() {
          _center = _centerLocation;
          dropAddressConfirmation = val;
        });
      } else if (widget.from != null && widget.from != 'add stop') {
        setState(() {
          _center = addressList[int.parse(widget.from) - 1].latlng;
          _centerLocation = addressList[int.parse(widget.from) - 1].latlng;
          dropAddressConfirmation =
              addressList[int.parse(widget.from) - 1].address;
        });
      } else if (widget.from == 'add stop') {
        if (locs != null) {
          setState(() {
            _center = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));
            _centerLocation = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));
          });
        } else {
          var loc = await geolocs.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocs.LocationAccuracy.low);
          setState(() {
            _center = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
            _centerLocation = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
          });
        }
      } else {
        setState(() {
          _center = addressList.firstWhere((e) => e.type == 'drop').latlng;
          _centerLocation =
              addressList.firstWhere((e) => e.type == 'drop').latlng;
          if (addressList.length >= 2) {
            dropAddressConfirmation = addressList
                .firstWhere((element) => element.type == 'drop')
                .address;
          }
        });
      }

      setState(() {
        _state = '3';
        _isLoading = false;
      });
    }
  }

  navigateLogout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: true,
      child: Material(
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              return Directionality(
                textDirection: (languageDirection == 'rtl')
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Container(
                  height: media.height * 1,
                  width: media.width * 1,
                  color: page,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: media.height * 1,
                        width: media.width * 1,
                        child: (_state == '3')
                            ? GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: _center,
                                  zoom: 14.0,
                                ),
                                onCameraMove: (CameraPosition position) {
                                  //pick current location
                                  // setState(() {
                                  _centerLocation = position.target;
                                  // });
                                },
                                onCameraIdle: () async {
                                  setState(() {});
                                },
                                minMaxZoomPreference:
                                    const MinMaxZoomPreference(8.0, 20.0),
                                myLocationButtonEnabled: false,
                                buildingsEnabled: false,
                                zoomControlsEnabled: false,
                                myLocationEnabled: true,
                              )
                            : (_state == '2')
                                ? Container(
                                    height: media.height * 1,
                                    width: media.width * 1,
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(media.width * 0.05),
                                      width: media.width * 0.6,
                                      height: media.width * 0.3,
                                      decoration: BoxDecoration(
                                          color: page,
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 5,
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 2)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            languages[choosenLanguage]
                                                ['text_loc_permission'],
                                            style: GoogleFonts.notoSans(
                                                fontSize: media.width * sixteen,
                                                color: textColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  _state = '';
                                                });
                                                await location
                                                    .requestPermission();
                                                getLocs();
                                              },
                                              child: Text(
                                                languages[choosenLanguage]
                                                    ['text_ok'],
                                                style: GoogleFonts.notoSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        media.width * twenty,
                                                    color: buttonColor),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                      ),
                      Positioned(
                          child: Container(
                        height: media.height * 1,
                        width: media.width * 1,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(
                              height: (media.height / 2) - media.width * 0.08,
                            ),
                            Image.asset(
                              'assets/images/dropmarker.png',
                              width: media.width * 0.07,
                              height: media.width * 0.08,
                            ),
                            SizedBox(
                              height: media.width * 0.025,
                            ),
                            if (_lastCenter != _centerLocation)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Button(
                                    onTap: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      var val = await geoCoding(
                                          _centerLocation.latitude,
                                          _centerLocation.longitude);
                                      print(val.toString());
                                      setState(() {
                                        _center = _centerLocation;
                                        _lastCenter = _centerLocation;
                                        dropAddressConfirmation = val;
                                        _isLoading = false;
                                      });
                                    },
                                    text: languages[choosenLanguage]
                                        ['text_confirm'],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      )),
                      Positioned(
                        bottom: 0 + MediaQuery.of(context).viewInsets.bottom,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: InkWell(
                                onTap: () async {
                                  if (locationAllowed == true) {
                                    if (currentLocation != null) {
                                      _controller?.animateCamera(
                                          CameraUpdate.newLatLngZoom(
                                              currentLocation, 18.0));
                                      center = currentLocation;
                                    } else {
                                      _controller?.animateCamera(
                                          CameraUpdate.newLatLngZoom(
                                              center, 18.0));
                                    }
                                  } else {
                                    if (serviceEnabled == true) {
                                      setState(() {
                                        _locationDenied = true;
                                      });
                                    } else {
                                      // await location.requestService();
                                      await geolocs.Geolocator
                                          .getCurrentPosition(
                                              desiredAccuracy:
                                                  geolocs.LocationAccuracy.low);
                                      if (await geolocs
                                          .GeolocatorPlatform.instance
                                          .isLocationServiceEnabled()) {
                                        setState(() {
                                          _locationDenied = true;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  height: media.width * 0.1,
                                  width: media.width * 0.1,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2)
                                      ],
                                      color: page,
                                      borderRadius: BorderRadius.circular(
                                          media.width * 0.02)),
                                  child: Icon(Icons.my_location_sharp,
                                      color: textColor),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: media.width * 0.1,
                            ),
                            Container(
                              color: page,
                              width: media.width * 1,
                              padding: EdgeInsets.all(media.width * 0.05),
                              child: Column(
                                children: [
                                  Container(
                                      padding: EdgeInsets.fromLTRB(
                                          media.width * 0.03,
                                          media.width * 0.01,
                                          media.width * 0.03,
                                          media.width * 0.01),
                                      height: media.width * 0.1,
                                      width: media.width * 0.9,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.02),
                                          color: page),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: media.width * 0.04,
                                            width: media.width * 0.04,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(0xffFF0000)
                                                    .withOpacity(0.3)),
                                            child: Container(
                                              height: media.width * 0.02,
                                              width: media.width * 0.02,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xffFF0000)),
                                            ),
                                          ),
                                          SizedBox(width: media.width * 0.02),
                                          Expanded(
                                            child: (dropAddressConfirmation ==
                                                    '')
                                                ? Text(
                                                    languages[choosenLanguage][
                                                        'text_pickdroplocation'],
                                                    style: GoogleFonts.notoSans(
                                                        fontSize: media.width *
                                                            twelve,
                                                        color: hintColor),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            media.width * 0.7,
                                                        child: Text(
                                                          dropAddressConfirmation,
                                                          style: GoogleFonts
                                                              .notoSans(
                                                            fontSize:
                                                                media.width *
                                                                    twelve,
                                                            color: textColor,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      (favAddress.length < 4)
                                                          ? InkWell(
                                                              onTap: () async {
                                                                if (favAddress
                                                                    .where((element) =>
                                                                        element[
                                                                            'pick_address'] ==
                                                                        dropAddressConfirmation)
                                                                    .isEmpty) {
                                                                  setState(() {
                                                                    favSelectedAddress =
                                                                        dropAddressConfirmation;
                                                                    favLat = _center
                                                                        .latitude;
                                                                    favLng = _center
                                                                        .longitude;
                                                                    favAddressAdd =
                                                                        true;
                                                                  });
                                                                }
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .favorite_outline,
                                                                size: media
                                                                        .width *
                                                                    0.05,
                                                                color: favAddress
                                                                        .where((element) =>
                                                                            element['pick_address'] ==
                                                                            dropAddressConfirmation)
                                                                        .isEmpty
                                                                    ? (isDarkTheme ==
                                                                            true)
                                                                        ? Colors
                                                                            .white
                                                                        : textColor
                                                                    : buttonColor,
                                                              ),
                                                            )
                                                          : Container()
                                                    ],
                                                  ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: media.width * 0.03,
                                  ),
                                  Button(
                                      onTap: () async {
                                        if (dropAddressConfirmation != '') {
                                          //remove in envato
                                          if (widget.from == null) {
                                            if (addressList
                                                .where((element) =>
                                                    element.type == 'drop')
                                                .isEmpty) {
                                              addressList.add(AddressList(
                                                id: (addressList.length + 1)
                                                    .toString(),
                                                type: 'drop',
                                                address:
                                                    dropAddressConfirmation,
                                                latlng: _center,
                                                pickup: false,
                                              ));
                                            } else {
                                              addressList
                                                      .firstWhere(
                                                          (element) =>
                                                              element.type ==
                                                              'drop')
                                                      .address =
                                                  dropAddressConfirmation;
                                              addressList
                                                  .firstWhere((element) =>
                                                      element.type == 'drop')
                                                  .latlng = _center;
                                            }
                                          } else if (widget.from != null) {
                                            if (widget.from != null &&
                                                widget.from != 'add stop') {
                                              addressList[int.parse(
                                                              widget.from) -
                                                          1]
                                                      .address =
                                                  dropAddressConfirmation;
                                              addressList[
                                                      int.parse(widget.from) -
                                                          1]
                                                  .latlng = _center;
                                            } else if (widget.from ==
                                                'add stop') {
                                              var address = addressList[
                                                      addressList.length - 1]
                                                  .address;
                                              var type = addressList[
                                                      addressList.length - 1]
                                                  .type;

                                              var pickup = addressList[
                                                      addressList.length - 1]
                                                  .pickup;
                                              var id = addressList[
                                                      addressList.length - 1]
                                                  .id;
                                              var latlng = addressList[
                                                      addressList.length - 1]
                                                  .latlng;

                                              addressList[addressList.length -
                                                          1]
                                                      .id =
                                                  (addressList.length + 1)
                                                      .toString();
                                              addressList[
                                                      addressList.length - 1]
                                                  .type = 'drop';
                                              addressList[addressList.length -
                                                          1]
                                                      .address =
                                                  dropAddressConfirmation;
                                              addressList[
                                                      addressList.length - 1]
                                                  .latlng = _center;

                                              addressList[
                                                      addressList.length - 1]
                                                  .pickup = false;

                                              addressList.add(AddressList(
                                                  id: id,
                                                  type: type,
                                                  address: address,
                                                  latlng: latlng,
                                                  pickup: pickup));
                                            }
                                            Navigator.pop(context, true);
                                          }
                                          if (addressList.length >= 2 &&
                                              widget.from == null) {
                                            var val =
                                                await Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BookingConfirmation()));
                                            if (val) {
                                              setState(() {});
                                            }
                                          }
                                        }
                                      },
                                      text: languages[choosenLanguage]
                                          ['text_confirm'])
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //autofill address
                      Positioned(
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                media.width * 0.05,
                                MediaQuery.of(context).padding.top + 12.5,
                                media.width * 0.05,
                                0),
                            width: media.width * 1,
                            height: (addAutoFill.isNotEmpty)
                                ? media.height * 0.6
                                : null,
                            color: (addAutoFill.isEmpty)
                                ? Colors.transparent
                                : page,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: media.width * 0.1,
                                        width: media.width * 0.1,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 2,
                                                  blurRadius: 2)
                                            ],
                                            color: page),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_back,
                                            color: textColor),
                                      ),
                                    ),
                                    Container(
                                      height: media.width * 0.1,
                                      width: media.width * 0.75,
                                      padding: EdgeInsets.fromLTRB(
                                          media.width * 0.05,
                                          0,
                                          media.width * 0.05,
                                          0),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 2)
                                          ],
                                          color: page,
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.05)),
                                      child: TextField(
                                          controller: search,
                                          autofocus: widget.from == 'add stop'
                                              ? true
                                              : false,
                                          decoration: InputDecoration(
                                              contentPadding: (languageDirection ==
                                                      'rtl')
                                                  ? EdgeInsets.only(
                                                      bottom:
                                                          media.width * 0.03)
                                                  : EdgeInsets.only(
                                                      bottom:
                                                          media.width * 0.042),
                                              border: InputBorder.none,
                                              hintText: languages[choosenLanguage]
                                                  ['text_4lettersforautofill'],
                                              hintStyle: GoogleFonts.notoSans(
                                                  fontSize:
                                                      media.width * twelve,
                                                  color: textColor
                                                      .withOpacity(0.4))),
                                          style: choosenLanguage == 'ar'
                                              ? GoogleFonts.cairo(
                                                  color: textColor)
                                              : GoogleFonts.notoSans(
                                                  color: textColor),
                                          maxLines: 1,
                                          onChanged: (val) {
                                            _debouncer.run(() {
                                              if (val.length >= 4) {
                                                if (storedAutoAddress
                                                    .where((element) =>
                                                        element['description']
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(val
                                                                .toLowerCase()))
                                                    .isNotEmpty) {
                                                  addAutoFill.removeWhere(
                                                      (element) =>
                                                          element['description']
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(val
                                                                  .toLowerCase()) ==
                                                          false);
                                                  storedAutoAddress
                                                      .where((element) =>
                                                          element['description']
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(val
                                                                  .toLowerCase()))
                                                      .forEach((element) {
                                                    addAutoFill.add(element);
                                                  });
                                                  valueNotifierHome
                                                      .incrementNotifier();
                                                } else {
                                                  getAutoAddress(
                                                      val,
                                                      sessionToken,
                                                      _center.latitude,
                                                      _center.longitude);
                                                }
                                              } else if (val.isEmpty) {
                                                setState(() {
                                                  addAutoFill.clear();
                                                });
                                              }
                                            });
                                          }),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                (addAutoFill.isNotEmpty)
                                    ? Container(
                                        height: media.height * 0.45,
                                        padding:
                                            EdgeInsets.all(media.width * 0.02),
                                        width: media.width * 0.9,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                media.width * 0.05),
                                            color: page),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: addAutoFill
                                                .asMap()
                                                .map((i, value) {
                                                  return MapEntry(
                                                      i,
                                                      (i < 7)
                                                          ? Container(
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      0,
                                                                      media.width *
                                                                          0.04,
                                                                      0,
                                                                      media.width *
                                                                          0.04),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    height:
                                                                        media.width *
                                                                            0.1,
                                                                    width: media
                                                                            .width *
                                                                        0.1,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                              .grey[
                                                                          200],
                                                                    ),
                                                                    child: const Icon(
                                                                        Icons
                                                                            .access_time),
                                                                  ),
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      var val = await geoCodingForLatLng(
                                                                          addAutoFill[i]
                                                                              [
                                                                              'place_id']);
                                                                      setState(
                                                                          () {
                                                                        _center =
                                                                            val;
                                                                        dropAddressConfirmation =
                                                                            addAutoFill[i]['description'];

                                                                        _controller?.moveCamera(CameraUpdate.newLatLngZoom(
                                                                            _center,
                                                                            14.0));
                                                                      });
                                                                      FocusManager
                                                                          .instance
                                                                          .primaryFocus
                                                                          ?.unfocus();
                                                                      addAutoFill
                                                                          .clear();
                                                                      search.text =
                                                                          '';
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      width: media
                                                                              .width *
                                                                          0.7,
                                                                      child: Text(
                                                                          addAutoFill[i]
                                                                              [
                                                                              'description'],
                                                                          style: GoogleFonts
                                                                              .notoSans(
                                                                            fontSize:
                                                                                media.width * twelve,
                                                                            color:
                                                                                textColor,
                                                                          ),
                                                                          maxLines:
                                                                              2),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : Container());
                                                })
                                                .values
                                                .toList(),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          )),

                      //fav address
                      (favAddressAdd == true)
                          ? Positioned(
                              top: 0,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: media.width * 0.1,
                                            width: media.width * 0.1,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: page),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  favName = '';
                                                  favAddressAdd = false;
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.cancel_outlined),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.all(media.width * 0.05),
                                      width: media.width * 0.9,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: page),
                                      child: Column(
                                        children: [
                                          Text(
                                            languages[choosenLanguage]
                                                ['text_saveaddressas'],
                                            style: GoogleFonts.notoSans(
                                                fontSize: media.width * sixteen,
                                                color: textColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.025,
                                          ),
                                          Text(
                                            favSelectedAddress,
                                            style: GoogleFonts.notoSans(
                                                fontSize: media.width * twelve,
                                                color: textColor),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.025,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  setState(() {
                                                    favName = 'Home';
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      media.width * 0.01),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height:
                                                            media.height * 0.05,
                                                        width:
                                                            media.width * 0.05,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 1.2)),
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            (favName == 'Home')
                                                                ? Container(
                                                                    height: media
                                                                            .width *
                                                                        0.03,
                                                                    width: media
                                                                            .width *
                                                                        0.03,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  )
                                                                : Container(),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            media.width * 0.01,
                                                      ),
                                                      Text(languages[
                                                              choosenLanguage]
                                                          ['text_home'])
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  setState(() {
                                                    favName = 'Work';
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      media.width * 0.01),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height:
                                                            media.height * 0.05,
                                                        width:
                                                            media.width * 0.05,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 1.2)),
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            (favName == 'Work')
                                                                ? Container(
                                                                    height: media
                                                                            .width *
                                                                        0.03,
                                                                    width: media
                                                                            .width *
                                                                        0.03,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  )
                                                                : Container(),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            media.width * 0.01,
                                                      ),
                                                      Text(languages[
                                                              choosenLanguage]
                                                          ['text_work'])
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  setState(() {
                                                    favName = 'Others';
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      media.width * 0.01),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height:
                                                            media.height * 0.05,
                                                        width:
                                                            media.width * 0.05,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 1.2)),
                                                        alignment:
                                                            Alignment.center,
                                                        child: (favName ==
                                                                'Others')
                                                            ? Container(
                                                                height: media
                                                                        .width *
                                                                    0.03,
                                                                width: media
                                                                        .width *
                                                                    0.03,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                            : Container(),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            media.width * 0.01,
                                                      ),
                                                      Text(languages[
                                                              choosenLanguage]
                                                          ['text_others'])
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          (favName == 'Others')
                                              ? Container(
                                                  padding: EdgeInsets.all(
                                                      media.width * 0.025),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2)),
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_enterfavname'],
                                                        hintStyle: GoogleFonts
                                                            .notoSans(
                                                                fontSize: media
                                                                        .width *
                                                                    twelve,
                                                                color:
                                                                    hintColor)),
                                                    maxLines: 1,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        favNameText = val;
                                                      });
                                                    },
                                                  ),
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: media.width * 0.05,
                                          ),
                                          Button(
                                              onTap: () async {
                                                if (favName == 'Others' &&
                                                    favNameText != '') {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  var val =
                                                      await addFavLocation(
                                                          favLat,
                                                          favLng,
                                                          favSelectedAddress,
                                                          favNameText);
                                                  setState(() {
                                                    _isLoading = false;
                                                    if (val == true) {
                                                      favLat = '';
                                                      favLng = '';
                                                      favSelectedAddress = '';
                                                      favNameText = '';
                                                      favName = 'Home';
                                                      favAddressAdd = false;
                                                    } else if (val ==
                                                        'logout') {
                                                      navigateLogout();
                                                    }
                                                  });
                                                } else if (favName == 'Home' ||
                                                    favName == 'Work') {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  var val =
                                                      await addFavLocation(
                                                          favLat,
                                                          favLng,
                                                          favSelectedAddress,
                                                          favName);
                                                  setState(() {
                                                    _isLoading = false;
                                                    if (val == true) {
                                                      favLat = '';
                                                      favLng = '';
                                                      favSelectedAddress = '';
                                                      favNameText = '';
                                                      favName = 'Home';
                                                      favAddressAdd = false;
                                                    } else if (val ==
                                                        'logout') {
                                                      navigateLogout();
                                                    }
                                                  });
                                                }
                                              },
                                              text: languages[choosenLanguage]
                                                  ['text_confirm'])
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ))
                          : Container(),

                      (_locationDenied == true)
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
                                              _locationDenied = false;
                                            });
                                          },
                                          child: Container(
                                            height: media.height * 0.05,
                                            width: media.height * 0.05,
                                            decoration: BoxDecoration(
                                              color: page,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.cancel,
                                                color: buttonColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: media.width * 0.025),
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
                                            child: Text(
                                              languages[choosenLanguage]
                                                  ['text_open_loc_settings'],
                                              style: GoogleFonts.notoSans(
                                                  fontSize:
                                                      media.width * sixteen,
                                                  color: textColor,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        SizedBox(height: media.width * 0.05),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  await perm.openAppSettings();
                                                },
                                                child: Text(
                                                  languages[choosenLanguage]
                                                      ['text_open_settings'],
                                                  style: GoogleFonts.notoSans(
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: buttonColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                            InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    _locationDenied = false;
                                                    _isLoading = true;
                                                  });

                                                  getLocs();
                                                },
                                                child: Text(
                                                  languages[choosenLanguage]
                                                      ['text_done'],
                                                  style: GoogleFonts.notoSans(
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: buttonColor,
                                                      fontWeight:
                                                          FontWeight.w600),
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

                      //loader
                      (_isLoading == true)
                          ? const Positioned(child: Loading())
                          : Container(),
                      (internet == false)
                          ?

                          //no internet
                          Positioned(
                              top: 0,
                              child: NoInternet(
                                onTap: () {
                                  setState(() {
                                    internetTrue();
                                  });
                                },
                              ))
                          : Container()
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
