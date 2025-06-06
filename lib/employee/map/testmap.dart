import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ksice/employee/map/widget/bottomSheetMap.dart';
import 'package:ksice/model/routePoints.dart';
import 'package:ksice/model/user.dart';
import 'package:latlong2/latlong.dart';

class FlutterMapWithLabels extends StatefulWidget {
  const FlutterMapWithLabels({super.key, required this.user, required this.lat, required this.long});
  final User user;
  final double lat, long;

  @override
  State<FlutterMapWithLabels> createState() => _FlutterMapWithLabelsState();
}

class _FlutterMapWithLabelsState extends State<FlutterMapWithLabels> {
  // final List<Map<String, dynamic>> locations = [
  //   {'title': '🍔 สาขา 1', 'lat': 13.6495, 'lng': 100.5994},
  //   {'title': '🍔 สาขา 2', 'lat': 13.6500, 'lng': 100.6020},
  //   {'title': '🍔 สาขา 5', 'lat': 13.6435, 'lng': 100.6045},
  //   {'title': '🍔 สาขา 6', 'lat': 13.6480, 'lng': 100.6155},
  //   {'title': '🍔 สาขา 7', 'lat': 13.6700, 'lng': 100.6220},
  //   {'title': '🍔 สาขา 8', 'lat': 13.6725, 'lng': 100.6150},
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Map')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(widget.lat, widget.long),
          initialZoom: 13.5,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(markers: [
            Marker(
              width: 120,
              height: 50,
              point: LatLng(widget.lat, widget.long),
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/marker.png',
                      scale: 1,
                    )
                  ],
                ),
              ),
            ),
          ]),
          MarkerLayer(
            markers: widget.user.trucks![0].routes![1].route_points!.map((loc) {
              return Marker(
                width: 120,
                height: 50,
                point: LatLng(double.parse(loc.latitude ?? '0.0'), double.parse(loc.longitude ?? '0.0')),
                child: GestureDetector(
                  onTap: () {
                    double distanceInMeters = Geolocator.distanceBetween(
                      widget.lat,
                      widget.long,
                      double.parse(loc.latitude!),
                      double.parse(loc.longitude!),
                    );
                    print('ห่างกันกี่เมตร $distanceInMeters');
                    // getPolyPoints(
                    //   double.parse(item.latitude!),
                    //   double.parse(item.longitude!),
                    // );
                    _showBottomSheet(context, distanceInMeters, loc, widget.lat, widget.long);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [BoxShadow(blurRadius: 3)],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 8,
                              backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 100,
                              child: Text(
                                loc.member_branch?.name ?? ' - ',
                                style: TextStyle(fontSize: 10, color: Colors.black),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.location_pin, color: Colors.green, size: 32),
                    ],
                  ),
                ),
              );
            }).toList(),
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
}
