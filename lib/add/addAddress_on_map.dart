import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceMarkerPage extends StatefulWidget {
  const PlaceMarkerPage({Key? key}) : super(key: key);

  @override
  _PlaceMarkerPageState createState() => _PlaceMarkerPageState();
}

class _PlaceMarkerPageState extends State<PlaceMarkerPage> {
  // late LatLng _latLng = LatLng(17.2667199760001, 104.134101002072);
  late LatLng _selectedPosition = LatLng(17.2667199760001, 104.134101002072);

  @override
  void initState() {
    super.initState();
    // _selectedPosition = _latLng;
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
              target: _selectedPosition,
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

    if (placemarks.isNotEmpty) {
      final Placemark placemark = placemarks[0];
      final String address =
          "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ที่อยู่'),
            content: SingleChildScrollView(
              child: Text(
                address,
                style: TextStyle(fontSize: 16),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    "address": address,
                    "latLng": _selectedPosition,
                  });
                },
                child: Text('บันทึก'),
              ),
            ],
          );
        },
      ).then((result) {
        if (result != null) {
          Navigator.of(context).pop(result);
        }
      });
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Address not found'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }
}
