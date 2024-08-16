// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:jdx/AuthViews/LoginScreen.dart';
// import 'package:jdx/Views/HomeScreen.dart';
// import '../Utils/Color.dart';
//
// class LanguageSelectionPage extends StatefulWidget {
//   const LanguageSelectionPage({Key? key}) : super(key: key);
//
//   @override
//   State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
// }
//
// class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
//   List<String> languageList = [
//     'Kannada',
//     'Hindi',
//     'English',
//     'Tamil',
//     'Telugu',
//     'Marathi'
//   ];
//   int selected = 2;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: colors.primary,
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         child: ListView(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               //  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
//               height: MediaQuery.of(context).size.height * 0.1,
//               width: MediaQuery.of(context).size.width,
//               decoration: const BoxDecoration(color: colors.primary),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'Choose your language',
//                     style: TextStyle(
//                         fontSize: 24,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height * 0.9,
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30)),
//               ),
//               child: ListView(
//                 children: [
//                   ListView.separated(
//                     shrinkWrap: true,
//                     itemCount: languageList.length,
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                         onTap: () {
//                           setState(() {
//                             selected = index;
//                           });
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           height: 60,
//                           width: MediaQuery.of(context).size.width,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: selected == index
//                                     ? colors.primary
//                                     : Colors.white),
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 languageList[index],
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                               Icon(
//                                 selected == index
//                                     ? Icons.radio_button_checked_outlined
//                                     : Icons.radio_button_off,
//                                 color: colors.primary,
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                     separatorBuilder: (context, index) {
//                       return SizedBox(
//                         height: 20,
//                       );
//                     },
//                   ),
//                   SizedBox(
//                     height: 60,
//                   ),
//                   InkWell(
//                     onTap: ()
//                     {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginScreen()),
//                       );
//                    },
//                     child:
//                     Container(
//                       height: 60,
//                       decoration: BoxDecoration(
//                           color: colors.primary,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Center(
//                           child: Text(
//                         'Continue',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       )),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:jdx/Views/HomeScreen.dart';
import 'package:jdx/services/session.dart';
// import 'package:job_dekho_app/Jdx_screens/signin_Screen.dart';
// import 'package:job_dekho_app/Utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../Helper/session.dart';
import '../Utils/Color.dart';
import '../main.dart';
// import 'Jdx_screens/Dashbord.dart';

class ChangeLanguageee extends StatefulWidget {
  bool? back, isTrue;
  ChangeLanguageee({this.back, this.isTrue});

  @override
  _ChangeLanguageeeState createState() => _ChangeLanguageeeState();
}

class _ChangeLanguageeeState extends State<ChangeLanguageee> {
  int? selectLan = 2;

  @override
  void initState() {
    changeSelectedLang();
    new Future.delayed(Duration.zero, () {
      languageList = [
        getTranslated(context, 'KANADA_LAN'),
        getTranslated(context, 'HINDI_LAN'),
        getTranslated(context, 'ENGLISH_LAN'),
        getTranslated(context, 'TAMIL_LAN'),
        getTranslated(context, 'TELUGU_LAN'),
        getTranslated(context, 'MARATHI_LAN'),
      ];
      setState(() {});
    });

    super.initState();
  }

  changeSelectedLang() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString('languageCode') ?? "en";

    if (languageCode == 'en') {
      selectLan = 2;
    } else if (languageCode == 'hi') {
      selectLan = 1;
    } else if (languageCode == 'mr') {
      selectLan = 5;
    } else if (languageCode == 'ta') {
      selectLan = 3;
    } else if (languageCode == 'te') {
      selectLan = 4;
    } else if (languageCode == 'kn') {
      selectLan = 0;
    }
  }

  final GlobalKey<FormState> _changePwdKey = GlobalKey<FormState>();
  void openChangeLanguageBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _changePwdKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      bottomSheetHandle(),
                      bottomsheetLabel("CHOOSE_LANGUAGE_LBL"),
                      StatefulBuilder(
                        builder:
                            (BuildContext context, StateSetter setModalState) {
                          return SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: getLngList(context, setModalState)),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(context,MaterialPageRoute(builder: (context)=>SignInScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF3700b3)),
                                child: Icon(Icons.arrow_forward))),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget getHeading(String title) {
    print("here is title value ${title}");
    return Text(
      getTranslated(context, title).toString(),
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget bottomSheetHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), color: Colors.black),
        height: 5,
        width: MediaQuery.of(context).size.width * 0.3,
      ),
    );
  }

// bool? isLanguage = false;
  Widget bottomsheetLabel(String labelName) => Padding(
    padding: const EdgeInsets.only(top: 30.0, bottom: 20),
    child: getHeading(
      labelName,
    ),
  );
  List<String> langCode = ["kn", "hi", "en", "ta", "te", "mr"];
  List<String?> languageList = [];
  List<Widget> getLngList(BuildContext ctx, StateSetter setModalState) {
    return languageList
        .asMap()
        .map(
          (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () async {
              if (mounted)
                setState(() {
                  selectLan = index;
                  _changeLan(langCode[index], ctx);
                });
              SharedPreferences pref =
              await SharedPreferences.getInstance();
              await pref.setBool('isLanguage', true);
              setModalState(() {});
            },
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: colors.text2,
                        borderRadius: BorderRadius.circular(20),
                        border: selectLan == index
                            ? Border.all(color: colors.primary)
                            : Border.all(color: Colors.transparent)),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ListTile(
                        leading: Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 10.0,
                            ),
                            child: Text(
                              languageList[index].toString(),
                              style: Theme.of(this.context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.black),
                            )),
                        trailing: Container(
                          height: 25.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectLan == index
                                  ? Colors.transparent
                                  : Colors.white,
                              border: Border.all(color: colors.secondary)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: selectLan == index
                                ? Icon(
                              Icons.check,
                              size: 17.0,
                              color: selectLan == index
                                  ? Color(0xFF0F368C)
                                  : Colors.white,
                            )
                                : Icon(Icons.check_box_outline_blank,
                                size: 15.0, color: colors.text2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // index == languageList.length - 1
                //     ? Container(
                //         margin: EdgeInsetsDirectional.only(
                //           bottom: 10,
                //         ),
                //       )
                //     : Divider(
                //         color: Theme.of(context).colorScheme.lightBlack,
                //       ),
              ],
            ),
          )),
    )
        .values
        .toList();
  }

  void _changeLan(String language, BuildContext ctx) async {
    Locale _locale = await setLocale(language);
    print('__________${_locale}_________');
    MyApp.setLocale(ctx, _locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F368C),
      appBar: AppBar(
        backgroundColor: Color(0xFF0F368C),
        toolbarHeight: 80,
        centerTitle: true,
        title: bottomsheetLabel(
          "CHOOSE_LANGUAGE_LBL",
        ),
        elevation: 0,
      ),
      body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(80)),
              color: Color(0xffF5FAFD)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    key: _changePwdKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setModalState) {
                            return SingleChildScrollView(
                              child: Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children:
                                    getLngList(context, setModalState)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen()));

                    // print('____Som______${widget.isTrue}_________');
                    // if (widget.isTrue == true) {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => HomeScreen()));
                    // }
                    // else {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => LoginScreen()));
                    // }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 60,
                      //
                      // decoration: BoxDecoration(
                      //     color:primaryColor ,
                      //     borderRadius: BorderRadius.circular(10)
                      // ),
                      child: Card(
                          color: Color(0xFF0F368C),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                getTranslated(context, 'CONTINUES'),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xffF5FAFD)),
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

// _createLanguageDropDown() {
//   return Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(10),
//       border: Border.all(color: Colors.black),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.only(left: 10, right: 10),
//       child: DropdownButton<LanguageModel>(
//         iconSize: 30,
//         underline: SizedBox(),
//         hint: Text(getTranslated(context, 'CHOOSE_LANGUAGE_LBL')),
//         onChanged: (LanguageModel? language) {
//           changeLanguage(context, language!.languageCode);
//         },
//         items: LanguageModel.languageList()
//             .map<DropdownMenuItem<LanguageModel>>(
//               (e) => DropdownMenuItem<LanguageModel>(
//             value: e,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 Text(
//                   e.flag,
//                   style: TextStyle(fontSize: 30),
//                 ),
//                 Text(e.name)
//               ],
//             ),
//           ),
//         )
//             .toList(),
//       ),
//     ),
//   );
// }
}
