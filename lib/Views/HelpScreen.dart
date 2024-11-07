// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:http/http.dart' as http;
//
// import '../Utils/AppBar.dart';
// import '../Utils/Color.dart';
// import '../Utils/CustomColor.dart';
// import '../services/session.dart';
// import 'SupportNewScreen.dart';
//
// class NeedHelp extends StatefulWidget {
//   const NeedHelp({
//     Key? key,
//   }) : super(key: key);
//   @override
//   _NeedHelpState createState() => _NeedHelpState();
// }
//
// class _NeedHelpState extends State<NeedHelp> {
//    YoutubePlayerController? _controller;
//   late TextEditingController _idController;
//   late TextEditingController _seekToController;
//
//   late PlayerState _playerState;
//   late YoutubeMetaData _videoMetaData;
//   bool _isPlayerReady = false;
//
//   List<String> _ids = [];
//   String? url, title;
//
//   getHelp() async {
//     var headers = {
//       'Cookie': 'ci_session=521e7894daca5e3189ecd3dd2cd31fd3c14d22c9'
//     };
//     var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(
//             'https://pickport.in/api/Authentication/get_driver_help'));
//
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       var finalResponse = await response.stream.bytesToString();
//       var result = jsonDecode(finalResponse);
//       if (result['status'] == true) {
//         setState(() {
//           url = result['data'][0]['url'].toString();
//           title = result['data'][0]['description'].toString();
//           String videoId;
//           videoId = YoutubePlayer.convertUrlToId(url ?? "") ?? "";
//           print(videoId);
//           _ids.add(videoId);
//           print('____Som______${url}_________');
//         });
//       }
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   setController() async {
//     await getHelp();
//     _controller = YoutubePlayerController(
//       initialVideoId: _ids.first,
//       flags: const YoutubePlayerFlags(
//         mute: false,
//         autoPlay: true,
//         disableDragSeek: false,
//         loop: false,
//         isLive: false,
//         forceHD: false,
//         enableCaption: true,
//       ),
//     )..addListener(listener);
//     _idController = TextEditingController();
//     _seekToController = TextEditingController();
//     _videoMetaData = const YoutubeMetaData();
//     _playerState = PlayerState.unknown;
//
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     setController();
//   }
//
//   void listener() {
//     if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
//       setState(() {
//         _playerState = _controller!.value.playerState;
//         _videoMetaData = _controller!.metadata;
//       });
//     }
//   }
//
//   @override
//   void deactivate() {
//     // Pauses video while navigating to next page.
//     _controller!.pause();
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     _controller!.dispose();
//     _idController.dispose();
//     _seekToController.dispose();
//     super.dispose();
//   }
//
//   bool showStatusBar = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: colors.whiteTemp,
//         appBar: PreferredSize(
//             preferredSize: const Size.fromHeight(110),
//             child: !showStatusBar
//                 ? noAppBar(
//                     context,
//                     text:
//                         // getTranslated(context, "Get Help"),
//                         getTranslated(context, "NEED_HELP"),
//                     //"Get Help"
//                   )
//                 : Container(
//                     height: 110,
//                     padding:
//                         const EdgeInsets.only(left: 10, right: 10, top: 30),
//                     //padding: EdgeInsets.only(top: 10),
//                     decoration: const BoxDecoration(
//                         color: CustomColors.primaryColor,
//                         borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(15),
//                             bottomRight: Radius.circular(15))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             // margin: EdgeInsets.all(10),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: const Icon(
//                               Icons.arrow_back,
//                               color: CustomColors.primaryColor,
//                             ),
//                           ),
//                         ),
//                         const Text(
//                           "Need Help ?",
//                           style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         const SupportNewScreen()));
//                           },
//                           child: Container(
//                             // margin: EdgeInsets.all(10),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: const Icon(
//                               Icons.headset_rounded,
//                               color: CustomColors.primaryColor,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ))),
//         body: _controller == null
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: YoutubePlayerBuilder(
//                     onEnterFullScreen: () {
//                       showStatusBar = false;
//                       setState(() {});
//                     },
//                     onExitFullScreen: () {
//                       showStatusBar = true;
//                       setState(() {});
//                     },
//                     player: YoutubePlayer(
//                       controller: _controller!,
//                       showVideoProgressIndicator: true,
//                       progressIndicatorColor: Colors.blueAccent,
//                       onReady: () {
//                         _isPlayerReady = true;
//                       },
//                       onEnded: (data) {
//                         _controller!.load(
//                             _ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
//                         _showSnackBar('Next Video Started!');
//                       },
//                     ),
//                     builder: (context, player) => Scaffold(
//                       body: ListView(
//                         children: [
//                           SizedBox(
//                             height: 20,
//                           ),
//                           player,
//                           player,
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Center(
//                               child: Text(
//                             title ?? "",
//                             style: TextStyle(color: Colors.black, fontSize: 16),
//                           ))
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ));
//   }
//
//   Widget _text(String title, String value) {
//     return RichText(
//       text: TextSpan(
//         text: '$title : ',
//         style: const TextStyle(
//           color: Colors.blueAccent,
//           fontWeight: FontWeight.bold,
//         ),
//         children: [
//           TextSpan(
//             text: value,
//             style: const TextStyle(
//               color: Colors.blueAccent,
//               fontWeight: FontWeight.w300,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getStateColor(PlayerState state) {
//     switch (state) {
//       case PlayerState.unknown:
//         return Colors.grey[700]!;
//       case PlayerState.unStarted:
//         return Colors.pink;
//       case PlayerState.ended:
//         return Colors.red;
//       case PlayerState.playing:
//         return Colors.blueAccent;
//       case PlayerState.paused:
//         return Colors.orange;
//       case PlayerState.buffering:
//         return Colors.yellow;
//       case PlayerState.cued:
//         return Colors.blue[900]!;
//       default:
//         return Colors.blue;
//     }
//   }
//
//   Widget get _space => const SizedBox(height: 10);
//   //
//   // Widget _loadCueButton(String action) {
//   //   return Expanded(
//   //     child: MaterialButton(
//   //       color: Colors.blueAccent,
//   //       onPressed: _isPlayerReady
//   //           ? () {
//   //         if (_idController.text.isNotEmpty) {
//   //           var id = YoutubePlayer.convertUrlToId(
//   //             _idController.text,
//   //           ) ??
//   //               '';
//   //           if (action == 'LOAD') _controller.load(id);
//   //           if (action == 'CUE') _controller.cue(id);
//   //           FocusScope.of(context).requestFocus(FocusNode());
//   //         } else {
//   //           _showSnackBar('Source can\'t be empty!');
//   //         }
//   //       }
//   //           : null,
//   //       disabledColor: Colors.grey,
//   //       disabledTextColor: Colors.black,
//   //       child: Padding(
//   //         padding: const EdgeInsets.symmetric(vertical: 14.0),
//   //         child: Text(
//   //           action,
//   //           style: const TextStyle(
//   //             fontSize: 18.0,
//   //             color: Colors.white,
//   //             fontWeight: FontWeight.w300,
//   //           ),
//   //           textAlign: TextAlign.center,
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontWeight: FontWeight.w300,
//             fontSize: 16.0,
//           ),
//         ),
//         backgroundColor: Colors.blueAccent,
//         behavior: SnackBarBehavior.floating,
//         elevation: 1.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50.0),
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Utils/AppBar.dart';
import '../Utils/Color.dart';
import '../Utils/CustomColor.dart';
import '../services/session.dart';
import 'SupportNewScreen.dart';

class NeedHelp extends StatefulWidget {
  const NeedHelp({
    Key? key,
  }) : super(key: key);
  @override
  _NeedHelpState createState() => _NeedHelpState();
}

class _NeedHelpState extends State<NeedHelp> {
  List<YoutubePlayerController> _controllers = [];
  List<String> _titles = [];
  bool _isPlayerReady = false;
  bool showStatusBar = true;

  // Function to filter valid YouTube URLs and create controllers
  getHelp() async {
    var headers = {
      'Cookie': 'ci_session=521e7894daca5e3189ecd3dd2cd31fd3c14d22c9'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://pickport.in/api/Authentication/get_driver_help'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      var result = jsonDecode(finalResponse);

      if (result['status'] == true) {
        setState(() {
          for (var video in result['data']) {
            String url = video['url'].toString();
            //String url = 'https://www.youtube.com/watch?v=dgBcSGiouW8';
            String title = video['description'].toString();

            // Check if the URL is a valid YouTube URL by converting it to a video ID
            String? videoId = YoutubePlayer.convertUrlToId(url);

            // If the URL is valid, create a player controller
            if (videoId != null && videoId.isNotEmpty) {
              _controllers.add(YoutubePlayerController(
                initialVideoId: videoId,
                flags: const YoutubePlayerFlags(
                  mute: false,
                  autoPlay: false,
                  disableDragSeek: false,
                  loop: false,
                  isLive: false,
                  forceHD: false,
                  enableCaption: true,
                ),
              ));
              _titles.add(title);
            }
          }
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    getHelp();
  }

  @override
  void dispose() {
    // Dispose each YoutubePlayerController
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.whiteTemp,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: !showStatusBar
              ? noAppBar(
            context,
            text: getTranslated(context, "NEED_HELP"),
          )
              : Container(
              height: 110,
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
              decoration: const BoxDecoration(
                  color: CustomColors.primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.arrow_back,
                        color: CustomColors.primaryColor,
                      ),
                    ),
                  ),
                  const Text(
                    "Need Help?",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const SupportNewScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.headset_rounded,
                        color: CustomColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ))),
      body: _controllers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: YoutubePlayerBuilder(
              onEnterFullScreen: () {
                showStatusBar = false;
                setState(() {});
              },
              onExitFullScreen: () {
                showStatusBar = true;
                setState(() {});
              },
              player: YoutubePlayer(
                controller: _controllers[index],
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                onReady: () {
                  _isPlayerReady = true;
                },
                onEnded: (data) {
                  _controllers[index].seekTo(Duration.zero);
                },
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(isExpanded: true),
                  // const SizedBox(width: 10),
                  // IconButton(
                  //   icon: const Icon(Icons.volume_off, color: Colors.white,), // Change this icon if needed
                  //   onPressed: () {
                  //     // Your mute/unmute logic
                  //   },
                  // ),
                  // IconButton(
                  //   icon: const Icon(Icons.play_arrow), // Example play button
                  //   onPressed: () {
                  //     // Your play logic
                  //   },
                  // ),
                  // Add more buttons as needed
                ],
              ),
              builder: (context, player) => Column(
                children: [
                  player,
                  const SizedBox(height: 10),
                  Text(
                    _titles[index],
                    style: const TextStyle(
                        color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
