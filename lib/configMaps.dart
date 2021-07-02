import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'Models/allParamedics.dart';

String mapKey = "AIzaSyCQST2iIBCjl5_n8-qQMLkwnOkHzBIhBrY";

//Global Variables

User firebaseUser;

Paramedics paramedicCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;

final assetsAudioPlayer = AssetsAudioPlayer();

Position currentPosition;

Paramedics paramedicsInformation;

StreamSubscription<Position> rideStreamSubscription;

String rideType="";

