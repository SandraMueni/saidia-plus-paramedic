import 'package:paramedic_app/AllScreens/loginScreen.dart';
import 'package:paramedic_app/configMaps.dart';
import 'package:paramedic_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class ProfileTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              paramedicsInformation.paramedicName,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins-Regular',
              ),
            ),

            Text(
              title + " paramedic",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueGrey[200],
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins-Regular'
              ),
            ),

            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              ),
            ),

            SizedBox(height: 40.0,),

            InfoCard(
              text: paramedicsInformation.paramedicContact,
              icon: Icons.phone,
              onPressed: () async {
                print("this is phone.");
              },
            ),

            InfoCard(
              text: paramedicsInformation.paramedicEmail,
              icon: Icons.email,
              onPressed: () async {
                print("this is email.");
              },
            ),

            InfoCard(
              text: paramedicsInformation.ambulanceName + " - " + paramedicsInformation.ambulanceNumber,
              icon: Icons.car_repair,
              onPressed: () async {
                print("this is ambulance info.");
              },
            ),

            GestureDetector(
              onTap: ()
              {
                Geofire.removeLocation(currentfirebaseUser.uid);
                emergencyRequestRef.onDisconnect();
                emergencyRequestRef.remove();
                emergencyRequestRef = null;

                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
              },
              child: Card(
                color: Colors.red,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 110.0),
                child: ListTile(
                  trailing: Icon(
                    Icons.follow_the_signs_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Sign out",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'Poppins-Bold',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget
{
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({this.text, this.icon, this.onPressed,});

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black87,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
              fontFamily: 'Poppins-Bold',
            ),
          ),
        ),
      ),
    );
  }
}

