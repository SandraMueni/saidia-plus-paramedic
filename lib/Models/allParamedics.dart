import 'package:firebase_database/firebase_database.dart';

class Paramedics
{
  String paramedicId;
  String paramedicContact;
  String paramedicEmail;
  String paramedicName;
  bool isVerified = false;


  Paramedics({this.paramedicId, this.paramedicContact, this.paramedicEmail, this.paramedicName, this.isVerified});

  Paramedics.fromSnapshot(DataSnapshot dataSnapshot)
  {
    paramedicId = dataSnapshot.key;
    paramedicContact = dataSnapshot.value["paramedic_contact"];
    paramedicEmail = dataSnapshot.value["paramedic_email"];
    paramedicName = dataSnapshot.value["paramedic_name"];
    isVerified = dataSnapshot.value["is_verified"];
  }
}

