import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedMapPage extends StatefulWidget {
  const SelectedMapPage({super.key});

  @override
  State<SelectedMapPage> createState() => _SelectedMapPageState();
}

class _SelectedMapPageState extends State<SelectedMapPage> {
  late GoogleMapController mapController;
  LatLng selectedPosition = LatLng(13.7563, 100.5018); // เริ่มที่กรุงเทพ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🗺 Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedPosition,
              zoom: 14,
            ),
            onMapCreated: (controller) => mapController = controller,
            onTap: (LatLng position) {
              setState(() => selectedPosition = position);
            },
            markers: {
              Marker(
                markerId: MarkerId('selected'),
                position: selectedPosition,
              ),
            },
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
              decoration:  BoxDecoration(
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
