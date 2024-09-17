import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'single_firestore.dart';

class ReturnPrintData extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<ReturnPrintData> {
  List<Map<String, dynamic>> usersList = []; // Store queried data here
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchUsersData(); // Fetch data when the widget initializes
  }

  // Function to query Firestore and store data
  Future<void> fetchUsersData() async {
    try {
      QuerySnapshot snapshot = await FirestoreService().firestore
          .collection('rfid_users')
          .where('user_id', isGreaterThan: 0)
          .get();

      // Process and store data in the class object
      usersList = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : usersList.isEmpty
              ? Center(child: Text('No users found.'))
              : ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: (context, index) {
                    var user = usersList[index];
                    return ListTile(
                      title: Text(user['user_id'].toString()),
                      subtitle: Text('Age: ${user['rfid_uid']}'),
                    );
                  },
                ),
    );
  }
}
