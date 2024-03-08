import 'package:flutter/material.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  var _choosenLanguage = choosenLanguage;

  //navigate pop
  pop() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: true,
      // onWillPop: () async {
      //   Navigator.pop(context, false);
      //   return true;
      // },
      child: Material(
        child: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Container(
            height: media.height * 1,
            width: media.width * 1,
            padding: EdgeInsets.fromLTRB(media.width * 0.05, media.width * 0.05,
                media.width * 0.05, media.width * 0.05),
            color: page,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: media.width * 0.05),
                      width: media.width * 1,
                      alignment: Alignment.center,
                      child: MyText(
                        text: languages[choosenLanguage]
                            ['text_change_language'],
                        size: media.width * twenty,
                        fontweight: FontWeight.w600,
                      ),
                    ),
                    Positioned(
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child:
                                Icon(Icons.arrow_back_ios, color: textColor)))
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(
                  width: media.width * 0.9,
                  height: media.height * 0.16,
                  child: Image.asset(
                    'assets/images/selectLanguage.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: media.width * 0.1,
                ),
                Expanded(
                  child: SizedBox(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: languages
                            .map((i, value) {
                              return MapEntry(
                                  i,
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _choosenLanguage = i;
                                      });
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(media.width * 0.025),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MyText(
                                            text: languagesCode
                                                .firstWhere((e) =>
                                                    e['code'] == i)['name']
                                                .toString(),
                                            size: media.width * sixteen,
                                          ),
                                          Container(
                                            height: media.width * 0.05,
                                            width: media.width * 0.05,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: textColor,
                                                    width: 1.2)),
                                            alignment: Alignment.center,
                                            child: (_choosenLanguage == i)
                                                ? Container(
                                                    height: media.width * 0.03,
                                                    width: media.width * 0.03,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: textColor),
                                                  )
                                                : Container(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            })
                            .values
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Button(
                    onTap: () async {
                      choosenLanguage = _choosenLanguage;
                      if (choosenLanguage == 'ar' ||
                          choosenLanguage == 'ur' ||
                          choosenLanguage == 'iw') {
                        languageDirection = 'rtl';
                      } else {
                        languageDirection = 'ltr';
                      }
                      await getlangid();
                      pref.setString('languageDirection', languageDirection);
                      pref.setString('choosenLanguage', _choosenLanguage);
                      valueNotifierHome.incrementNotifier();
                      pop();
                    },
                    text: languages[choosenLanguage]['text_confirm'])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
