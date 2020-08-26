import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GooMap extends StatefulWidget {
  final LocationData location;
  GooMap({this.location});

  @override
  _GooMapState createState() => _GooMapState();
}

class _GooMapState extends State<GooMap> {
  LocationData _locationData;
  //Maps
  Set<Polygon> _polygons = HashSet<Polygon>();
  Set<Marker> _markers = HashSet<Marker>();

  List<LatLng> polygonsLatLngs = List<LatLng>();
  // [
  //   LatLng(29.96792816303663, 31.250047758221626),
  //   LatLng(29.96299559435919, 31.248374059796333),
  //   LatLng(29.96458820586188, 31.245419941842556),
  //   LatLng(29.968727482169697, 31.24674327671528),
  //   LatLng(29.97028253447261, 31.248452849686146)
  // ];
  // List<LatLng> polygonsLatLngs2 = [
  //   LatLng(29.9581757776271, 31.253162808716297),
  //   LatLng(29.959976736919433, 31.249775514006615),
  //   LatLng(29.96161180540993, 31.254088170826435)
  // ];

  int polygonCounter = 1;
  int markersCounter = 1;
  bool _isPolygon = true;
  bool _isMarker = false;

  @override
  void initState() {
    super.initState();
    _locationData = widget.location;
    // setPolgon2();
  }

  void setPolgon() {
    final String polygonIDVal = 'polygon_id $polygonCounter';
    _polygons.add(Polygon(
      polygonId: PolygonId(polygonIDVal),
      points: polygonsLatLngs,
      strokeWidth: 2,
      strokeColor: Colors.pink,
      fillColor: Colors.blue,
    ));
  }

  // void setPolgon2() {
  //   final String polygonIDVal = 'polygon_id $polygonCounter';
  //   _polygons.add(Polygon(
  //     polygonId: PolygonId(polygonIDVal),
  //     points: polygonsLatLngs2,
  //     strokeWidth: 2,
  //     strokeColor: Colors.pink,
  //     fillColor: Colors.blue,
  //   ));
  // }

  void setMarkers(LatLng point) {
    final String markerIDVal = 'Markers_id $markersCounter';
    markersCounter++;
    setState(() {
      print(
          'Marker | Latitude ${point.latitude} | Longitude ${point.longitude}');
      _markers.add(
        Marker(
          markerId: MarkerId(markerIDVal),
          position: point,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(_locationData.latitude, _locationData.longitude),
            zoom: 16,
          ),
          mapType: MapType.normal,
          polygons: _polygons,
          myLocationEnabled: true,
          onTap: (point) {
            if (_isPolygon) {
              polygonsLatLngs.add(point);
              setPolgon();
            } else if (_isMarker) {
              _markers.clear();
              setMarkers(point);
            }
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: <Widget>[
              RaisedButton(
                color: Colors.black54,
                child: Text(
                  'polygon',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onPressed: () {
                  _isPolygon = true;
                  _isMarker = false;
                },
              ),
              RaisedButton(
                color: Colors.black54,
                child: Text(
                  'Marker',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onPressed: () {
                  _isPolygon = false;
                  _isMarker = true;
                },
              )
            ],
          ),
        )
      ],
    ));
  }
}
