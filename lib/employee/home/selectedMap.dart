import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedMapPage extends StatefulWidget {
  const SelectedMapPage({super.key});

  @override
  State<SelectedMapPage> createState() => _SelectedMapPageState();
}

class _SelectedMapPageState extends State<SelectedMapPage> {
  late GoogleMapController mapController;
  LatLng? selectedPosition; // เริ่มที่กรุงเทพ

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

  Set<Marker> _getMarkers() {
    final markers = <Marker>{};

    if (selectedPosition != null) {
      markers.add(
        Marker(
          markerId: MarkerId('my_location'),
          position: selectedPosition!,
          draggable: true,
          // icon: _customIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'ตำแหน่งของฉัน'),
          onDragEnd: (LatLng newPosition) {
            print('ตำแหน่งใหม่: ${newPosition.latitude}, ${newPosition.longitude}');
            setState(() {
              selectedPosition = newPosition;
            });
          },
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // 🗺 Google Map
          selectedPosition == null
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: size.height * 0.721,
                  child: Center(
                    child: Text('กรุณาเปิดตำแหน่ง'),
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: selectedPosition!,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) => mapController = controller,
                  onTap: (LatLng position) {
                    setState(() => selectedPosition = position);
                  },

                  myLocationEnabled: false,
                  markers: _getMarkers(),
                  // markers: {
                  //   Marker(
                  //     draggable: true,
                  //     markerId: MarkerId('selected'),
                  //     position: selectedPosition!,
                  //     onDragEnd: (value) {
                  //       setState(() => selectedPosition = value);
                  //     },
                  //   ),
                  // },
                ),

          // 🔙 ปุ่มย้อนกลับ
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selectedPosition);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
