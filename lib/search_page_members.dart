// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'drop_down_box.dart';
import 'draw_map_text.dart';
import 'custom_datatypes/member.dart';
import 'members_search_bar.dart';
import 'single_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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

  @override
  initState()
  {
    super.initState();
    name = "Default";
    selectedInputType = "Person";
    memberForMemberDetails = Member("Default","SRMIST/GroundFloor/Room1",0,0,"Default Role","Default ID","Default Status");
    doDisplayMemberDetails = false;
    appUserInstitutionID = 1;
  }


  final List<DropdownMenuItem<String>> valuesInputType = [
    const DropdownMenuItem(value: 'Person', child: Text("Person")),
    const DropdownMenuItem(value: 'Room',child: Text("Room")),
    const DropdownMenuItem(value: 'Designation', child: Text("Designation")),
  ];

  void displayMemberNew(String memberName) async{
    setState(() {
      name = memberName;
    } 
    );
    await loadMemberDetails();
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
    loadMemberDetails();
  }

  Future<void> loadMemberDetails() async {

    String jsonString = await rootBundle.loadString('assets/members.json');
    setState(() {
      jsonData = json.decode(jsonString);

      var member = jsonData?["institution_members"]?.firstWhere(
        (member) => member['name'] == name && member['institution_id'] == appUserInstitutionID,
        orElse: () => null,
      );
      print(member);

      if (member != null) {
        doDisplayMemberDetails = true;
        memberForMemberDetails.name = member['name'];
        memberForMemberDetails.id = member['id'];
        memberForMemberDetails.changeRFIDLocation(member['manual_location']);
        memberForMemberDetails.institutionID = appUserInstitutionID;
        memberForMemberDetails.role = member['user_role'];
        memberForMemberDetails.status = member['status'];

        if(memberForMemberDetails.role == "Professor")
        {
          memberForMemberDetails.memberID = member['faculty_id'];
        }
        else if(memberForMemberDetails.role == "Student")
        {
          memberForMemberDetails.memberID = member['register_id'];
        }

      } else {
        doDisplayMemberDetails = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MemberSearchBar(_memberSearchBar, displayMemberNew, displayMemberDetails),
      //AppBar(
      //  title: const Text("Search Page"),
      //  backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      //),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Column(children: [
              Row(children: [
            const SizedBox(width: 10),
            Text("${memberForMemberDetails.building} / ${memberForMemberDetails.floor}"),
            const Spacer(),
            CustomDropdownButton(value: selectedInputType, items: valuesInputType, onChanged: (String? newInputType) {
                setState(() {
                  if (newInputType != null) {
                    selectedInputType = newInputType;
                  }
                });
              },
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            ),
            ],
            )
            ]),
            MapDetailsDisplayWidget(key: _mapDetailsDisplayWidget),
            //MapDisplayWidget()
            //Spacer
           // (

           // ),
           const SizedBox(
            height: 15,
           ),
            MemberDetails(this.memberForMemberDetails)
          ],
        ),
      ),
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
          if(member.name != "Default") Text("Location: ${member.building} / ${member.floor} / ${member.room}")
        ],
      ),
    );
  }
}
