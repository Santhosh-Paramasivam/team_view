// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'draw_map_text.dart';
import 'members_search_bar.dart';
import 'firebase_connections/singleton_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'session_details.dart';

class Member
{
  String name;
  String rfidLocation;
  int institutionID;
  String id;
  late String floor;
  late String building;
  late String room;
  String role;
  String memberID;
  String status;

  Member(this.name, this.rfidLocation, this.institutionID, this.id, this.role, this.memberID, this.status)
  {
    List<String> rfidLocationList = rfidLocation.split("/");
    building = rfidLocationList[0];
    floor = rfidLocationList[1];
    room = rfidLocationList[2];
  }

  void changeRFIDLocation(String newRFIDLocation)
  {
    rfidLocation = newRFIDLocation;
    List<String> rfidLocationList = rfidLocation.split("/");
    building= rfidLocationList[0];
    floor = rfidLocationList[1];
    room = rfidLocationList[2];
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String name;
  Map<String, dynamic>? jsonData;

  late String selectedInputType;

  late bool doDisplayMemberDetails;
  late bool doDisplayMember;
  late Member memberForMemberDetails;
  late int appUserInstitutionID;

  final GlobalKey<MapDetailsDisplayWidgetState> _mapDetailsDisplayWidget = GlobalKey<MapDetailsDisplayWidgetState>();
  final GlobalKey<MemberSearchBarState> _memberSearchBar = GlobalKey<MemberSearchBarState>();

  Map<String,dynamic> prevPersonDetails = Map<String,dynamic>();

  @override
  initState()
  {
    super.initState();
    selectedInputType = "Person";
    memberForMemberDetails = Member("Default","SRMIST/GroundFloor/Room1",0,"","Default Role","Default ID","Default Status");
    doDisplayMemberDetails = true;
    appUserInstitutionID = 1;
    //name = "Santhosh Paramasivam";
    displayMemberNew(SessionDetails.name);
    displayMemberDetails(SessionDetails.name);
  }

  void displayMemberNew(String memberName) async{
    setState(() {
      name = memberName;
    } 
    );
    _mapDetailsDisplayWidget.currentState?.refreshName(name);
  }

  Stream<QuerySnapshot> fetchUsersStream() {
    return FirestoreService()
        .firestore
        .collection("institution_members")
        .where("name", isEqualTo: name)
        .where("institution_id", isEqualTo: appUserInstitutionID)
        .limit(1)
        .snapshots();
  }

  void displayMemberDetails(String memberName)
  {
    setState(() {
      name = memberName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MemberSearchBar(_memberSearchBar, displayMemberNew, displayMemberDetails),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(children: [
          StreamBuilder<QuerySnapshot>(
              stream: fetchUsersStream(),
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
                Map<String, dynamic> personDetails = doc.data() as Map<String, dynamic>;

                final eq = const DeepCollectionEquality().equals;

                if(!eq(personDetails, prevPersonDetails))
                {
                  print("Auto-update data reached");

                    doDisplayMemberDetails = true;
                    memberForMemberDetails.name = personDetails['name'];
                    memberForMemberDetails.id = personDetails['id'];
                    memberForMemberDetails.changeRFIDLocation(personDetails['rfid_location']);
                    memberForMemberDetails.institutionID = appUserInstitutionID;
                    memberForMemberDetails.role = personDetails['user_role'];
                    memberForMemberDetails.status = personDetails['status'];

                    if(memberForMemberDetails.role == "Professor")
                    {
                      memberForMemberDetails.memberID = personDetails['faculty_id'];
                    }
                    else if(memberForMemberDetails.role == "Student")
                    {
                      memberForMemberDetails.memberID = personDetails['register_id'];
                    }
                  prevPersonDetails = Map.from(personDetails);
                }
                return  
                Column(children: [
                          Row(children: [
                              const SizedBox(width: 10),
                              Padding(padding: const EdgeInsets.fromLTRB(10, 15, 10, 15), 
                              child:  Text("${memberForMemberDetails.building} / ${memberForMemberDetails.floor} / ${memberForMemberDetails.room}"),),
                              const Spacer(),
                            ],
                          ),
                          MapDetailsDisplayWidget(key: _mapDetailsDisplayWidget),
                          const SizedBox(
                              height: 15,
                          ),
                          MemberDetails(this.memberForMemberDetails),
                        ]);
                    },
                ),
        ],)      
           )
    );
  }
}

class MemberDetails extends StatelessWidget {
  final Member member;

  const MemberDetails(this.member, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 100,
      child: Column(
        children: [
          //Text("ID: " + member.id.toString()),
          if(member.name != "Default") Text("Name: ${member.name}"),
          if(member.name != "Default") Text("Role: ${member.role}"),
          if(member.role == "Professor") Text("Faculty ID: ${member.memberID}"),
          if(member.role == "Student") Text("Register Number: ${member.memberID}"),
          if(member.name != "Default") Text("Status: ${member.status}"),
          //if(member.name != "Default") Text("Location: ${member.building} / ${member.floor} / ${member.room}")
        ],
      ),
    );
  }
}
