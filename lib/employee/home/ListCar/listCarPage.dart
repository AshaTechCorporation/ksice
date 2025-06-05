import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:ksice/employee/home/ListCar/bottonSheetMapDriver.dart';
import 'package:ksice/employee/home/services/homeService.dart';
import 'package:ksice/model/driverCar/driverCar.dart';
import 'package:ksice/utils/ApiExeption.dart';
import 'package:ksice/widgets/checkin_success_dialog.dart';

class ListCarPage extends StatefulWidget {
  const ListCarPage({super.key});

  @override
  State<ListCarPage> createState() => _ListCarPageState();
}

class _ListCarPageState extends State<ListCarPage> {
  late GoogleMapController mapController;
  LatLng? selectedPosition; // เริ่มที่กรุงเทพ

  List<DriverCar> driver = [];

  @override
  void initState() {
    super.initState();
    getLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getDeiver();
    });
  }

  getDeiver() async {
    // LoadingDialog.open(context);
    try {
      final driver1 = await HomeService.getListDriver();
      if (mounted) {
        setState(() {
          driver = driver1;
          // load = true;
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
            selectedPosition = LatLng(position.latitude, position.longitude);
            // lat = position.latitude;
            // long = position.longitude;
            // load = true;
          });
        }
      } else if (permission == LocationPermission.deniedForever) {
        setState(() {
          // load = true;
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
          selectedPosition = LatLng(position.latitude, position.longitude);

          // lat = position.latitude;
          // long = position.longitude;
          // load = true;
        });
      }
    }
  }

  Set<Marker> getMarkersFromData(List<DriverCar> driver) {
    final Set<Marker> allMarkers = driver.map((item) {
      return Marker(
        markerId: MarkerId(item.id.toString()),
        position: LatLng(double.parse(item.latest_checkin?.latitude ?? '0.0'), double.parse(item.latest_checkin?.longitude ?? '0.0')),
        // infoWindow: InfoWindow(title: item['title']),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onTap: () async {
          // double distanceInMeters = Geolocator.distanceBetween(
          //   lat!,
          //   long!,
          //   double.parse(item.latitude!),
          //   double.parse(item.longitude!),
          // );
          // print('ห่างกันกี่เมตร $distanceInMeters');
          // getPolyPoints(
          //   double.parse(item.latitude!),
          //   double.parse(item.longitude!),
          // );
          _showBottomSheet(item);
        },
      );
    }).toSet();

    return allMarkers;
  }

  final Map<String, Offset> _markerScreenPositions = {};

  void _updateAllMarkerPositions() async {
    if (mapController == null) return;
    if (mounted) {
      for (var item in driver) {
        final LatLng latLng = LatLng(double.parse(item.latest_checkin?.latitude ?? '0.0'), double.parse(item.latest_checkin?.longitude ?? '0.0'));
        final screenCoordinate = await mapController.getScreenCoordinate(latLng);

        _markerScreenPositions[item.id.toString()] = Offset(
          screenCoordinate.x.toDouble(),
          screenCoordinate.y.toDouble(),
        );
      }

      setState(() {});
    }
  }

  void _moveToLocation(LatLng latLng) {
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: selectedPosition == null
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: size.height * 0.75,
              child: Center(child: CircularProgressIndicator()),
            )
          : Stack(
              children: [
                // 🗺 Google Map
                Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: selectedPosition!,
                        zoom: 15,
                      ),
                      // onTap: (LatLng position) {
                      //   setState(() => selectedPosition = position);
                      // },
                      myLocationButtonEnabled: false,
                      myLocationEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (controller) async {
                        mapController = controller;
                        await Future.delayed(Duration(milliseconds: 100));
                        _updateAllMarkerPositions();
                      },
                      onCameraMove: (_) => _updateAllMarkerPositions(),
                      markers: getMarkersFromData(driver),
                    ),
                    ...driver.map((item) {
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
                                item.name ?? ' - ',
                                style: TextStyle(fontSize: 10, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),

                // 🔙 ปุ่มย้อนกลับ
                Positioned(
                  top: 50,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 25,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: size.height * 0.4,
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                            driver.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    if (driver[index].latest_checkin != null) {
                                      setState(() {
                                        _moveToLocation(LatLng(double.parse(driver[index].latest_checkin!.latitude!), double.parse(driver[index].latest_checkin!.longitude!)));
                                        selectedPosition = LatLng(double.parse(driver[index].latest_checkin!.latitude!), double.parse(driver[index].latest_checkin!.longitude!));
                                      });
                                      _showBottomSheet(driver[index]);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 17,
                                            backgroundImage: NetworkImage(
                                                'https://c7.alamy.com/comp/R4T599/box-delivery-truck-icon-isometric-of-box-delivery-truck-vector-icon-for-on-transparent-background-R4T599.jpg'),
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
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('รถคันที่ ${driver[index].No?.toString() ?? ' - '}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                                        Text('${driver[index].name?.toString() ?? ' - '}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                                      ],
                                                    ),
                                                    Text(driver[index].phone ?? ' - ', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  _showBottomSheet(DriverCar driver) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // พื้นหลังเป็นสีใส
      builder: (context) {
        return BottonSheetMapDriver(
          driver: driver,
        );
      },
    );
  }
}
