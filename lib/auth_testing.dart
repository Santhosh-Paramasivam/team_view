import 'package:flutter/material.dart';
import 'singleton_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'session_details.dart';

class AuthDetails extends StatelessWidget
{
  FirebaseAuth _firebaseAuth = AuthenticationService().firebaseAuth;

  Widget build(BuildContext buildContext)
  {
    return Scaffold
    (
      appBar: AppBar(title: Text("AuthDetails")),
      body: 
      Column(children: [
        Text(_firebaseAuth.currentUser.toString()),
        Text("\nSession ID : " + SessionDetails.id + "\nEmail : " + SessionDetails.email + "\ninstitution_id : " + SessionDetails.institution_id.toString()) 
        ]
      )
    );
  }
}