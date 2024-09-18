import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'single_firestore.dart';

class MemberAutoUpdate extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<MemberAutoUpdate> {
  late String personName;
  late String selectedName;

  @override
  void initState() {
    super.initState();
    // Initially set the name to fetch for
    selectedName = "Bharath Kumar. N";
  }

  Stream<QuerySnapshot> fetchUsersStream(String name) {
    return FirestoreService()
        .firestore
        .collection("institution_members")
        .where("name", isEqualTo: name)
        .where("institution_id", isEqualTo: 1)
        .limit(1)
        .snapshots();
  }

  void changePersonName(String newName) {
    setState(() {
      selectedName = newName; // Update the name and trigger a new query
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fetchUsersStream(selectedName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text("Error fetching data");
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text("No user found");
                }

                var doc = snapshot.data!.docs.first;
                personName = doc['username'];
                print(personName);

                return Text(personName);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Change the name to a different person, e.g., "John Doe"
              changePersonName("Santhosh Paramasivam");
            },
            child: Text("Change Name"),
          )
        ],
      ),
    );
  }
}
