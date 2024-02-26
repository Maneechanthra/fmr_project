import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceMarkerEditPage extends StatefulWidget {
  final LatLng initialPosition;

  const PlaceMarkerEditPage({Key? key, required this.initialPosition})
      : super(key: key);

  @override
  _PlaceMarkerEditPageState createState() => _PlaceMarkerEditPageState();
}

class _PlaceMarkerEditPageState extends State<PlaceMarkerEditPage> {
  late LatLng _selectedPosition;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Marker'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition,
              zoom: 15,
            ),
            onTap: (LatLng latLng) {
              setState(() {
                _selectedPosition = latLng;
              });
            },
            markers: {
              Marker(
                markerId: MarkerId('selectedPosition'),
                position: _selectedPosition,
                draggable: true,
                onDragEnd: (LatLng latLng) {
                  setState(() {
                    _selectedPosition = latLng;
                  });
                },
              ),
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                _showAddressDialog(context);
              },
              child: Text('บันทึกที่อยู่'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddressDialog(BuildContext context) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(
      _selectedPosition.latitude,
      _selectedPosition.longitude,
    );

    // Extract address components from placemarks
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark placemark = placemarks[0];
      final String address =
          "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";

      Navigator.pop(context, address);
    } else {
      // Handle error case when no address is found
      Navigator.pop(context, 'Address not found');
    }
  }
}
