import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_connections/singleton_firestore.dart';
import 'dart:convert';
import '../building_details.dart';

class ReturnShowData extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<ReturnShowData> {

  
  @override
  void initState() {
    super.initState();
    fetchUsersData(1); // Fetch data when the widget initializes
  }
  // Function to query Firestore and store data
  Future<void> fetchUsersData(institutionID) async {

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
        print("docname : " + institutionDocName);

        QuerySnapshot buildingSnapshot = await FirestoreService().firestore
          .collection('institution_buildings')
          .doc(institutionDocName)
          .collection('buildings')
          .get();

        for(QueryDocumentSnapshot doc in buildingSnapshot.docs)
        {
            String buildingDocName = doc.id;
            Map <String,dynamic> building = doc.data() as Map<String,dynamic>;
            print('building_name : ' + building['building_name']);
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
              print('floor_name : ' + floor['floor_name']);
              floors.add(floor['floor_name']);
            }
        }
      }

      BuildingDetails.buildings = buildings;
      BuildingDetails.floors = floors;

      setState((){});
    } catch (error) {

      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: Column(
                children: [
                  Text(BuildingDetails.buildings.toString()),
                  Text(BuildingDetails.floors.toString()),
                ],
              ) 
    );
  }
}
