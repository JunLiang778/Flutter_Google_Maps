import 'package:flutter/material.dart';
import 'dart:io';

class PlaceLocation{
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location; //location expressed as coordinates (long,lad)
  final File image; //image from device 

  Place({
    @required this.id,
    @required this.title,
    @required this.location,
    @required this.image,
  });
}