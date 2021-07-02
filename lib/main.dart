import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:paramedic_app/AllScreens/ambulanceInfoScreen.dart';
import 'package:paramedic_app/AllScreens/loginScreen.dart';
import 'package:paramedic_app/AllScreens/mainscreen.dart';
import 'package:paramedic_app/AllScreens/registrationScreen.dart';
import 'package:paramedic_app/DataHandler/appData.dart';
import 'package:provider/provider.dart';

import 'configMaps.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  currentfirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

DatabaseReference victimsRef = FirebaseDatabase.instance.reference().child("Victims");
DatabaseReference paramedicsRef = FirebaseDatabase.instance.reference().child("Paramedics");
DatabaseReference emergencyRequestRef = FirebaseDatabase.instance.reference().child("Paramedics").child(currentfirebaseUser.uid).child("newEmergency");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Saidia Plus+ Paramedic App',
        theme: ThemeData(
          fontFamily: "Poppins-Regular",
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : MainScreen.idScreen,
        routes:
        {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          AmbulanceInfoScreen.idScreen: (context) => AmbulanceInfoScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

