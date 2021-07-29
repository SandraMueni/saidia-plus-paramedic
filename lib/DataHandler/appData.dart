import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:paramedic_app/Models/history.dart';
import '../configMaps.dart';
import '../main.dart';

class AppData extends ChangeNotifier
{
  String earnings = "0";
  int countTrips = 0;
  int tripCounter = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];

  String get allEarnings{
    return earnings;
  }

  int get allTrips{
    return tripCounter;
  }
  dynamic get history{
    return tripHistoryDataList;
  }

  Future<void> fetchAllHistory()async{
    //retrieve and display Earnings
    await paramedicsRef.child(currentfirebaseUser.uid).child("earnings").once().then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        earnings = dataSnapshot.value.toString();

      }
    });
    //retrieve and display Earnings
    await paramedicsRef.child(currentfirebaseUser.uid).child("history").once().then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        //update total number of trip counts to provider
        Map<dynamic, dynamic> keys = dataSnapshot.value;
        tripCounter = keys.length;

      }
    });
    notifyListeners();
  }


  void updateEarnings(String updatedEarnings)
  {
    earnings = updatedEarnings;
    notifyListeners();
  }

  void updateTripsCounter(int tripCounter)
  {
    countTrips = tripCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys)
  {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachHistory)
  {
    tripHistoryDataList.add(eachHistory);
    tripHistoryDataList.sort((a,b) => b.timeCreated.compareTo(a.timeCreated));
    notifyListeners();
  }
}