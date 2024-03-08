import 'package:flutter/material.dart';
import 'package:flutter_user/pages/NavigatorPages/mercadopago.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../noInternet/noInternet.dart';
import 'paystackpayment.dart';
import 'flutterWavePage.dart';
import 'razorpaypage.dart';
import 'cashfreepage.dart';
import 'selectwallet.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

dynamic addMoney;

TextEditingController phonenumber = TextEditingController();
TextEditingController amount = TextEditingController();

class _WalletPageState extends State<WalletPage> {
  TextEditingController addMoneyController = TextEditingController();

  bool _isLoading = true;
  bool _addPayment = false;
  bool _choosePayment = false;
  bool _completed = false;
  bool showtoast = false;
  int ischeckmoneytransfer = 0;

  @override
  void initState() {
    getWallet();
    super.initState();
  }

//get wallet details
  getWallet() async {
    var val = await getWalletHistory();
    await getCountryCode();
    if (val == 'success') {
      _isLoading = false;
      _completed = true;
      valueNotifierBook.incrementNotifier();
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(value: "user", child: Text("User")),
      DropdownMenuItem(value: "driver", child: Text("Driver")),
    ];
    return menuItems;
  }

  String dropdownValue = 'user';
  bool error = false;
  String errortext = '';
  bool ispop = false;

  //show toast for copy

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: ValueListenableBuilder(
          valueListenable: valueNotifierBook.value,
          builder: (context, value, child) {
            return Directionality(
              textDirection: (languageDirection == 'rtl')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(media.width * 0.05,
                          media.width * 0.05, media.width * 0.05, 0),
                      height: media.height * 1,
                      width: media.width * 1,
                      color: page,
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
                                      ['text_enable_wallet'],
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
                          (walletBalance.isNotEmpty)
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        MyText(
                                          text: languages[choosenLanguage]
                                              ['text_availablebalance'],
                                          size: media.width * fourteen,
                                          fontweight: FontWeight.w800,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: media.width * 0.03,
                                    ),
                                    Container(
                                      height: media.width * 0.1,
                                      width: media.width * 0.9,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                      child: MyText(
                                        text: walletBalance['currency_symbol'] +
                                            walletBalance['wallet_balance']
                                                .toString(),
                                        size: media.width * twenty,
                                        fontweight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    SizedBox(
                                      width: media.width * 0.9,
                                      child: MyText(
                                        text: languages[choosenLanguage]
                                            ['text_recenttransactions'],
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Expanded(
                              child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                (walletHistory.isNotEmpty)
                                    ? Column(
                                        children: walletHistory
                                            .asMap()
                                            .map((i, value) {
                                              return MapEntry(
                                                  i,
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: media.width * 0.02,
                                                        bottom:
                                                            media.width * 0.02),
                                                    width: media.width * 0.9,
                                                    padding: EdgeInsets.all(
                                                        media.width * 0.025),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: borderLines,
                                                            width: 1.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Colors.grey
                                                            .withOpacity(0.1)),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: media.width *
                                                              0.1067,
                                                          width: media.width *
                                                              0.1067,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: topBar),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            (walletHistory[i][
                                                                        'is_credit'] ==
                                                                    1)
                                                                ? '+'
                                                                : '-',
                                                            style: TextStyle(
                                                                fontSize: media
                                                                        .width *
                                                                    twentyfour),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: media.width *
                                                              0.025,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            MyText(
                                                              text: walletHistory[
                                                                          i][
                                                                      'remarks']
                                                                  .toString(),
                                                              size:
                                                                  media.width *
                                                                      fourteen,
                                                              fontweight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  media.width *
                                                                      0.02,
                                                            ),
                                                            MyText(
                                                              text: walletHistory[
                                                                      i][
                                                                  'created_at'],
                                                              size:
                                                                  media.width *
                                                                      ten,
                                                              color: textColor
                                                                  .withOpacity(
                                                                      0.4),
                                                            )
                                                          ],
                                                        ),
                                                        Expanded(
                                                            child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            MyText(
                                                              text: walletHistory[
                                                                          i][
                                                                      'currency_symbol'] +
                                                                  ' ' +
                                                                  walletHistory[
                                                                              i]
                                                                          [
                                                                          'amount']
                                                                      .toString(),
                                                              size:
                                                                  media.width *
                                                                      twelve,
                                                              color: (walletHistory[
                                                                              i]
                                                                          [
                                                                          'is_credit'] ==
                                                                      1)
                                                                  ? online
                                                                  : verifyDeclined,
                                                            )
                                                          ],
                                                        ))
                                                      ],
                                                    ),
                                                  ));
                                            })
                                            .values
                                            .toList(),
                                      )
                                    : (_completed == true)
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: media.width * 0.1,
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                height: media.width * 0.5,
                                                width: media.width * 0.5,
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/nodatafound.gif'),
                                                        fit: BoxFit.contain)),
                                              ),
                                              SizedBox(
                                                height: media.width * 0.07,
                                              ),
                                              SizedBox(
                                                width: media.width * 0.8,
                                                child: MyText(
                                                    text: languages[
                                                            choosenLanguage]
                                                        ['text_noDataFound'],
                                                    textAlign: TextAlign.center,
                                                    fontweight: FontWeight.w800,
                                                    size:
                                                        media.width * sixteen),
                                              ),
                                            ],
                                          )
                                        : Container(),

                                //load more button
                                (walletPages.isNotEmpty)
                                    ? (walletPages['current_page'] <
                                            walletPages['total_pages'])
                                        ? InkWell(
                                            onTap: () async {
                                              setState(() {
                                                _isLoading = true;
                                              });

                                              await getWalletHistoryPage(
                                                  (walletPages['current_page'] +
                                                          1)
                                                      .toString());

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
                          )),
                          SizedBox(
                            height: media.width * 0.18,
                            width: media.width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: languages[choosenLanguage]
                                      ['text_recharge_bal'],
                                  size: media.width * fourteen,
                                  fontweight: FontWeight.w800,
                                ),
                                SizedBox(
                                  height: media.width * 0.04,
                                ),
                                MyText(
                                  text: languages[choosenLanguage]
                                      ['text_rechage_text'],
                                  size: media.width * twelve,
                                  fontweight: FontWeight.w600,
                                  color: textColor.withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                height: media.width * 0.15,
                                width: media.width * 0.9,
                                alignment: Alignment.center,
                                color: Colors.grey.withOpacity(0.3),
                                // color: textColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _addPayment = true;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.credit_card,
                                            color: (ischeckmoneytransfer == 1)
                                                ? const Color(0xFFFF0000)
                                                : textColor,
                                          ),
                                          MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_addmoney'],
                                              size: media.width * sixteen,
                                              color: (ischeckmoneytransfer == 1)
                                                  ? const Color(0xFFFF0000)
                                                  : textColor)
                                        ],
                                      ),
                                    ),
                                    if (userDetails[
                                            'show_wallet_money_transfer_feature_on_mobile_app'] ==
                                        '1')
                                      Container(
                                        height: media.width * 0.1,
                                        width: 1,
                                        color: textColor.withOpacity(0.3),
                                      ),
                                    if (userDetails[
                                            'show_wallet_money_transfer_feature_on_mobile_app'] ==
                                        '1')
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            ispop = true;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.swap_horiz_outlined,
                                                color: (ischeckmoneytransfer ==
                                                        2)
                                                    ? const Color(0xFFFF0000)
                                                    : textColor),
                                            MyText(
                                                text: languages[choosenLanguage]
                                                    ['text_credit_trans'],
                                                size: media.width * sixteen,
                                                color: (ischeckmoneytransfer ==
                                                        2)
                                                    ? const Color(0xFFFF0000)
                                                    : textColor)
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: media.width * 0.1,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    //add payment
                    (_addPayment == true)
                        ? Positioned(
                            bottom: 0,
                            child: Container(
                              height: media.height * 1,
                              width: media.width * 1,
                              color: Colors.transparent.withOpacity(0.6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: media.width * 0.05),
                                    width: media.width * 0.9,
                                    padding:
                                        EdgeInsets.all(media.width * 0.025),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: borderLines, width: 1.2),
                                        color: page),
                                    child: Column(children: [
                                      Container(
                                        height: media.width * 0.128,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: borderLines, width: 1.2),
                                        ),
                                        child: Row(children: [
                                          Container(
                                              width: media.width * 0.1,
                                              height: media.width * 0.128,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12),
                                                  ),
                                                  color: Color(0xffF0F0F0)),
                                              alignment: Alignment.center,
                                              child: MyText(
                                                text: walletBalance[
                                                    'currency_symbol'],
                                                size: media.width * twelve,
                                                fontweight: FontWeight.w600,
                                                color: (isDarkTheme == true)
                                                    ? Colors.black
                                                    : textColor,
                                              )),
                                          SizedBox(
                                            width: media.width * 0.05,
                                          ),
                                          Container(
                                            height: media.width * 0.128,
                                            width: media.width * 0.6,
                                            alignment: Alignment.center,
                                            child: TextField(
                                              controller: addMoneyController,
                                              onChanged: (val) {
                                                setState(() {
                                                  addMoney = int.parse(val);
                                                });
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    languages[choosenLanguage]
                                                        ['text_enteramount'],
                                                hintStyle: GoogleFonts.notoSans(
                                                  fontSize:
                                                      media.width * fourteen,
                                                  fontWeight: FontWeight.normal,
                                                  color: textColor
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                              style: GoogleFonts.notoSans(
                                                  fontSize:
                                                      media.width * fourteen,
                                                  fontWeight: FontWeight.normal,
                                                  color: textColor),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ]),
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                addMoneyController.text = '100';
                                                addMoney = 100;
                                              });
                                            },
                                            child: Container(
                                              height: media.width * 0.11,
                                              width: media.width * 0.17,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: borderLines,
                                                      width: 1.2),
                                                  color: page,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              alignment: Alignment.center,
                                              child: MyText(
                                                text: walletBalance[
                                                        'currency_symbol'] +
                                                    '100',
                                                size: media.width * twelve,
                                                fontweight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: media.width * 0.05,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                addMoneyController.text = '500';
                                                addMoney = 500;
                                              });
                                            },
                                            child: Container(
                                              height: media.width * 0.11,
                                              width: media.width * 0.17,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: borderLines,
                                                      width: 1.2),
                                                  color: page,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              alignment: Alignment.center,
                                              child: MyText(
                                                text: walletBalance[
                                                        'currency_symbol'] +
                                                    '500',
                                                size: media.width * twelve,
                                                fontweight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: media.width * 0.05,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                addMoneyController.text =
                                                    '1000';
                                                addMoney = 1000;
                                              });
                                            },
                                            child: Container(
                                              height: media.width * 0.11,
                                              width: media.width * 0.17,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: borderLines,
                                                      width: 1.2),
                                                  color: page,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              alignment: Alignment.center,
                                              child: MyText(
                                                text: walletBalance[
                                                        'currency_symbol'] +
                                                    '1000',
                                                size: media.width * twelve,
                                                fontweight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.width * 0.1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Button(
                                            onTap: () async {
                                              setState(() {
                                                _addPayment = false;
                                                addMoney = null;
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                addMoneyController.clear();
                                              });
                                            },
                                            text: languages[choosenLanguage]
                                                ['text_cancel'],
                                            width: media.width * 0.4,
                                          ),
                                          Button(
                                            onTap: () async {
                                              // print(addMoney);
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              if (addMoney != 0 &&
                                                  addMoney != null) {
                                                setState(() {
                                                  _choosePayment = true;
                                                  _addPayment = false;
                                                });
                                              }
                                            },
                                            text: languages[choosenLanguage]
                                                ['text_addmoney'],
                                            width: media.width * 0.4,
                                          ),
                                        ],
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                            ))
                        : Container(),

                    //choose payment method
                    (_choosePayment == true)
                        ? Positioned(
                            child: Container(
                            height: media.height * 1,
                            width: media.width * 1,
                            color: Colors.transparent.withOpacity(0.6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: media.width * 0.8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _choosePayment = false;
                                            _addPayment = true;
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
                                  width: media.width * 0.8,
                                  height: media.height * 0.6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: topBar),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          width: media.width * 0.7,
                                          child: MyText(
                                            text: languages[choosenLanguage]
                                                ['text_choose_payment'],
                                            size: media.width * eighteen,
                                            fontweight: FontWeight.w600,
                                            color: (isDarkTheme == true)
                                                ? Colors.black
                                                : textColor,
                                          )),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Column(
                                            children: [
                                              (walletBalance['stripe'] == true)
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.025),
                                                      alignment:
                                                          Alignment.center,
                                                      width: media.width * 0.7,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          var val = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const SelectWallet()));
                                                          if (val) {
                                                            setState(() {
                                                              _choosePayment =
                                                                  false;
                                                              _addPayment =
                                                                  false;
                                                              addMoney = null;
                                                              addMoneyController
                                                                  .clear();
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          width: media.width *
                                                              0.25,
                                                          height: media.width *
                                                              0.125,
                                                          decoration: const BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      'assets/images/stripe-icon.png'),
                                                                  fit: BoxFit
                                                                      .contain)),
                                                        ),
                                                      ))
                                                  : Container(),
                                              (walletBalance['paystack'] ==
                                                      true)
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin: EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.025),
                                                      width: media.width * 0.7,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          var val = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          PayStackPage()));
                                                          if (val) {
                                                            setState(() {
                                                              _isLoading = true;
                                                              _choosePayment =
                                                                  false;
                                                              _addPayment =
                                                                  false;
                                                              addMoney = null;
                                                              addMoneyController
                                                                  .clear();
                                                            });
                                                            await getWallet();
                                                          }
                                                        },
                                                        child: Container(
                                                          width: media.width *
                                                              0.25,
                                                          height: media.width *
                                                              0.125,
                                                          decoration: const BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      'assets/images/paystack-icon.png'),
                                                                  fit: BoxFit
                                                                      .contain)),
                                                        ),
                                                      ))
                                                  : Container(),
                                              (walletBalance['flutter_wave'] ==
                                                      true)
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.025),
                                                      alignment:
                                                          Alignment.center,
                                                      width: media.width * 0.7,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          var val = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          FlutterWavePage()));
                                                          if (val) {
                                                            setState(() {
                                                              _choosePayment =
                                                                  false;
                                                              _addPayment =
                                                                  false;
                                                              addMoney = null;
                                                              addMoneyController
                                                                  .clear();
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          width: media.width *
                                                              0.25,
                                                          height: media.width *
                                                              0.125,
                                                          decoration: const BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      'assets/images/flutterwave-icon.png'),
                                                                  fit: BoxFit
                                                                      .contain)),
                                                        ),
                                                      ))
                                                  : Container(),
                                              (walletBalance['razor_pay'] ==
                                                      true)
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.025),
                                                      alignment:
                                                          Alignment.center,
                                                      width: media.width * 0.7,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          var val = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          RazorPayPage()));
                                                          if (val) {
                                                            setState(() {
                                                              _choosePayment =
                                                                  false;
                                                              _addPayment =
                                                                  false;
                                                              addMoney = null;
                                                              addMoneyController
                                                                  .clear();
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          width: media.width *
                                                              0.25,
                                                          height: media.width *
                                                              0.125,
                                                          decoration: const BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      'assets/images/razorpay-icon.jpeg'),
                                                                  fit: BoxFit
                                                                      .contain)),
                                                        ),
                                                      ))
                                                  : Container(),
                                              (walletBalance['mercadopago'] ==
                                                      true)
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.025),
                                                      alignment:
                                                          Alignment.center,
                                                      width: media.width * 0.7,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          var val = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          MercadoPago()));
                                                          if (val != null) {
                                                            if (val) {
                                                              setState(() {
                                                                _isLoading =
                                                                    true;
                                                                _choosePayment =
                                                                    false;
                                                                _addPayment =
                                                                    false;
                                                                addMoney = null;
                                                                addMoneyController
                                                                    .clear();
                                                              });
                                                              await getWallet();
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                          width: media.width *
                                                              0.35,
                                                          height: media.width *
                                                              0.125,
                                                          decoration: const BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      'assets/images/mercadopago.png'),
                                                                  fit: BoxFit
                                                                      .contain)),
                                                        ),
                                                      ))
                                                  : Container(),
                                              (walletBalance['cash_free'] ==
                                                      true)
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.025),
                                                      alignment:
                                                          Alignment.center,
                                                      width: media.width * 0.7,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          var val = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          CashFreePage()));
                                                          if (val) {
                                                            setState(() {
                                                              _choosePayment =
                                                                  false;
                                                              _addPayment =
                                                                  false;
                                                              addMoney = null;
                                                              addMoneyController
                                                                  .clear();
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          width: media.width *
                                                              0.25,
                                                          height: media.width *
                                                              0.125,
                                                          decoration: const BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      'assets/images/cashfree-icon.jpeg'),
                                                                  fit: BoxFit
                                                                      .contain)),
                                                        ),
                                                      ))
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ))
                        : Container(),
                    //no internet

                    (ispop == true)
                        ? Positioned(
                            bottom: 0,
                            child: Container(
                              height: media.height * 1,
                              width: media.width * 1,
                              color: Colors.transparent.withOpacity(0.6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          bottom: media.width * 0.02),
                                      width: media.width * 1,
                                      padding:
                                          EdgeInsets.all(media.width * 0.025),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: borderLines, width: 1.2),
                                          color: page),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: page,
                                            ),
                                            dropdownColor: page,
                                            value: dropdownValue,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownValue = newValue!;
                                              });
                                            },
                                            items: dropdownItems,
                                            style: GoogleFonts.notoSans(
                                              fontSize: media.width * sixteen,
                                              color: textColor,
                                            ),
                                          ),
                                          TextFormField(
                                            controller: amount,
                                            style: GoogleFonts.notoSans(
                                              fontSize: media.width * sixteen,
                                              color: textColor,
                                              letterSpacing: 1,
                                            ),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText:
                                                  languages[choosenLanguage]
                                                      ['text_enteramount'],
                                              counterText: '',
                                              hintStyle: GoogleFonts.notoSans(
                                                fontSize: media.width * sixteen,
                                                color:
                                                    textColor.withOpacity(0.7),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: (isDarkTheme == true)
                                                    ? textColor.withOpacity(0.2)
                                                    : inputfocusedUnderline,
                                                width: 1.2,
                                                style: BorderStyle.solid,
                                              )),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: (isDarkTheme == true)
                                                    ? textColor.withOpacity(0.1)
                                                    : inputUnderline,
                                                width: 1.2,
                                                style: BorderStyle.solid,
                                              )),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: phonenumber,
                                            onChanged: (val) {
                                              if (phonenumber.text.length ==
                                                  countries[phcode]
                                                      ['dial_max_length']) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              }
                                            },
                                            style: GoogleFonts.notoSans(
                                              fontSize: media.width * sixteen,
                                              color: textColor,
                                              letterSpacing: 1,
                                            ),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText:
                                                  languages[choosenLanguage]
                                                      ['text_phone_number'],
                                              counterText: '',
                                              hintStyle: GoogleFonts.notoSans(
                                                fontSize: media.width * sixteen,
                                                color:
                                                    textColor.withOpacity(0.7),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: (isDarkTheme == true)
                                                    ? textColor.withOpacity(0.2)
                                                    : inputfocusedUnderline,
                                                width: 1.2,
                                                style: BorderStyle.solid,
                                              )),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: (isDarkTheme == true)
                                                    ? textColor.withOpacity(0.1)
                                                    : inputUnderline,
                                                width: 1.2,
                                                style: BorderStyle.solid,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.05,
                                          ),
                                          error == true
                                              ? Text(
                                                  errortext,
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: media.width * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Button(
                                                  width: media.width * 0.2,
                                                  height: media.width * 0.09,
                                                  onTap: () {
                                                    setState(() {
                                                      ispop = false;
                                                      dropdownValue = 'user';
                                                      error = false;
                                                      errortext = '';
                                                      phonenumber.text = '';
                                                      amount.text = '';
                                                    });
                                                  },
                                                  text:
                                                      languages[choosenLanguage]
                                                          ['text_close']),
                                              SizedBox(
                                                width: media.width * 0.05,
                                              ),
                                              Button(
                                                  width: media.width * 0.2,
                                                  height: media.width * 0.09,
                                                  onTap: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    if (phonenumber.text ==
                                                            '' ||
                                                        amount.text == '') {
                                                      setState(() {
                                                        error = true;
                                                        errortext = languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_fill_fileds'];
                                                        _isLoading = false;
                                                      });
                                                    } else {
                                                      var result =
                                                          await sharewalletfun(
                                                              amount:
                                                                  amount.text,
                                                              mobile:
                                                                  phonenumber
                                                                      .text,
                                                              role:
                                                                  dropdownValue);
                                                      if (result == 'success') {
                                                        setState(() {
                                                          ispop = false;
                                                          dropdownValue =
                                                              'user';
                                                          error = false;
                                                          errortext = '';

                                                          getWallet();
                                                          showtoast = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          error = true;
                                                          errortext =
                                                              result.toString();
                                                          _isLoading = false;
                                                        });
                                                      }
                                                    }
                                                  },
                                                  text:
                                                      languages[choosenLanguage]
                                                          ['text_share']),
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          )
                        : Container(),

                    //loader
                    (_isLoading == true)
                        ? const Positioned(child: Loading())
                        : Container(),
                    (showtoast == true)
                        ? PaymentSuccess(
                            onTap: () async {
                              setState(() {
                                showtoast = false;
                              });
                            },
                            transfer: true,
                          )
                        : Container(),
                    (internet == false)
                        ? Positioned(
                            top: 0,
                            child: NoInternet(
                              onTap: () {
                                setState(() {
                                  internetTrue();
                                  _isLoading = true;
                                  getWallet();
                                });
                              },
                            ))
                        : Container(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
