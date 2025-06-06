import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksice/constants.dart';
import 'package:ksice/employee/home/fristPage.dart';
import 'package:ksice/employee/home/services/homeService.dart';
import 'package:ksice/employee/map/ordersItem.dart';
import 'package:ksice/employee/map/testmap.dart';
import 'package:ksice/employee/map/widget/bottomSheetMap.dart';
import 'package:ksice/login/Service/loginController.dart';
import 'package:ksice/model/routePoints.dart';
import 'package:ksice/model/user.dart';
import 'package:ksice/upload/uploadService.dart';
import 'package:ksice/utils/ApiExeption.dart';
import 'package:ksice/widgets/checkin_success_dialog.dart';
import 'package:ksice/widgets/loadingDialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey mapKey = GlobalKey();
  GoogleMapController? mapController;
  double? lat;
  double? long;
  LatLng? currentPosition;
  BitmapDescriptor? customIcon;
  bool load = false;
  User? user;

  Set<Marker> markers = {}; // Set of markers on the map
  List<LatLng> polylineCoordinates = [];

  final picker = ImagePicker();
  File? listimages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCustomIcon();
      await getLocation();
      await getUser();
    });
  }

  getUser() async {
    // LoadingDialog.open(context);
    try {
      await context.read<LoginController>().initialize();
      final user2 = context.read<LoginController>().user;
      if (mounted) {
        setState(() {
          user = user2;
          load = true;
        });
      }
    } on ClientException catch (e) {
      if (!mounted) return;
      // LoadingDialog.close(context);
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
      // LoadingDialog.close(context);
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
      // LoadingDialog.close(context);
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
      // LoadingDialog.close(context);
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
  }

  Future<void> _loadCustomIcon() async {
    customIcon = await BitmapDescriptor.asset(
      ImageConfiguration(),
      width: 40,
      height: 50,
      'assets/images/marker.png',
    );
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (mounted) {
          setState(() {
            currentPosition = LatLng(position.latitude, position.longitude);
            lat = position.latitude;
            long = position.longitude;
            load = true;
          });
        }
      } else if (permission == LocationPermission.deniedForever) {
        setState(() {
          load = true;
        });
      } else {
        await getLocation();
      }
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          currentPosition = LatLng(position.latitude, position.longitude);

          lat = position.latitude;
          long = position.longitude;
          load = true;
        });
      }
    }
  }

  Set<Marker> getMarkersFromData(User user) {
    final Set<Marker> allMarkers = user.trucks![0].routes![1].route_points!.map((item) {
      return Marker(
        markerId: MarkerId(item.id.toString()),
        position: LatLng(double.parse(item.latitude!), double.parse(item.longitude!)),
        // infoWindow: InfoWindow(title: item['title']),
        icon: BitmapDescriptor.defaultMarkerWithHue(item.is_active == 1 ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue),
        onTap: () async {
          double distanceInMeters = Geolocator.distanceBetween(
            lat!,
            long!,
            double.parse(item.latitude!),
            double.parse(item.longitude!),
          );
          print('ห่างกันกี่เมตร $distanceInMeters');
          getPolyPoints(
            double.parse(item.latitude!),
            double.parse(item.longitude!),
          );
          _showBottomSheet(context, distanceInMeters, item, lat!, long!);
        },
      );
    }).toSet();

    // เพิ่มตำแหน่งตัวเอง (ถ้ามีข้อมูล)
    if (currentPosition != null) {
      allMarkers.add(
        Marker(
          markerId: MarkerId('my_location'),
          position: currentPosition!,
          icon: customIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'ตำแหน่งของฉัน'),
        ),
      );
    }

    return allMarkers;
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void getPolyPoints(double latStrat, longStrat) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: 'AIzaSyB6nobedKqsMxY5omMWNE1e449BBo_Q3sw',
      request: PolylineRequest(
        origin: PointLatLng(lat!, long!),
        destination: PointLatLng(latStrat, longStrat),
        mode: TravelMode.driving,
      ),
    );

    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
      setState(() {});
    }
    return;
  }

  final Map<String, Offset> _markerScreenPositions = {};

  void _updateAllMarkerPositions() async {
    if (mapController == null) return;
    if (mounted) {
      for (var item in user!.trucks![0].routes![1].route_points!) {
        final LatLng latLng = LatLng(double.parse(item.latitude!), double.parse(item.longitude!));
        final screenCoordinate = await mapController!.getScreenCoordinate(latLng);

        _markerScreenPositions[item.id.toString()] = Offset(
          screenCoordinate.x.toDouble(),
          screenCoordinate.y.toDouble(),
        );
      }

      setState(() {});
    }
  }

  // void _checkPermissionAndStart() async {
  //   bool serviceEnabled = await _location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await _location.requestService();
  //   }

  //   PermissionStatus permissionGranted = await _location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await _location.requestPermission();
  //   }

  //   if (permissionGranted == PermissionStatus.granted) {
  //     _startLocationTracking();
  //   }
  // }

  // void _startLocationTracking() {
  //   _location.changeSettings(interval: 1000); // ทุก 1 วินาที
  //   _location.onLocationChanged.listen((LocationData currentLocation) {
  //     LatLng newPosition = LatLng(
  //       currentLocation.latitude ?? 0.0,
  //       currentLocation.longitude ?? 0.0,
  //     );

  //     setState(() {
  //       _polylineCoordinates.add(newPosition);
  //       _polylines = {
  //         Polyline(
  //           polylineId: PolylineId("moving_line"),
  //           color: Colors.blue,
  //           width: 5,
  //           points: _polylineCoordinates,
  //         ),
  //       };
  //     });

  //     _moveCamera(newPosition);
  //   });
  // }

  // void _moveCamera(LatLng position) {
  //   _mapController?.animateCamera(
  //     CameraUpdate.newLatLng(position),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FlutterMapWithLabels(
                  user: user!,
                  lat: lat!,
                  long: long!,
                );
              }));
            },
            child: Text('Map')),
      ),
      body: Column(
        children: [
          load == false
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: size.height * 0.724,
                  child: Center(child: CircularProgressIndicator()),
                )
              : lat == null && long == null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: size.height * 0.721,
                      child: Center(
                        child: Text('กรุณาเปิดตำแหน่ง'),
                      ),
                    )
                  : user == null && user?.trucks == null && user?.trucks?[0].routes == null && user?.trucks?[0].routes?[0].route_points == null
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: size.height * 0.715,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(lat!, long!), // ตำแหน่งเริ่มต้นของกล้อง
                              zoom: 14, // การซูมเริ่มต้น
                            ),
                            myLocationButtonEnabled: false,
                            myLocationEnabled: false,
                            markers: {
                              Marker(
                                markerId: MarkerId('my_location'),
                                position: currentPosition!,
                                icon: customIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                                infoWindow: InfoWindow(title: 'ตำแหน่งของฉัน'),
                              ),
                            },
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: size.height * 0.715,
                          child: Stack(
                            children: [
                              GoogleMap(
                                key: mapKey,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(lat!, long!), // ตำแหน่งเริ่มต้นของกล้อง
                                  zoom: 14, // การซูมเริ่มต้น
                                ),
                                myLocationButtonEnabled: false,
                                myLocationEnabled: false,
                                zoomControlsEnabled: false,
                                onMapCreated: (controller) async {
                                  mapController = controller;
                                  if (Platform.isAndroid) {
                                    await Future.delayed(Duration(milliseconds: 500));
                                  } else {
                                    await Future.delayed(Duration(milliseconds: 100));
                                  }

                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    _updateAllMarkerPositions();
                                  });
                                },
                                onCameraMove: (_) => _updateAllMarkerPositions(),

                                markers: getMarkersFromData(user!),
                                polylines: {
                                  Polyline(
                                    polylineId: PolylineId('route'),
                                    points: polylineCoordinates,
                                    color: buttonColor,
                                    width: 12,
                                  )
                                },
                                // markers: {
                                //   Marker(
                                //     markerId: MarkerId('Marker1'),
                                //     position: LatLng(lat!, long!),
                                //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                                //     infoWindow: InfoWindow(
                                //       title: 'ร้านที่ 1',
                                //       // snippet: 'กรุงเทพมหานคร',
                                //     ),
                                //     onTap: () {
                                //       double distanceInMeters = Geolocator.distanceBetween(
                                //         lat!,
                                //         long!,
                                //         lat!,
                                //         long!,
                                //       );
                                //       print('ห่างกันกี่เมตร $distanceInMeters');
                                //       _showBottomSheet(context, distanceInMeters);
                                //     },
                                //   ),
                                //   Marker(
                                //     markerId: MarkerId('Marker2'),
                                //     position: LatLng(13.7222, 100.7797),
                                //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                                //     infoWindow: InfoWindow(
                                //       title: 'ร้านที่ 2',
                                //       // snippet: 'กรุงเทพมหานคร',
                                //     ),
                                //     onTap: () {
                                //       double distanceInMeters = Geolocator.distanceBetween(
                                //         lat!,
                                //         long!,
                                //         13.7222,
                                //         100.7797,
                                //       );
                                //       print('ห่างกันกี่เมตร $distanceInMeters');
                                //       _showBottomSheet(context, distanceInMeters);
                                //     },
                                //   ),
                                //   Marker(
                                //     markerId: MarkerId('Marker3'),
                                //     position: LatLng(13.7226, 100.7792),
                                //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                                //     infoWindow: InfoWindow(
                                //       title: 'ร้านที่ 3',
                                //       // snippet: 'กรุงเทพมหานคร',
                                //     ),
                                //     onTap: () {
                                //       double distanceInMeters = Geolocator.distanceBetween(
                                //         lat!,
                                //         long!,
                                //         13.7226,
                                //         100.7792,
                                //       );
                                //       print('ห่างกันกี่เมตร $distanceInMeters');
                                //       _showBottomSheet(context, distanceInMeters);
                                //     },
                                //   ),
                                //   Marker(
                                //     markerId: MarkerId('Marker4'),
                                //     position: LatLng(13.7215, 100.7790),
                                //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                                //     infoWindow: InfoWindow(
                                //       title: 'ร้านที่ 4',
                                //       // snippet: 'กรุงเทพมหานคร',
                                //     ),
                                //     onTap: () {
                                //       double distanceInMeters = Geolocator.distanceBetween(
                                //         lat!,
                                //         long!,
                                //         13.7215,
                                //         100.7790,
                                //       );
                                //       print('ห่างกันกี่เมตร $distanceInMeters');
                                //       _showBottomSheet(context, distanceInMeters);
                                //     },
                                //   ),
                                //   Marker(
                                //     markerId: MarkerId('Marker5'),
                                //     position: LatLng(13.7230, 100.7805),
                                //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                                //     infoWindow: InfoWindow(
                                //       title: 'ร้านที่ 5',
                                //       // snippet: 'กรุงเทพมหานคร',
                                //     ),
                                //     onTap: () {
                                //       double distanceInMeters = Geolocator.distanceBetween(
                                //         lat!,
                                //         long!,
                                //         13.7230,
                                //         100.7805,
                                //       );
                                //       print('ห่างกันกี่เมตร $distanceInMeters');
                                //       _showBottomSheet(context, distanceInMeters);
                                //     },
                                //   ),
                                // },
                              ),
                              ...user!.trucks![0].routes![1].route_points!.map((item) {
                                final Offset? pos = _markerScreenPositions[item.id.toString()];
                                if (pos == null) return SizedBox();

                                return Positioned(
                                  left: pos.dx - 40,
                                  top: pos.dy - 60,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black26)],
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 8,
                                          backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          item.member_branch?.name ?? ' - ',
                                          style: TextStyle(fontSize: 10, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
        ],
      ),
    );
  }

  _showBottomSheet(BuildContext context, double distanceInMeters, RoutePoints item, double lat, double long) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // พื้นหลังเป็นสีใส
      builder: (context) {
        return BottonSheetMap(
          distanceInMeters: distanceInMeters,
          item: item,
          lat: lat,
          long: long,
        );
      },
    );
  }

  // _showBottomSheet(BuildContext context, double distanceInMeters, RoutePoints item, double lat, double long) async {
  //   final size = MediaQuery.of(context).size;
  //   print(size.height);
  //   final out = await showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent, // พื้นหลังเป็นสีใส
  //     builder: (context) {
  //       return DraggableScrollableSheet(
  //         initialChildSize: 0.55,
  //         maxChildSize: 1.0,
  //         minChildSize: 0.3,
  //         builder: (_, scrollController) {
  //           print(scrollController);
  //           return Container(
  //             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Column(
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Icon(
  //                           Icons.horizontal_rule_sharp,
  //                           color: Colors.transparent,
  //                           size: 45,
  //                         ),
  //                         Icon(
  //                           Icons.horizontal_rule_sharp,
  //                           size: 45,
  //                         ),
  //                         GestureDetector(
  //                           onTap: () {
  //                             Navigator.pop(context, true);
  //                           },
  //                           child: Padding(
  //                             padding: const EdgeInsets.symmetric(horizontal: 8),
  //                             child: Icon(
  //                               Icons.close,
  //                               size: 30,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 16),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Row(
  //                             children: [
  //                               CircleAvatar(
  //                                 radius: 17,
  //                                 backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
  //                               ),
  //                               SizedBox(
  //                                 width: 10,
  //                               ),
  //                               SizedBox(
  //                                 width: size.width * 0.75,
  //                                 child: Column(
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     Row(
  //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                       children: [
  //                                         Text(item.member_branch?.name ?? ' - ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
  //                                         Text(item.member_branch?.contact_phone ?? ' - ', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11)),
  //                                       ],
  //                                     ),
  //                                     SizedBox(height: 4),
  //                                     Row(
  //                                       children: [
  //                                         _buildTag('OPEN', Colors.green),
  //                                         SizedBox(width: 6),
  //                                         _buildTag('เวลาทำการ: 08.00 น. - 17.00 น.', Colors.blue),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: size.height * 0.3,
  //                             child: SingleChildScrollView(
  //                               controller: scrollController,
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   SizedBox(height: 10),
  //                                   Text('ที่อยู่', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
  //                                   SizedBox(height: 10),
  //                                   Text(
  //                                       '${item.member_branch?.address ?? ' - '} ${item.member_branch?.sub_district ?? ' - '}  ${item.member_branch?.district ?? ' - '}  ${item.member_branch?.province ?? ' - '}',
  //                                       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
  //                                   SizedBox(height: 10),
  //                                   Text('วันเวลาที่ต้องส่ง', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
  //                                   SizedBox(height: 10),
  //                                   Row(
  //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Text('วันจันทร์', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
  //                                       Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
  //                                     ],
  //                                   ),
  //                                   SizedBox(height: 10),
  //                                   Row(
  //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Text('วันอังคาร', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
  //                                       Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
  //                                     ],
  //                                   ),
  //                                   SizedBox(height: 10),
  //                                   Row(
  //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Text('วันพุธ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
  //                                       Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
  //                                     ],
  //                                   ),
  //                                   SizedBox(height: 10),
  //                                   Row(
  //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Text('วันพฤหัสบดี', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
  //                                       Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
  //                                     ],
  //                                   ),
  //                                   SizedBox(height: 10),
  //                                   Row(
  //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Text('วันศุกร์', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
  //                                       Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
  //                                     ],
  //                                   ),
  //                                   SizedBox(height: 10),
  //                                   Row(
  //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Text('วันเสาร์', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
  //                                       Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
  //                                     ],
  //                                   ),
  //                                   SizedBox(height: 10),
  //                                   Row(
  //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Text('วันอาทิตย์', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
  //                                       Text('08:00 น. - 17:00 น.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(16),
  //                   child: SizedBox(
  //                     width: double.infinity,
  //                     height: 48,
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         if (distanceInMeters <= 5) {
  //                           if (item.is_active == 1) {
  //                             Navigator.pop(context);
  //                             final out = await _showBottomSheetCheckIn(context, item, lat, long);
  //                             print(out);
  //                           } else {
  //                             Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                               return OrdersItemsPage(
  //                                 shop: item,
  //                               );
  //                             }));
  //                           }
  //                         }
  //                         // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => FristPage()), (route) => false);
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: distanceInMeters >= 5 ? Colors.grey : const Color(0xFF2D3194),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                       ),
  //                       child: Text(
  //                         item.is_active == 1 ? 'เช็คอิน' : 'ส่งสินค้า',
  //                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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

  _showBottomSheetCheckIn(BuildContext context, RoutePoints item, double lat, double long) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // พื้นหลังเป็นสีใส
      builder: (context) {
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
                                              Text(item.member_branch?.name ?? ' - ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                              Text(item.member_branch?.contact_phone ?? ' - ', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11)),
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
                                await HomeService.checkInPoint(route_id: item.route_id!, route_point_id: item.id, latitude: lat, longitude: long, image: imageAPI);
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

  List<Map<String, dynamic>> marker = [
    {"markerId": "marker1", "lat": 13.7226, "long": 100.7792, "title": "ร้านที่ 3", 'statusCheck': true, 'statusSend': false},
    {"markerId": "marker2", "lat": 13.7241, "long": 100.7787, "title": "ร้านที่ 4", 'statusCheck': true, 'statusSend': true},
    {"markerId": "marker3", "lat": 13.7233, "long": 100.7778, "title": "ร้านที่ 5", 'statusCheck': false, 'statusSend': false},
    {"markerId": "marker4", "lat": 13.7217, "long": 100.7815, "title": "ร้านที่ 6", 'statusCheck': true, 'statusSend': false},
    {"markerId": "marker5", "lat": 13.7209, "long": 100.7798, "title": "ร้านที่ 7", 'statusCheck': false, 'statusSend': false},
    {"markerId": "marker6", "lat": 13.7220, "long": 100.7810, "title": "ร้านที่ 8", 'statusCheck': false, 'statusSend': false},
    {"markerId": "marker7", "lat": 13.7237, "long": 100.7813, "title": "ร้านที่ 9", 'statusCheck': true, 'statusSend': false},
    {"markerId": "marker8", "lat": 13.7212, "long": 100.7782, "title": "ร้านที่ 10", 'statusCheck': false, 'statusSend': false},
    {"markerId": "marker9", "lat": 13.7230, "long": 100.7771, "title": "ร้านที่ 11", 'statusCheck': true, 'statusSend': true},
    {"markerId": "marker10", "lat": 13.7215, "long": 100.7775, "title": "ร้านที่ 12", 'statusCheck': true, 'statusSend': true}
  ];
}
