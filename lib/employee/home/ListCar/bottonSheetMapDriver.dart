import 'package:flutter/material.dart';
import 'package:ksice/model/driverCar/driverCar.dart';

class BottonSheetMapDriver extends StatefulWidget {
  const BottonSheetMapDriver({super.key, required this.driver});
  final DriverCar driver;

  @override
  State<BottonSheetMapDriver> createState() => _BottonSheetMapDriverState();
}

class _BottonSheetMapDriverState extends State<BottonSheetMapDriver> {
  double currentExtent = 0.55;

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        setState(() {
          currentExtent = notification.extent;
        });
        return true;
      },
      child: DraggableScrollableSheet(
          initialChildSize: 0.55,
          maxChildSize: 1.0,
          minChildSize: 0.3,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.horizontal_rule_sharp,
                            color: Colors.transparent,
                            size: 45,
                          ),
                          Icon(
                            Icons.horizontal_rule_sharp,
                            size: 45,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.close,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: size.width * 0.75,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Text(widget.item.member_branch?.name ?? ' - ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                          // Text(widget.item.member_branch?.contact_phone ?? ' - ', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11)),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          _buildTag('OPEN', Colors.green),
                                          SizedBox(width: 6),
                                          _buildTag('เวลาทำการ: 08.00 น. - 17.00 น.', Colors.blue),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: currentExtent > 0.7 ? size.height * 0.7 : size.height * 0.3,
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text('ที่อยู่', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                    SizedBox(height: 10),
                                    // Text(
                                    //     '${widget.item.member_branch?.address ?? ' - '} ${widget.item.member_branch?.sub_district ?? ' - '}  ${widget.item.member_branch?.district ?? ' - '}  ${widget.item.member_branch?.province ?? ' - '}',
                                    //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                    SizedBox(height: 10),
                                    Text('วันเวลาที่ต้องส่ง', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('วันจันทร์', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                        Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('วันอังคาร', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                        Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('วันพุธ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                        Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('วันพฤหัสบดี', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                        Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('วันศุกร์', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                        Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('วันเสาร์', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                        Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('วันอาทิตย์', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                        Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
