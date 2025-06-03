import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double? lat;
  double? long;
  bool load = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getLocation();
    });
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
          lat = position.latitude;
          long = position.longitude;
          load = true;
        });
      }
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
          lat == null && long == null
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: size.height * 0.721,
                  child: Center(
                    child: Text('กรุณาเปิดตำแหน่ง'),
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: size.height * 0.721,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lat!, long!), // ตำแหน่งเริ่มต้นของกล้อง
                      zoom: 17, // การซูมเริ่มต้น
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('Marker1'),
                        position: LatLng(lat!, long!),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                        infoWindow: InfoWindow(
                          title: 'ร้านที่ 1',
                          // snippet: 'กรุงเทพมหานคร',
                        ),
                      ),
                      Marker(
                        markerId: MarkerId('Marker2'),
                        position: LatLng(13.7222, 100.7797),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        infoWindow: InfoWindow(
                          title: 'ร้านที่ 2',
                          // snippet: 'กรุงเทพมหานคร',
                        ),
                      ),
                      Marker(
                        markerId: MarkerId('Marker3'),
                        position: LatLng(13.7226, 100.7792),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                        infoWindow: InfoWindow(
                          title: 'ร้านที่ 3',
                          // snippet: 'กรุงเทพมหานคร',
                        ),
                      ),
                      Marker(
                        markerId: MarkerId('Marker4'),
                        position: LatLng(13.7215, 100.7790),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                        infoWindow: InfoWindow(
                          title: 'ร้านที่ 4',
                          // snippet: 'กรุงเทพมหานคร',
                        ),
                      ),
                      Marker(
                        markerId: MarkerId('Marker5'),
                        position: LatLng(13.7230, 100.7805),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        infoWindow: InfoWindow(
                          title: 'ร้านที่ 5',
                          // snippet: 'กรุงเทพมหานคร',
                        ),
                        onTap: () {},
                      ),
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
