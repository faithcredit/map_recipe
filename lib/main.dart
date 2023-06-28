import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyMap(),
    );
  }
}

class MyMap extends StatefulWidget {
  const MyMap({super.key});
  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late Future<LatLng> _userLocationFuture;
  late LatLng userPosition;

  @override
  void initState() {
    // TODO: implement initState
    _userLocationFuture = findUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: FutureBuilder(
        future: _userLocationFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: snapshot.data, zoom: 12),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<LatLng> findUserLocation() async {
    Location location = Location();
    LocationData userLocation;
    PermissionStatus hasPermission = await location.hasPermission();
    bool active = await location.serviceEnabled();
    if (hasPermission == PermissionStatus.granted && active) {
      userLocation = await location.getLocation();
      userPosition = LatLng(userLocation.latitude!, userLocation.longitude!);
    } else {
      userPosition = const LatLng(51.5285582, -0.24167);
    }
    return userPosition;
  }
}
