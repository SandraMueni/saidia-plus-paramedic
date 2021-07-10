import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails
{
  String pickup_address;
  String dropoff_address;
  LatLng pickup_coordinates;
  LatLng dropoff_coordinates;
  String victim_request_id;
  String payment_method;
  String victim_name;
  String victim_contact;

  TripDetails({this.pickup_address, this.dropoff_address, this.pickup_coordinates, this.dropoff_coordinates, this.victim_request_id, this.payment_method, this.victim_name, this.victim_contact});

}