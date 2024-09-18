import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'single_firestore.dart';
import 'dart:convert';

class ReturnPrintData extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<ReturnPrintData> {
  late Map <String,dynamic> institution;
  late Map <String,dynamic> building;
  late Map <String,dynamic> floor;
  late List<Offset> roomsOnFloor;
  bool isLoading = true;
  bool loadingError = false;
  late String institutionDocName;
  late String buildingDocName;
  late String error;
  late List<Offset> buildingBoundaries = [];
  late List<List<int>> building_boundaries = []; 

  @override
  void initState() {
    super.initState();
    fetchUsersData(); // Fetch data when the widget initializes
  }
  // Function to query Firestore and store data
  Future<void> fetchUsersData() async {
    try {
      QuerySnapshot snapshot = await FirestoreService().firestore
          .collection('institution_buildings')
          .where('institution_id', isEqualTo: 1)
          .limit(1)
          .get();

      if(snapshot.size == 0)
      {
        setState(()
        {
          error = 'institution not found';
          loadingError = true;
          isLoading = false;
        });
        return;
      }
      
      for(QueryDocumentSnapshot doc in snapshot.docs)
      {
        institutionDocName = doc.id;
        institution = doc.data() as Map<String,dynamic>;
      }

      QuerySnapshot snapshot1 = await FirestoreService().firestore
        .collection('institution_buildings')
        .doc(institutionDocName)
        .collection('buildings')
        .where("building_name", isEqualTo: "SRMIST")
        .limit(1)
        .get();

      if(snapshot1.size == 0)
      {
        setState(()
        {
          error = 'building not found';
          loadingError = true;
          isLoading = false;
        });
        return;
      }

      for(QueryDocumentSnapshot doc in snapshot1.docs)
      {
        buildingDocName = doc.id;
        building = doc.data() as Map<String,dynamic>;
      }

      building_boundaries = jsonDecode(building['building_boundaries'])
      .map<List<int>>((item) => List<int>.from(item))
      .toList();

      for(List<int> point in building_boundaries)
      {
        buildingBoundaries.add(Offset(point[0].toDouble(),point[1].toDouble()));
        //print(Offset(point[0].toDouble(),point[1].toDouble()));
      }

      QuerySnapshot snapshot2 = await FirestoreService().firestore
        .collection('institution_buildings')
        .doc(institutionDocName)
        .collection('buildings')
        .doc(buildingDocName)
        .collection('floors')
        .where('floor_name', isEqualTo: 'GroundFloor')
        .limit(1)
        .get();

      for(QueryDocumentSnapshot doc in snapshot2.docs)
      {
        //buildingDocName = doc.id;
        floor = doc.data() as Map<String,dynamic>;
        floor = json.decode(floor['rooms_on_floor']) as Map<String,dynamic>;
      }

      floor.forEach((key, value) {

          List<Offset> points = (value as List).map<Offset>((item) {
            double x = item[0].toDouble();
            double y = item[1].toDouble();
            return Offset(x, y);
          }).toList();

        });

      // Update UI when data is loaded
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      // Handle any errors that occur during the query
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: loadingError
            ? Text(error)
            : Column(
                children: [
                  Text(institutionDocName.toString()),
                  Text(institution.toString()),
                  Text(building.toString()),
                  Text(building_boundaries.toString()),
                  Text(floor.toString()),
                  //Text(roomsOnFloor.toString())
                  //Text(buildingBoundaries.toString())
                ],
              )
    );
  }
}
