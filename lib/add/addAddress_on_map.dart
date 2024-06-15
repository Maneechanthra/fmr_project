import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceMarkerPage extends StatefulWidget {
  const PlaceMarkerPage({Key? key}) : super(key: key);

  @override
  _PlaceMarkerPageState createState() => _PlaceMarkerPageState();
}

class _PlaceMarkerPageState extends State<PlaceMarkerPage> {
  LatLng? _selectedPosition;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    try {
      Position userPosition = await getUserCurrentLocation();
      setState(() {
        _selectedPosition =
            LatLng(userPosition.latitude, userPosition.longitude);
      });
    } catch (e) {
      print("Error fetching user location: $e");
      setState(() {
        _selectedPosition = null;
      });
    }
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error " + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ระบุที่อยู่ร้านอาหารของคุณ',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: _selectedPosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedPosition!,
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    _mapController!
                        .animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: _selectedPosition!, zoom: 15),
                    ));
                  },
                  onTap: (LatLng latLng) {
                    setState(() {
                      _selectedPosition = latLng;
                    });
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId('selectedPosition'),
                      position: _selectedPosition!,
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
                  bottom: 30,
                  left: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      _showAddressDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "บันทึกที่อยู่",
                            style: GoogleFonts.prompt(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Future<void> _showAddressDialog(BuildContext context) async {
  //   if (_selectedPosition == null) return;

  //   final List<Placemark> placemarks = await placemarkFromCoordinates(
  //     _selectedPosition!.latitude,
  //     _selectedPosition!.longitude,
  //   );

  //   if (placemarks.isNotEmpty) {
  //     final Placemark placemark = placemarks[0];
  //     final String address =
  //         "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";

  //     await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('ที่อยู่'),
  //           content: SingleChildScrollView(
  //             child: Text(
  //               address,
  //               style: TextStyle(fontSize: 16),
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop({
  //                   "address": address,
  //                   "latLng": _selectedPosition,
  //                 });
  //               },
  //               child: Text('บันทึก'),
  //             ),
  //           ],
  //         );
  //       },
  //     ).then((result) {
  //       if (result != null) {
  //         Navigator.of(context).pop(result);
  //       }
  //     });
  //   } else {
  //     await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Error'),
  //           content: Text('Address not found'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('Close'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  Future<void> _showAddressDialog(BuildContext context) async {
    if (_selectedPosition == null) return;

    final List<Placemark> placemarks = await placemarkFromCoordinates(
      _selectedPosition!.latitude,
      _selectedPosition!.longitude,
    );

    if (placemarks.isNotEmpty) {
      final Placemark placemark = placemarks[0];
      final String address =
          "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ที่อยู่",
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        address,
                        style: GoogleFonts.prompt(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop({
                          "address": address,
                          "latLng": _selectedPosition,
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.04,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            'บันทึก',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Error',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Address not found',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
