import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ksice/employee/map/widget/bottomSheetMap.dart';
import 'package:ksice/login/Service/loginController.dart';
import 'package:ksice/model/routePoints.dart';
import 'package:ksice/model/user.dart';
import 'package:ksice/widgets/loadingDialog.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  double? lat;
  double? long;
  LatLng? currentPosition;
  BitmapDescriptor? customIcon;
  bool load = false;
  User? user;

  Set<Marker> markers = {}; // Set of markers on the map

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
    await context.read<LoginController>().initialize();
    final user2 = context.read<LoginController>().user;
    if (mounted) {
      setState(() {
        user = user2;
        load = true;
      });
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
    final Set<Marker> allMarkers = user.trucks![0].routes![0].route_points!.map((item) {
      return Marker(
        markerId: MarkerId(item.id.toString()),
        position: LatLng(double.parse(item.member_branch!.latitude!), double.parse(item.member_branch!.latitude!)),
        // infoWindow: InfoWindow(title: item['title']),
        icon: BitmapDescriptor.defaultMarkerWithHue(item.is_active == 1 ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue),
        onTap: () {
          double distanceInMeters = Geolocator.distanceBetween(
            lat!,
            long!,
            double.parse(item.member_branch!.latitude!),
            double.parse(item.member_branch!.latitude!),
          );
          print('ห่างกันกี่เมตร $distanceInMeters');
          final out = _showBottomSheet(context, distanceInMeters, item);
          print(out);
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

  final Map<String, Offset> _markerScreenPositions = {};

  void _updateAllMarkerPositions() async {
    if (mapController == null) return;
    if (mounted) {
      for (var item in user!.trucks![0].routes![0].route_points!) {
        final LatLng latLng = LatLng(double.parse(item.member_branch!.latitude!), double.parse(item.member_branch!.latitude!));
        final screenCoordinate = await mapController!.getScreenCoordinate(latLng);

        _markerScreenPositions[item.id.toString()] = Offset(
          screenCoordinate.x.toDouble(),
          screenCoordinate.y.toDouble(),
        );
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Column(
        children: [
          load == false
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: size.height * 0.721,
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
                          height: size.height * 0.721,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(lat!, long!), // ตำแหน่งเริ่มต้นของกล้อง
                              zoom: 12, // การซูมเริ่มต้น
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
                          height: size.height * 0.721,
                          child: Stack(
                            children: [
                              GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(lat!, long!), // ตำแหน่งเริ่มต้นของกล้อง
                                  zoom: 12, // การซูมเริ่มต้น
                                ),
                                myLocationButtonEnabled: false,
                                myLocationEnabled: false,
                                onMapCreated: (controller) async {
                                  mapController = controller;
                                  await Future.delayed(Duration(milliseconds: 100));
                                  _updateAllMarkerPositions();
                                },
                                onCameraMove: (_) => _updateAllMarkerPositions(),
                                markers: getMarkersFromData(user!),
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
                              ...user!.trucks![0].routes![0].route_points!.map((item) {
                                final Offset? pos = _markerScreenPositions[item.id.toString()];
                                if (pos == null) return Container();

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
                                        SizedBox(
                                          width: 5,
                                        ),
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

  _showBottomSheet(BuildContext context, double distanceInMeters, RoutePoints item) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // พื้นหลังเป็นสีใส
      builder: (context) {
        return BottonSheetMap(
          distanceInMeters: distanceInMeters,
          item: item,
        );
      },
    );
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
