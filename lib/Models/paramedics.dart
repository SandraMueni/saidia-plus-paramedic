import 'package:firebase_database/firebase_database.dart';

class Paramedic
{
  String paramedic_name;
  String paramedic_contact;
  String paramedic_email;
  String paramedic_id;
  String ambulance_name;
  String ambulance_number;
  String ambulance_type;

  Paramedic({this.paramedic_name, this.paramedic_contact, this.paramedic_email, this.paramedic_id, this.ambulance_name, this.ambulance_number, this.ambulance_type,});

  Paramedic.fromSnapshot(DataSnapshot dataSnapshot)
  {
    paramedic_id = dataSnapshot.key;
    paramedic_contact = dataSnapshot.value["paramedic_contact"];
    paramedic_email = dataSnapshot.value["paramedic_email"];
    paramedic_name = dataSnapshot.value["paramedic_name"];
    ambulance_name = dataSnapshot.value["ambulance_details"]["ambulance_name"];
    ambulance_number = dataSnapshot.value["ambulance_details"]["ambulance_number"];
    ambulance_type = dataSnapshot.value["ambulance_details"]["ambulance_type"];
  }
}