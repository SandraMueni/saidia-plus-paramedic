import 'package:flutter/material.dart';
import 'package:paramedic_app/configMaps.dart';
import 'package:paramedic_app/main.dart';
import 'mainscreen.dart';
import 'package:paramedic_app/AllScreens/registrationScreen.dart';

class AmbulanceInfoScreen extends StatelessWidget
{
  static const String idScreen = "ambulanceinfo";
  TextEditingController ambulanceNameTextEditingController = TextEditingController();
  TextEditingController ambulanceNumberTextEditingController = TextEditingController();
  TextEditingController ambulanceTypeTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 22.0,),
              Image.asset("images/ambulance.png", width: 300.0, height: 250.0,),
              Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0,),
                    Text("Enter Ambulance Details", style: TextStyle(fontFamily: "Poppins-Bold", fontSize: 24.0),),

                    SizedBox(height: 26.0,),
                    TextField(
                      controller: ambulanceNameTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Ambulance Name",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),

                    SizedBox(height: 10.0,),
                    TextField(
                      controller: ambulanceNumberTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Ambulance Number",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),

                    SizedBox(height: 10.0,),
                    TextField(
                      controller: ambulanceTypeTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Ambulance Type",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),

                    SizedBox(height: 42.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: ()
                        {
                          if(ambulanceNameTextEditingController.text.isEmpty)
                          {
                            displayToastMessage("Please provide Ambulance name ", context);
                          }
                          else if(ambulanceNumberTextEditingController.text.isEmpty)
                          {
                            displayToastMessage("Please provide Ambulance registration number ", context);
                          }
                          else if(ambulanceTypeTextEditingController.text.isEmpty)
                          {
                            displayToastMessage("Please provide Ambulance registration type ", context);
                          }
                          else
                          {
                            saveParamedicAmbulanceInfo(context);
                          }
                        },
                        color: Theme.of(context).accentColor,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("NEXT", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 26.0,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveParamedicAmbulanceInfo(context)
  {
    String paramedicId = currentfirebaseUser.uid;

    Map ambulanceInfoMap =
    {
      "ambulance_name": ambulanceNameTextEditingController.text,
      "ambulance_number": ambulanceNumberTextEditingController.text,
      "ambulance_type": ambulanceTypeTextEditingController.text,
    };

    paramedicsRef.child(paramedicId).child("ambulance_details").set(ambulanceInfoMap);

    Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
  }

}
