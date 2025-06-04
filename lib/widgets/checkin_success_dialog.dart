import 'package:flutter/material.dart';

class CheckInSuccessDialog extends StatelessWidget {
  final String timeText;

  const CheckInSuccessDialog({super.key, required this.timeText});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icon_success.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 24),
            Text(
              'เวลาเช็คอิน $timeText',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorDialog extends StatefulWidget {
  ErrorDialog({super.key, required this.description, this.pressYes, InkWell? onTap});
  final String description;
  final VoidCallback? pressYes;

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(16),
            ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/Group (3)_0.png',
              width: size.width * 0.25,
              height: size.height * 0.15,
            ),
            // Icon(
            //   Icons.check_circle,
            //   color: Colors.black,
            //   size: 150,
            // ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: widget.pressYes,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                width: size.width * 0.55,
                height: size.height * 0.055,
                decoration: BoxDecoration(
                  color: Colors.black,
                  // border: Border.all(color: kMainColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'ปิดหน้าต่าง',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceDialog extends StatefulWidget {
  ChoiceDialog({super.key, required this.description, this.pressYes, InkWell? onTap, required this.type, this.pressNo});
  final String description, type;
  final VoidCallback? pressYes, pressNo;

  @override
  State<ChoiceDialog> createState() => _ChoiceDialogState();
}

class _ChoiceDialogState extends State<ChoiceDialog> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(16),
            ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              widget.type == 'delete'
                  ? 'assets/images/Group (1)_0.png'
                  : widget.type == 'save'
                      ? 'assets/images/Group (4).png'
                      : 'assets/images/Group (3)_0.png',
              width: size.width * 0.25,
              height: size.height * 0.15,
            ),
            // Icon(
            //   Icons.check_circle,
            //   color: Colors.black,
            //   size: 150,
            // ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: widget.pressNo,
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.055,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: widget.pressYes,
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.055,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      // border: Border.all(color: kMainColor),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'ยืนยัน',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
