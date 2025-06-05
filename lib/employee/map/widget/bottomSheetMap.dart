import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksice/employee/home/fristPage.dart';
import 'package:ksice/employee/home/services/homeService.dart';
import 'package:ksice/employee/map/ordersItem.dart';
import 'package:ksice/model/routePoints.dart';
import 'package:ksice/upload/uploadService.dart';
import 'package:ksice/utils/ApiExeption.dart';
import 'package:ksice/widgets/checkin_success_dialog.dart';
import 'package:ksice/widgets/loadingDialog.dart';
import 'package:permission_handler/permission_handler.dart';

class BottonSheetMap extends StatefulWidget {
  const BottonSheetMap({super.key, required this.distanceInMeters, required this.item, required this.lat, required this.long});
  final double distanceInMeters;
  final RoutePoints item;
  final double lat;
  final double long;

  @override
  State<BottonSheetMap> createState() => _BottonSheetMapState();
}

class _BottonSheetMapState extends State<BottonSheetMap> {
  double currentExtent = 0.55;
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
                                        Text(widget.item.member_branch?.name ?? ' - ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                        Text(widget.item.member_branch?.contact_phone ?? ' - ', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11)),
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
                                  Text(
                                      '${widget.item.member_branch?.address ?? ' - '} ${widget.item.member_branch?.sub_district ?? ' - '}  ${widget.item.member_branch?.district ?? ' - '}  ${widget.item.member_branch?.province ?? ' - '}',
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (widget.distanceInMeters <= 5) {
                          if (widget.item.is_active == 1) {
                            Navigator.pop(context);
                            final out = await _showBottomSheet(context, widget.item, widget.lat, widget.long);
                            print(out);
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return OrdersItemsPage(
                                shop: widget.item,
                              );
                            }));
                          }
                        }
                        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => FristPage()), (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.distanceInMeters >= 5 ? Colors.grey : const Color(0xFF2D3194),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.item.is_active == 1 ? 'เช็คอิน' : 'ส่งสินค้า',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _showBottomSheet(BuildContext context, RoutePoints item, double lat, double long) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // พื้นหลังเป็นสีใส
      builder: (context) {
        return BottonSheetMapCheckIn(
          // distanceInMeters: distanceInMeters,
          item: item,
          lat: lat,
          long: long,
        );
      },
    );
  }

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
}

class BottonSheetMapCheckIn extends StatefulWidget {
  const BottonSheetMapCheckIn({super.key, required this.item, required this.lat, required this.long});
  // final double distanceInMeters;
  final RoutePoints item;
  final double lat;
  final double long;

  @override
  State<BottonSheetMapCheckIn> createState() => _BottonSheetMapCheckInState();
}

class _BottonSheetMapCheckInState extends State<BottonSheetMapCheckIn> {
  final picker = ImagePicker();
  File? listimages;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      // maxChildSize: 0.6,
      // minChildSize: 0.1,
      builder: (_, scrollController) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 35,
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
                                          Text(widget.item.member_branch?.name ?? ' - ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                          Text(widget.item.member_branch?.contact_phone ?? ' - ', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11)),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: listimages != null ? size.height * 0.05 : size.height * 0.1),
                            listimages != null
                                ? Column(
                                    children: [
                                      Image.file(
                                        listimages!,
                                        height: size.width * 0.45,
                                        width: size.width * 0.45,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            listimages = null;
                                          });
                                        },
                                        child: Center(
                                          child: Container(
                                            height: size.height * 0.07,
                                            width: size.width * 0.25,
                                            color: Colors.red,
                                            child: Center(
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      chooseImage();
                                    },
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.camera_alt_outlined,
                                            size: 50,
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Text('ภาพถ่ายหลักฐานการเช็คอิน (ถ้าจำเป็น)', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          String? imageAPI;
                          try {
                            LoadingDialog.open(context);
                            if (listimages != null) {
                              final image = await UoloadService.addImage(file: listimages, path: 'images/asset/');
                              imageAPI = image;
                            }
                            await HomeService.checkInPoint(route_id: widget.item.route_id!, route_point_id: widget.item.id, latitude: widget.lat, longitude: widget.long, image: imageAPI);
                            LoadingDialog.close(context);
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 3), () {
                                  Navigator.of(context).pop(true);
                                });
                                return CheckInSuccessDialog(timeText: '12:00 น.');
                              },
                            );
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FristPage(
                                          pageNum: 1,
                                        )),
                                (route) => false);
                          } on ClientException catch (e) {
                            if (!mounted) return;
                            LoadingDialog.close(context);
                            showDialog(
                              context: context,
                              builder: (context) => ErrorDialog(
                                description: '$e',
                                pressYes: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                            );
                          } on ApiException catch (e) {
                            if (!mounted) return;
                            LoadingDialog.close(context);
                            showDialog(
                              context: context,
                              builder: (context) => ErrorDialog(
                                description: '$e',
                                pressYes: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                            );
                          } on Exception catch (e) {
                            if (!mounted) return;
                            LoadingDialog.close(context);
                            showDialog(
                              context: context,
                              builder: (context) => ErrorDialog(
                                description: '$e',
                                pressYes: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            LoadingDialog.close(context);
                            showDialog(
                              context: context,
                              builder: (context) => ErrorDialog(
                                description: '$e',
                                pressYes: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          //  widget.distanceInMeters >= 200 ? Colors.grey :
                          backgroundColor: const Color(0xFF2D3194),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'ยืนยัน',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  chooseImage() async {
    Map<Permission, PermissionStatus> statues = await [Permission.storage, Permission.photos].request();
    PermissionStatus? statusStorage = statues[Permission.storage];
    PermissionStatus? statusPhotos = statues[Permission.photos];
    bool isGranted = statusStorage == PermissionStatus.granted && statusPhotos == PermissionStatus.granted;
    if (isGranted) {
      //openCameraGallery();
      //_openDialog(context);
    }
    bool isPermanentlyDenied = statusStorage == PermissionStatus.permanentlyDenied || statusPhotos == PermissionStatus.permanentlyDenied;
    if (isPermanentlyDenied) {
      // _showSettingsDialog(context);
    }
    final pickedFiles = await picker.pickImage(source: ImageSource.camera);
    if (pickedFiles != null) {
      listimages = File(pickedFiles.path);
    }

    setState(() {});
  }
}
