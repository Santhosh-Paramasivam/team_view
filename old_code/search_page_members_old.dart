// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:team_view_no_database_windows/drop_down_box.dart';
import 'package:team_view_no_database_windows/draw_map_text.dart';
import 'package:team_view_no_database_windows/custom_datatypes/member.dart';
import 'package:team_view_no_database_windows/members_search_bar.dart';


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

  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<MapDetailsDisplayWidgetState> _mapDetailsDisplayWidget = GlobalKey<MapDetailsDisplayWidgetState>();
  final GlobalKey<MemberSearchBarState> _memberSearchBar = GlobalKey<MemberSearchBarState>();

  @override
  initState()
  {
    super.initState();
    name = "Default";
    selectedInputType = "Person";
    memberForMemberDetails = Member("Default","SRMIST/GroundFloor/Room1",0,0);
    //memberForMemberDetails = Member("Default","Default",0,0);
    doDisplayMemberDetails = false;
    appUserInstitutionID = 1;
  }


  final List<DropdownMenuItem<String>> valuesInputType = [
    const DropdownMenuItem(value: 'Person', child: Text("Person")),
    const DropdownMenuItem(value: 'Room',child: Text("Room")),
    const DropdownMenuItem(value: 'Designation', child: Text("Designation")),
  ];

  void display async{
    setState(() {
      name = _searchController.text;
    });
    await loadMemberDetails();
    _mapDetailsDisplayWidget.currentState?.refreshName(name);
  }

  void displayMemberNew(String memberName) async{
    setState(() {
      name = memberName;
      print("Received$name");
    } 
    );
    await loadMemberDetails();
    _mapDetailsDisplayWidget.currentState?.refreshName(name);
  }


  void displayMemberDetails()
  {
    setState(() {
      name = _searchController.text;
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

      if (member != null) {
        doDisplayMemberDetails = true;
        memberForMemberDetails.name = member['name'];
        memberForMemberDetails.id = member['id'];
        memberForMemberDetails.changeManualLocation(member['manual_location']);
        memberForMemberDetails.institutionID = appUserInstitutionID;
        //print(memberForMemberDetails.building);
      } else {
        doDisplayMemberDetails = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MemberSearchBar(_memberSearchBar, displayMemberNew),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'Search $selectedInputType',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                        suffixIcon: IconButton(
                          onPressed: displayMember,
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
            ),
            ],
            )
            ]),
            //if(doDisplayMemberDetails) MemberDetails(this.memberForMemberDetails),
            MapDetailsDisplayWidget(key: _mapDetailsDisplayWidget),
            //MapDisplayWidget()
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
          Text("ID: ${member.id}"),
          Text("Name: ${member.name}"),
        ],
      ),
    );
  }
}
