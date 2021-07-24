import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:paramedic_app/AllScreens/newTripScreen.dart';
import 'package:paramedic_app/AllScreens/registrationScreen.dart';
import 'package:paramedic_app/Assistants/assistantMethods.dart';
import 'package:paramedic_app/Models/tripDetails.dart';

import '../configMaps.dart';
import '../main.dart';

class NotificationDialog extends StatelessWidget
{
  final TripDetails tripDetails;

  NotificationDialog({this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.0),
            Image.asset("images/ambulance.png", width:120.0),
            SizedBox(height: 15.0,),
            Text("New Emergency Request", style: TextStyle(fontFamily: "Poppins-Bold", fontSize: 18.0,),),
            SizedBox(height: 30.0,),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/pickicon.png", height: 16.0, width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(
                        child:Container(child: Text(tripDetails.pickupAddress, style: TextStyle(fontSize: 18.0),)),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/desticon.png", height: 16.0, width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(
                          child: Container(child: Text(tripDetails.dropoffAddress, style: TextStyle(fontSize: 18.0),))
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Divider(height: 2.0, color: Colors.black, thickness: 2.0,),
            SizedBox(height: 8.0,),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    color: Colors.white,
                    textColor: Colors.red,
                    padding: EdgeInsets.all(8.0),
                    onPressed: ()
                    {
                      assetsAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                  SizedBox(width: 25.0,),

                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: ()
                    {
                      assetsAudioPlayer.stop();
                      checkAvailabilityOfEmergency(context);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text("Accept".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }


  void checkAvailabilityOfEmergency(context)
  {
    emergencyRequestRef.once().then((DataSnapshot dataSnapShot) {
      Navigator.pop(context);
      String theEmergencyId = "";
      if(dataSnapShot.value != null)
      {
        theEmergencyId = dataSnapShot.value.toString();
      }
      else
      {
        displayToastMessage("Emergency does not exist", context);
      }


      if(theEmergencyId == tripDetails.victimRequestId)
      {
        emergencyRequestRef.set("accepted");
        AssistantMethods.disableHomeTabLiveLocationUpdates();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> NewTripScreen(tripDetails: tripDetails)));
      }
      else if(theEmergencyId == "cancelled")
      {
        displayToastMessage("Emergency has been cancelled", context);
      }
      else if(theEmergencyId == "timeout")
      {
        displayToastMessage("Emergency has timed out", context);
      }
      else
      {
        displayToastMessage("Emergency does not exist", context);
      }
    });
  }
}
