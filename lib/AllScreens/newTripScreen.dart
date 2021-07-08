import 'package:flutter/material.dart';
import 'package:paramedic_app/Models/tripDetails.dart';

class NewTripScreen extends StatefulWidget
{
  final TripDetails tripDetails;
  NewTripScreen({this.tripDetails});

  @override
  _NewTripScreenState createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Emergency Trip"),
      ),
      body: Center(
        child: Text("This is a new Trip Page"),
      ),
    );
  }
}
