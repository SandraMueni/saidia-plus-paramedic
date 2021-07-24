import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails
{
  String pickupAddress;
  String dropoffAddress;
  LatLng pickupCoordinates;
  LatLng dropoffCoordinates;
  String victimRequestId;
  String paymentMethod;
  String victimName;
  String victimContact;

  TripDetails({this.pickupAddress, this.dropoffAddress, this.pickupCoordinates, this.dropoffCoordinates, this.victimRequestId, this.paymentMethod, this.victimName, this.victimContact});

}