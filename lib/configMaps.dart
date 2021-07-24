import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'Models/allParamedics.dart';
import 'Models/paramedics.dart';

String mapKey = "AIzaSyCQST2iIBCjl5_n8-qQMLkwnOkHzBIhBrY";

//Global Variables

User firebaseUser;

Paramedics paramedicCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;

final assetsAudioPlayer = AssetsAudioPlayer();

Position currentPosition;

Paramedic paramedicsInformation;

StreamSubscription<Position> tripStreamSubscription;

String tripType="";

String title = "";

