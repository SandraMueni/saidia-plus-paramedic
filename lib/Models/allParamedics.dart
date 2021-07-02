import 'package:firebase_database/firebase_database.dart';

class Paramedics
{
  String paramedic_id;
  String paramedic_contact;
  String paramedic_email;
  String paramedic_name;


  Paramedics({this.paramedic_id, this.paramedic_contact, this.paramedic_email, this.paramedic_name});

  Paramedics.fromSnapshot(DataSnapshot dataSnapshot)
  {
    paramedic_id = dataSnapshot.key;
    paramedic_contact = dataSnapshot.value["paramedic_contact"];
    paramedic_email = dataSnapshot.value["paramedic_email"];
    paramedic_name = dataSnapshot.value["paramedic_name"];
  }
}

