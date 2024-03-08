import 'package:flutter/material.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import 'pickcontacts.dart';

class Sos extends StatefulWidget {
  const Sos({Key? key}) : super(key: key);

  @override
  State<Sos> createState() => _SosState();
}

class _SosState extends State<Sos> {
  bool _isDeleting = false;
  bool _isLoading = false;
  String _deleteId = '';

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: true,
      // onWillPop: () async {
      //   Navigator.pop(context, true);
      //   return true;
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
                      padding: EdgeInsets.only(
                          left: media.width * 0.05, right: media.width * 0.05),
                      height: media.height * 1,
                      width: media.width * 1,
                      color: page,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).padding.top +
                                  media.width * 0.05),
                          Stack(
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.only(bottom: media.width * 0.05),
                                width: media.width * 1,
                                alignment: Alignment.center,
                                child: const Text(
                                  '',
                                ),
                              ),
                              Positioned(
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Icon(Icons.arrow_back_ios,
                                          color: textColor)))
                            ],
                          ),
                          SizedBox(
                            height: media.width * 0.03,
                          ),
                          MyText(
                            text: languages[choosenLanguage]
                                    ['text_add_trust_contact']
                                .toString()
                                .toUpperCase(),
                            size: media.width * fourteen,
                            fontweight: FontWeight.w800,
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          MyText(
                            text: languages[choosenLanguage]
                                ['text_trust_contact_3'],
                            size: media.width * fourteen,
                            fontweight: FontWeight.w800,
                          ),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                          MyText(
                            text: languages[choosenLanguage]
                                ['text_trust_contact_4'],
                            size: media.width * twelve,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),

                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: media.width * 0.025,
                                  ),
                                  (sosData
                                          .where((element) =>
                                              element['user_type'] != 'admin')
                                          .isNotEmpty)
                                      ? Container(
                                          padding: EdgeInsets.all(
                                              media.width * 0.03),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            color: Colors.grey.withOpacity(0.1),
                                          ),
                                          child: Column(
                                            children: sosData
                                                .asMap()
                                                .map((i, value) {
                                                  return MapEntry(
                                                      i,
                                                      (sosData[i]['user_type'] !=
                                                              'admin')
                                                          ? Container(
                                                              padding: EdgeInsets
                                                                  .all(media
                                                                          .width *
                                                                      0.02),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .account_box_sharp,
                                                                    size: media
                                                                            .width *
                                                                        0.06,
                                                                    color:
                                                                        textColor,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: media.width * 0.01),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border:
                                                                              Border(
                                                                            bottom:
                                                                                BorderSide(color: textColor.withOpacity(0.2)),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: media.width * 0.65,
                                                                                  child: MyText(
                                                                                    text: sosData[i]['name'],
                                                                                    size: media.width * sixteen,
                                                                                    fontweight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: media.width * 0.02,
                                                                                ),
                                                                                MyText(
                                                                                  text: sosData[i]['number'],
                                                                                  size: media.width * twelve,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: media.width * 0.01,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    _deleteId = sosData[i]['id'];
                                                                                    _isDeleting = true;
                                                                                  });
                                                                                },
                                                                                child: Icon(Icons.delete, color: textColor))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          : Container());
                                                })
                                                .values
                                                .toList(),
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(
                                                  media.width * 0.05),
                                              width: media.width * 0.9,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.grey
                                                      .withOpacity(0.1)),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .collections_bookmark,
                                                      color: textColor),
                                                  SizedBox(
                                                    height: media.width * 0.02,
                                                  ),
                                                  MyText(
                                                      text: languages[
                                                              choosenLanguage][
                                                          'text_new_connection'],
                                                      color: textColor
                                                          .withOpacity(0.7),
                                                      size: media.width *
                                                          fourteen)
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ),

                          //add sos button
                          (sosData
                                      .where((element) =>
                                          element['user_type'] != 'admin')
                                      .length <
                                  5)
                              ? Container(
                                  padding: EdgeInsets.only(
                                      top: media.width * 0.05,
                                      bottom: media.width * 0.05),
                                  child: Button(
                                      onTap: () async {
                                        var nav = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PickContact(
                                                      from: '1',
                                                    )));
                                        if (nav) {
                                          setState(() {});
                                        }
                                      },
                                      text: languages[choosenLanguage]
                                          ['text_add_trust_contact']))
                              : Container()
                        ],
                      ),
                    ),

                    //delete sos
                    (_isDeleting == true)
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
                                                    _isDeleting = false;
                                                  });
                                                },
                                                child: const Icon(
                                                    Icons.cancel_outlined))),
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
                                              ['text_removeSos'],
                                          size: media.width * sixteen,
                                          fontweight: FontWeight.w600,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                        Button(
                                            onTap: () async {
                                              setState(() {
                                                _isLoading = true;
                                              });

                                              var val =
                                                  await deleteSos(_deleteId);
                                              if (val == 'success') {
                                                setState(() {
                                                  _isDeleting = false;
                                                });
                                              }
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            },
                                            text: languages[choosenLanguage]
                                                ['text_confirm'])
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
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
