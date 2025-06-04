import 'package:flutter/material.dart';

class LoadingDialog {
  static Future<void> open(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.5),
      builder: (BuildContext buildContext) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        );
      },
    );
  }

  // static Future<void> open(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     barrierColor: Colors.grey.withOpacity(0.8),
  //     builder: (BuildContext buildContext) {
  //       return AlertDialog(
  //         backgroundColor: kTextButtonColor,
  //         // title: Center(
  //         //   child: Text(
  //         //     title,
  //         //     style: TextStyle(
  //         //       fontSize: 18,
  //         //     ),
  //         //   ),
  //         // ),
  //         content: SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.2,
  //           width: MediaQuery.of(context).size.width * 0.35,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               LoadingAnimationWidget.staggeredDotsWave(
  //                 color: Colors.red,
  //                 size: 50,
  //               ),
  //               // Image.asset(
  //               //   'assets/GS/icons/Frame.png',
  //               //   scale: 1.5,
  //               // ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Text(
  //                 'กรุณารอสักครู่...',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  static void close(BuildContext context) {
    Navigator.pop(context);
  }
}
