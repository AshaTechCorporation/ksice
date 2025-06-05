import 'package:flutter/material.dart';
import 'package:ksice/constants.dart';

class AlertDialogExit extends StatefulWidget {
  AlertDialogExit(
      {Key? key,
      required this.description,
      required this.pressYes,
      required this.title,
      required this.pressNo,
      required this.orderNo,
      this.txtYes = 'ตกลง',
      this.txtNo = 'ยกเลิก',
      this.presscancel,
      this.image})
      : super(key: key);
  final String title, description, orderNo;
  final String? txtYes, txtNo;
  final VoidCallback pressYes;
  final VoidCallback pressNo;
  VoidCallback? presscancel;
  String? image;

  @override
  State<AlertDialogExit> createState() => _AlertDialogExitState();
}

class _AlertDialogExitState extends State<AlertDialogExit> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
      backgroundColor: textWhiteColor,
      title: Column(
        children: [Text('แจ้งเตือน')],
      ),
      content: widget.description != ""
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.description} ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            )
          : SizedBox.shrink(),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: widget.pressNo,
                child: Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: Colors.black45)),
                  child: SizedBox(
                    width: size.width * 0.18,
                    height: size.height * 0.06,
                    child: Center(
                        child: Text(
                      widget.txtNo!,
                      style: TextStyle(color: Colors.black26, fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.pressYes,
              child: Card(
                color: buttonColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: SizedBox(
                  width: size.width * 0.18,
                  height: size.height * 0.06,
                  child: Center(
                      child: Text(
                    widget.txtYes!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
