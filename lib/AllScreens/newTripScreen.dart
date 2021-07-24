import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paramedic_app/AllWidgets/CollectFareDialog.dart';
import 'package:paramedic_app/AllWidgets/progressDialog.dart';
import 'package:paramedic_app/Assistants/assistantMethods.dart';
import 'package:paramedic_app/Assistants/mapKitAssistant.dart';
import 'package:paramedic_app/Models/tripDetails.dart';
import 'package:paramedic_app/configMaps.dart';
import '../main.dart';

class NewTripScreen extends StatefulWidget
{
  final TripDetails tripDetails;
  NewTripScreen({this.tripDetails});

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,);

  @override
  _NewTripScreenState createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen>
{
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newTripGoogleMapController;

  Set<Marker> markersSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polyLineSet = Set<Polyline>();
  List<LatLng> polylineCoOrdinates = [];
  double mapPaddingFromBottom = 0;
  var geoLocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor animatingMarkerIcon;
  Position myPosition;
  String status = "accepted";
  String durationRide = "";
  bool isRequestingDirection = false;
  String btnTitle = "Arrived";
  Color btnColor = Colors.blueAccent;
  Timer timer;
  int durationCounter = 0;

  @override
  void initState() {
    super.initState();

    acceptEmergencyRequest();
  }

  void createIconMarker() {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/ambulance_top.png").then((value)
      {
        animatingMarkerIcon = value;
      });
    }
  }

  void getTripLiveLocationUpdates()
  {
    LatLng oldPos = LatLng(0, 0);

    tripStreamSubscription = Geolocator.getPositionStream().listen((Position position)
    {
          currentPosition = position;
          myPosition = position;
          LatLng mPostion = LatLng(position.latitude, position.longitude);

          var rot = MapKitAssistant.getMarkerRotation(oldPos.latitude, oldPos.longitude, myPosition.latitude, myPosition.latitude);

          Marker animatingMarker = Marker(
            markerId: MarkerId("animating"),
            position: mPostion,
            icon: animatingMarkerIcon,
            rotation: rot,
            infoWindow: InfoWindow(title: "Current Location"),
          );

          setState(() {
            CameraPosition cameraPosition = new CameraPosition(target: mPostion, zoom: 15);
            newTripGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

            markersSet.removeWhere((marker) => marker.markerId.value == "animating");
            markersSet.add(animatingMarker);
          });
          oldPos = mPostion;
          updateTripDetails();

          String tripRequestId = widget.tripDetails.victimRequestId;
          Map locMap =
          {
            "latitude": currentPosition.latitude.toString(),
            "longitude": currentPosition.longitude.toString(),
          };
          newRequestRef.child(tripRequestId).child("paramedic_location").set(locMap);
        });
  }

  @override
  Widget build(BuildContext context)
  {
    createIconMarker();

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: NewTripScreen._kGooglePlex,
            myLocationEnabled: true,
            markers: markersSet,
            circles: circleSet,
            polylines: polyLineSet,
            onMapCreated: (GoogleMapController controller) async
            {
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;

              setState(() {
                mapPaddingFromBottom = 265.0;
              });

              var currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
              var pickUpLatLng = widget.tripDetails.pickupCoordinates;

              await getPlaceDirection(currentLatLng, pickUpLatLng);

              getTripLiveLocationUpdates();
            },
          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,

            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(26.0)),
                boxShadow:
                [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: 300.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Column(
                  children: [

                    Text(
                      durationRide, style: TextStyle(fontSize: 14.0, fontFamily: "Poppins-Bold", color: Colors.deepPurple),
                    ),

                    SizedBox(height: 16.0,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.tripDetails.victimName, style: TextStyle(fontFamily: "Poppins-Bold", fontSize: 24.0),),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.phone_android),
                        ),
                      ],
                    ),

                    SizedBox(height: 26.0,),

                    Row(
                      children: [
                        Image.asset("images/pickicon.png", height: 16.0, width: 16.0,),
                        SizedBox(width: 18.0,),
                        Expanded(
                          child: Container(
                            child: Text(widget.tripDetails.pickupAddress, style: TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.0,),

                    Row(
                      children: [
                        Image.asset("images/desticon.png", height: 16.0, width: 16.0,),
                        SizedBox(width: 18.0,),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.tripDetails.dropoffAddress,
                              style: TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 26.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: () async
                        {
                          if(status == "accepted")
                          {
                            status = "arrived";
                            String tripRequestId = widget.tripDetails.victimRequestId;
                            newRequestRef.child(tripRequestId).child("status").set(status);

                            setState(() {
                              btnTitle = "Start Trip";
                              btnColor = Colors.purple;
                            });

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context)=> ProgressDialog(message: "Please wait...",),
                            );

                            await getPlaceDirection(widget.tripDetails.pickupCoordinates, widget.tripDetails.dropoffCoordinates);

                            Navigator.pop(context);
                          }
                          else if(status == "arrived")
                          {
                            status = "ontrip";
                            String tripRequestId = widget.tripDetails.victimRequestId;
                            newRequestRef.child(tripRequestId).child("status").set(status);

                            setState(() {
                              btnTitle = "End Trip";
                              btnColor = Colors.redAccent;
                            });

                            initTimer();
                          }
                          else if(status == "ontrip")
                          {
                            endTheTrip();
                          }
                        },
                        color: btnColor,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(btnTitle, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                              Icon(FontAwesomeIcons.ambulance, color: Colors.white, size: 26.0,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceDirection(LatLng pickUpLatLng, LatLng dropOffLatLng) async
  {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Please wait...",)
    );

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);

    print("This is Encoded Points ::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints
        .decodePolyline(details.encodedPoints);

    polylineCoOrdinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polylineCoOrdinates.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylineCoOrdinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    }
    else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    }
    else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newTripGoogleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.deepPurple,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });
  }

  void acceptEmergencyRequest()
  {
    String emergencyRequestId = widget.tripDetails.victimRequestId;
    newRequestRef.child(emergencyRequestId).child("status").set("accepted");
    newRequestRef.child(emergencyRequestId).child("paramedic_name").set(paramedicsInformation.paramedicName);
    newRequestRef.child(emergencyRequestId).child("paramedic_contact").set(paramedicsInformation.paramedicContact);
    newRequestRef.child(emergencyRequestId).child("paramedic_id").set(paramedicsInformation.paramedicId);
    newRequestRef.child(emergencyRequestId).child("ambulance_details").set('${paramedicsInformation.ambulanceName} - ${paramedicsInformation.ambulanceNumber}');

    Map locMap =
    {
      "latitude": currentPosition.latitude.toString(),
      "longitude": currentPosition.longitude.toString(),
    };
    newRequestRef.child(emergencyRequestId).child("paramedic_location").set(locMap);

    paramedicsRef.child(currentfirebaseUser.uid).child("history").child(emergencyRequestId).set(true);
  }

  void updateTripDetails() async
  {
    if(isRequestingDirection == false) {
      isRequestingDirection = true;

      if (myPosition == null) {
        return;
      }

      var posLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;

      if (status == "accepted") {
        destinationLatLng = widget.tripDetails.pickupCoordinates;
      }
      else {
        destinationLatLng = widget.tripDetails.dropoffCoordinates;
      }

      var directionDetails = await AssistantMethods.obtainPlaceDirectionDetails(
          posLatLng, destinationLatLng);
      if (directionDetails != null) {
        setState(() {
          durationRide = directionDetails.durationText;
        });
      }
      isRequestingDirection = false;
    }
  }

  void initTimer()
  {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer)
    {
      durationCounter = durationCounter + 1;
    });
  }

  endTheTrip() async
  {
    timer.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=> ProgressDialog(message: "Please wait...",),
    );

    var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);

    var directionalDetails = await AssistantMethods.obtainPlaceDirectionDetails(widget.tripDetails.pickupCoordinates, currentLatLng);

    Navigator.pop(context);

    int fareAmount = AssistantMethods.calculateFares(directionalDetails);

    String tripRequestId = widget.tripDetails.victimRequestId;
    newRequestRef.child(tripRequestId).child("charges").set(fareAmount.toString());
    newRequestRef.child(tripRequestId).child("status").set("ended");
    tripStreamSubscription.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=> CollectFareDialog(paymentMethod: widget.tripDetails.paymentMethod, fareAmount: fareAmount,),
    );

    saveEarnings(fareAmount);
  }

  void saveEarnings(int fareAmount)
  {
    paramedicsRef.child(currentfirebaseUser.uid).child("earnings").once().then((DataSnapshot dataSnapShot)
    {
      if(dataSnapShot.value != null)
      {
        double oldEarnings = double.parse(dataSnapShot.value.toString());
        double totalEarnings = fareAmount + oldEarnings;

        paramedicsRef.child(currentfirebaseUser.uid).child("earnings").set(totalEarnings.toStringAsFixed(2));
      }
      else
      {
        double totalEarnings = fareAmount.toDouble();
        paramedicsRef.child(currentfirebaseUser.uid).child("earnings").set(totalEarnings.toStringAsFixed(2));
      }
    });
  }
}
