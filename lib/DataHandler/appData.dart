import 'package:flutter/cupertino.dart';
import 'package:paramedic_app/Models/address.dart';

class AppData extends ChangeNotifier
{
  Address pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAddress)
  {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress)
  {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}