import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paramedic_app/AllScreens/registrationScreen.dart';
import '../configMaps.dart';
import '../main.dart';

class HomeTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController newGoogleMapController;

  Position currentPosition;

  var geoLocator = Geolocator();

  String paramedicStatusText = "Offline Now - Go Online ";

  Color paramedicStatusColor = Colors.black;

  bool isParamedicAvailable = false;

  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),


        //Online Offline driver Container
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),
        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: ()
                  {
                    if(isParamedicAvailable != true)
                    {
                      makeParamedicOnlineNow();
                      getLocationLiveUpdates();

                      setState(() {
                        paramedicStatusColor = Colors.green;
                        paramedicStatusText = "Online Now ";
                        isParamedicAvailable = true;
                      });

                      displayToastMessage("You're Online", context);
                    }
                    else
                    {
                      makeParamedicOfflineNow();
                      setState(() {
                        paramedicStatusColor = Colors.black;
                        paramedicStatusText = "Offline Now - Go Online ";
                        isParamedicAvailable = false;
                      });
                      displayToastMessage("You're Offline", context);
                    }
                  },
                  color: paramedicStatusColor,
                  child: Padding(
                    padding: EdgeInsets.all(17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(paramedicStatusText, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                        Icon(Icons.phone_android, color: Colors.white, size: 26.0,),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void makeParamedicOnlineNow() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("Available_Paramedics");
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    emergencyRequestRef.onValue.listen((event) { });
  }

  void getLocationLiveUpdates()
  {
    homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((Position position)
    {
      currentPosition = position;
      if(isParamedicAvailable == true)
      {
        Geofire.setLocation(currentfirebaseUser.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeParamedicOfflineNow()
  {
    Geofire.removeLocation(currentfirebaseUser.uid);
    emergencyRequestRef.onDisconnect();
    emergencyRequestRef.remove();
    emergencyRequestRef = null;
  }
}