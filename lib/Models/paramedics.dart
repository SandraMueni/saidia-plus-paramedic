import 'package:firebase_database/firebase_database.dart';

class Paramedic
{
  String paramedicName;
  String paramedicContact;
  String paramedicEmail;
  String paramedicId;
  String ambulanceName;
  String ambulanceNumber;
  String ambulanceType;

  Paramedic({this.paramedicName, this.paramedicContact, this.paramedicEmail, this.paramedicId, this.ambulanceName, this.ambulanceNumber, this.ambulanceType,});

  Paramedic.fromSnapshot(DataSnapshot dataSnapshot)
  {
    paramedicId = dataSnapshot.key;
    paramedicContact = dataSnapshot.value["paramedic_contact"];
    paramedicEmail = dataSnapshot.value["paramedic_email"];
    paramedicName = dataSnapshot.value["paramedic_name"];
    ambulanceName = dataSnapshot.value["ambulance_details"]["ambulance_name"];
    ambulanceNumber = dataSnapshot.value["ambulance_details"]["ambulance_number"];
    ambulanceType = dataSnapshot.value["ambulance_details"]["ambulance_type"];
  }
}