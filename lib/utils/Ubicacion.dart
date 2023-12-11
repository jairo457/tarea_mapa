import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:io' show Platform;

class Ubicacion {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  //late LocationSettings locationSettings;
//late LocationSettings locationSettings;

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Stream<Position> Getposition() {
    return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    ));
  }

  Future<Position> GetCurrentposition() {
    return Geolocator.getCurrentPosition();
  }

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      return false;
    } else {
      return true;
    }
  }
}
