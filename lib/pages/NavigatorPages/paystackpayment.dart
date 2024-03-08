import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/login.dart';
import '../noInternet/noInternet.dart';
import 'walletpage.dart';

// ignore: must_be_immutable
class PayStackPage extends StatefulWidget {
  dynamic from;
  PayStackPage({this.from, Key? key}) : super(key: key);

  @override
  State<PayStackPage> createState() => _PayStackPageState();
}

class _PayStackPageState extends State<PayStackPage> {
  bool _isLoading = true;
  bool _success = false;
  String _error = '';
  late final WebViewController _controller;
  @override
  void initState() {
    payMoney();
    super.initState();
  }

  navigateLogout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }

//payment gateway code

  payMoney() async {
    dynamic val;
    if (widget.from == '1') {
      val = await getPaystackPayment(jsonEncode(
          {'amount': addMoney * 100, 'payment_for': userRequestData['id']}));
    } else {
      val = await getPaystackPayment(jsonEncode({'amount': addMoney * 100}));
    }
    if (val == 'logout') {
      navigateLogout();
    } else if (val != 'success') {
      _error = val.toString();
    } else {
      late final PlatformWebViewControllerCreationParams params;

      params = const PlatformWebViewControllerCreationParams();

      final WebViewController controller =
          WebViewController.fromPlatformCreationParams(params);
      // #enddocregion platform_features

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onWebResourceError: (WebResourceError error) {
              debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
            },
          ),
        )
        ..loadRequest(Uri.parse(paystackCode['authorization_url']));

      // #docregion platform_features
      // if (controller.platform is AndroidWebViewController) {
      //   AndroidWebViewController.enableDebugging(true);
      //   (controller.platform as AndroidWebViewController)
      //       .setMediaPlaybackRequiresUserGesture(false);
      // }
      // #enddocregion platform_features

      _controller = controller;
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      // onWillPop: () async {
      //   return false;
      // },
      child: Material(
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              return Directionality(
                textDirection: (languageDirection == 'rtl')
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Stack(
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
                                  padding: EdgeInsets.only(
                                      bottom: media.width * 0.05),
                                  width: media.width * 0.9,
                                  alignment: Alignment.center,
                                  child: MyText(
                                    text: languages[choosenLanguage]
                                        ['text_addmoney'],
                                    size: media.width * sixteen,
                                    fontweight: FontWeight.bold,
                                  )),
                              Positioned(
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Icon(Icons.arrow_back)))
                            ],
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Expanded(
                            child: (paystackCode['authorization_url'] != null &&
                                    _error == '')
                                ? WebViewWidget(controller: _controller)
                                : Container(),
                          )
                        ],
                      ),
                    ),
                    //payment failed
                    (_error != '')
                        ? Positioned(
                            top: 0,
                            child: Container(
                              height: media.height * 1,
                              width: media.width * 1,
                              color: Colors.transparent.withOpacity(0.6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(media.width * 0.05),
                                    width: media.width * 0.9,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: page),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            width: media.width * 0.8,
                                            child: MyText(
                                              text: _error.toString(),
                                              size: media.width * sixteen,
                                              fontweight: FontWeight.w600,
                                              textAlign: TextAlign.center,
                                            )),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                        Button(
                                            onTap: () async {
                                              setState(() {
                                                _error = '';
                                              });
                                              Navigator.pop(context, false);
                                            },
                                            text: languages[choosenLanguage]
                                                ['text_ok'])
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                        : Container(),

                    //success
                    (_success == true)
                        ? Positioned(
                            top: 0,
                            child: Container(
                              alignment: Alignment.center,
                              height: media.height * 1,
                              width: media.width * 1,
                              color: Colors.transparent.withOpacity(0.6),
                              child: Container(
                                padding: EdgeInsets.all(media.width * 0.05),
                                width: media.width * 0.9,
                                height: media.width * 0.8,
                                decoration: BoxDecoration(
                                    color: page,
                                    borderRadius: BorderRadius.circular(
                                        media.width * 0.03)),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/paymentsuccess.png',
                                      fit: BoxFit.contain,
                                      width: media.width * 0.5,
                                    ),
                                    MyText(
                                      text: languages[choosenLanguage]
                                          ['text_paymentsuccess'],
                                      textAlign: TextAlign.center,
                                      size: media.width * sixteen,
                                      fontweight: FontWeight.w600,
                                    ),
                                    SizedBox(
                                      height: media.width * 0.07,
                                    ),
                                    Button(
                                        onTap: () {
                                          setState(() {
                                            _success = false;
                                            // super.detachFromGLContext();
                                            Navigator.pop(context, true);
                                          });
                                        },
                                        text: languages[choosenLanguage]
                                            ['text_ok'])
                                  ],
                                ),
                              ),
                            ))
                        : Container(),

                    //no internet
                    (internet == false)
                        ? Positioned(
                            top: 0,
                            child: NoInternet(
                              onTap: () {
                                setState(() {
                                  internetTrue();
                                  _isLoading = true;
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
      ),
    );
  }
}
