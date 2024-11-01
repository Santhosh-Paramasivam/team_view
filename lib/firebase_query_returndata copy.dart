import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_connections/singleton_firestore.dart';
import 'dart:convert';
import 'building_details.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class ReturnShowData extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<ReturnShowData> {
  late Timer _timer;
  
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    fetchUsersData(1); // Fetch data when the widget initializes
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {print("Rebuilt");}); // This will trigger a rebuild
    });
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

  Stream<QuerySnapshot> eventStream() {
    return FirestoreService()
        .firestore
        .collection("events")
        .where("institution_id", isEqualTo: 1)
        .snapshots();
  }

  Widget buildEventList(BuildContext context, List<Map<String,dynamic>> eventDetails)
  {
    List<Widget> eventText = [];

    print("\n\n");
    for(Map<String,dynamic> event in eventDetails)
    {
      //var ist = tz.getLocation('Asia/Kolkata');
      //var now = tz.TZDateTime.now(ist);

      print(event['start_time'].toDate());
      print(DateTime.now());
      print(event['end_time'].toDate());

      print((event['start_time'].toDate().compareTo(DateTime.now())));
      print((event['end_time'].toDate().compareTo(DateTime.now())));
      eventText.add(Text(event['name']));
      if(event['start_time'].toDate().compareTo(DateTime.now()) == -1 && 
         event['end_time'].toDate().compareTo(DateTime.now()) == 1 
        )
      {
        eventText.add(Text(event['start_time'].toDate().toString()));
      }
      //if(event['time'])
    }

    return Column(children: eventText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: StreamBuilder(
        stream: eventStream(), 
        builder: (context, snapshot) {
                if (snapshot.hasError) {
                      return Container(
                    width: double.infinity,
                    height: 100,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Text("Error fetching data"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                width: double.infinity,
                height: 100,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Center(child: CircularProgressIndicator()));
                }

                var doc = snapshot.data!.docs.first;
                //Map<String, dynamic> personDetails = doc.data() as Map<String, dynamic>;
                List<Map<String,dynamic>> eventDetails = [];

                for(QueryDocumentSnapshot doc in snapshot.data!.docs)
                {
                  eventDetails.add(doc.data() as Map<String, dynamic>);
                }

                return buildEventList(context, eventDetails);
            }
        )
    );
  }
}
