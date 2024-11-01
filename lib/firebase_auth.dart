import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_connections/singleton_firestore.dart';
import 'session_details.dart';
import 'firebase_connections/singleton_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'building_details.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = AuthenticationService().firebaseAuth;
  final FirebaseFirestore _firestore = FirestoreService().firestore;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loadBuildingFloorNames(institutionID) async {

    try {
      List<String> buildings = [];
      List<String> floors = [];

      QuerySnapshot institutionSnapshot = await FirestoreService().firestore
          .collection('institution_buildings')
          .where('institution_id',isEqualTo: institutionID)
          .get();

      for(QueryDocumentSnapshot doc in institutionSnapshot.docs)
      {
        String institutionDocName = doc.id;
        //print("docname : " + institutionDocName);

        QuerySnapshot buildingSnapshot = await FirestoreService().firestore
          .collection('institution_buildings')
          .doc(institutionDocName)
          .collection('buildings')
          .get();

        for(QueryDocumentSnapshot doc in buildingSnapshot.docs)
        {
            String buildingDocName = doc.id;
            Map <String,dynamic> building = doc.data() as Map<String,dynamic>;
            //print('building_name : ' + building['building_name']);
            buildings.add(building['building_name']);

            QuerySnapshot floors_snapshot = await FirestoreService().firestore
              .collection('institution_buildings')
              .doc(institutionDocName)
              .collection('buildings')
              .doc(buildingDocName)
              .collection('floors')
              .get();

            for(QueryDocumentSnapshot doc in floors_snapshot.docs)
            {
              Map <String,dynamic> floor = doc.data() as Map<String,dynamic>;
              //print('floor_name : ' + floor['floor_name']);
              floors.add(floor['floor_name']);
            }
        }
      }

      BuildingDetails.buildings = buildings;
      BuildingDetails.floors = floors;

    } catch (error) {

      print('Error fetching data: $error');
    }
  }

  // Sign up
  Future<void> signUp() async {
    String email = SessionDetails.email;
    print("Email: ");
    print(email);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text
      );
      SessionDetails.email = _emailController.text;
      SessionDetails.password = _passwordController.text;
      
      /*
      await _firestore.collection('institution_members')
                .doc(_auth.currentUser?.uid)
                .set({"email":SessionDetails.email,"password":SessionDetails.password});
      */
      
      print(_auth.currentUser);
      print('User signed up');
    } catch (e) {
      print('Failed to sign up: $e');
    }
  }

  // Sign in
  Future<void> signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print(_auth.currentUser?.uid);

      String currentUserID = _auth.currentUser!.uid;
      print(currentUserID);
      
      QuerySnapshot snapshot1 = await FirestoreService().firestore.collection("institution_members")
                                        .where("id",isEqualTo: currentUserID)
                                        .limit(1)
                                        .get();

      for(QueryDocumentSnapshot doc in snapshot1.docs)
      {
        Map<String, dynamic> member = doc.data() as Map<String,dynamic>;
        SessionDetails.email = member['email_id'];
        SessionDetails.id = _auth.currentUser!.uid;
        SessionDetails.institution_id = member['institution_id'];
        SessionDetails.name = member['name'];
      }
      
      print('before loading');
      await loadBuildingFloorNames(SessionDetails.institution_id);
      print('User signed in');
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    print('User signed out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Auth Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUp,
              child: Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: signIn,
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: signOut,
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
