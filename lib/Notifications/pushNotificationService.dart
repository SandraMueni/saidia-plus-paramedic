import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paramedic_app/Models/tripDetails.dart';
import 'package:paramedic_app/configMaps.dart';
import 'package:paramedic_app/main.dart';

import 'NotificationDialog.dart';

class PushNotificationService
{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future initialize(context) async
  {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        retrieveTripRequestInfo(getTripRequestId(message), context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        retrieveTripRequestInfo(getTripRequestId(message), context);
      },
      onResume: (Map<String, dynamic> message) async {
        retrieveTripRequestInfo(getTripRequestId(message), context);
      },
    );
  }


  Future<String> getToken() async
  {
    String token = await firebaseMessaging.getToken();
    print("This is Token :: ");
    print(token);
    paramedicsRef.child(currentfirebaseUser.uid).child("emergency_token").set(token);

    firebaseMessaging.subscribeToTopic("allparamedics");
    firebaseMessaging.subscribeToTopic("allvictims");
  }

  String getTripRequestId(Map<String, dynamic> message)
  {
    String tripRequestId = '';
    if(Platform.isAndroid)
    {
      tripRequestId = message['data']['victim_request_id'];
    }
    else
    {
      tripRequestId = message['victim_request_id'];
    }

    return tripRequestId;
  }

  void retrieveTripRequestInfo(String tripRequestId, BuildContext context)
  {
    newRequestRef.child(tripRequestId).once().then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
       assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
       assetsAudioPlayer.play();

        double pickUpLocationLat = double.parse(dataSnapshot.value['pickup_coordinates']['latitude'].toString());
        double pickUpLocationLng = double.parse(dataSnapshot.value['pickup_coordinates']['longitude'].toString());
        String pickUpAddress= dataSnapshot.value['pickup_address'].toString();

        double dropOffLocationLat = double.parse(dataSnapshot.value['dropoff_coordinates']['latitude'].toString());
        double dropOffLocationLng = double.parse(dataSnapshot.value['dropoff_coordinates']['longitude'].toString());
        String dropOffAddress= dataSnapshot.value['dropoff_address'].toString();

        String paymentMethod = dataSnapshot.value['payment_method'].toString();

        String victim_name = dataSnapshot.value["victim_name"];
        String victim_contact = dataSnapshot.value["victim_contact"];

        TripDetails tripDetails = TripDetails();
        tripDetails.victim_request_id = tripRequestId;
        tripDetails.pickup_address = pickUpAddress;
        tripDetails.dropoff_address = dropOffAddress;
        tripDetails.pickup_coordinates = LatLng(pickUpLocationLat,pickUpLocationLng);
        tripDetails.dropoff_coordinates = LatLng(dropOffLocationLat, dropOffLocationLng);
        tripDetails.payment_method = paymentMethod;
        tripDetails.victim_name = victim_name;
        tripDetails.victim_contact = victim_contact;

        print("Information :: ");
        print(tripDetails.pickup_address);
        print(tripDetails.dropoff_address);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => NotificationDialog(tripDetails: tripDetails,),
        );
      }
    });
  }
}