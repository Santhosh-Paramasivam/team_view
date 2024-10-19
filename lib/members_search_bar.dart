import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MemberSearchBar extends StatefulWidget implements PreferredSizeWidget{
  final void Function(String) displayMemberNew;
  final void Function(String) displayMemberDetails;

  const MemberSearchBar(Key key, this.displayMemberNew, this.displayMemberDetails);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


  @override
  State<MemberSearchBar> createState() => MemberSearchBarState();
}

class MemberSearchBarState extends State<MemberSearchBar> {

  late List<String> searchTerms;
  late List<String> jsonSearchTerms;
  late Map<String,dynamic> jsonData;
  late int appUserInstitutionID;
  late String searchedUser;

  late String inputSentBack;
  late String searchBarLabel;

  @override
  initState()
  {
    searchTerms = [
    'santhosh',
    'bharath',
    'arun prasath'
    ];

    jsonSearchTerms = [];
    appUserInstitutionID = 1;
    updateOptions("");
    inputSentBack = "";
    searchBarLabel = "Search People";
  }

  void updateSearchBarLabel(String query)
  {
    searchBarLabel = "Searched $query";
  }

  void sendBackString(String data)
  {
    inputSentBack = data;
  }

  Future<void> updateOptions(String searchSubstring) async {
  jsonSearchTerms.clear();

  String jsonString = await rootBundle.loadString('assets/members.json');
  setState(() {
    jsonData = json.decode(jsonString);

    // Using List<dynamic> to avoid type issues
    List<dynamic> filteredMembers = jsonData['institution_members']
        .where((member) =>
            member['name'] != null &&
            member['name'].toString().toLowerCase().contains(searchSubstring.toLowerCase()))
        .toList();

    // Print the filtered members
    for (var member in filteredMembers) {
    jsonSearchTerms.add((member as Map<String, dynamic>)['name']); // Cast to Map<String, dynamic>
    }
  });
}

  @override
  AppBar build(BuildContext context) {
    return AppBar(
        title: Text(searchBarLabel),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context, delegate: CustomSearchDelegate(jsonSearchTerms, updateOptions, sendBackString, widget.displayMemberNew, this.updateSearchBarLabel, widget.displayMemberDetails));
          }, 
          icon: const Icon(Icons.search))
        ],
    );
  }
}

class CustomSearchDelegate extends SearchDelegate 
{
  List<String> searchTerms;
  final Future<void> Function(String query) updateOptions;
  void Function(String) sendBackString;
  final void Function(String) displayMemberNew;
  final void Function(String) updateSearchBarLabel;
  final void Function(String) displayMemberDetails;

  CustomSearchDelegate(this.searchTerms, this.updateOptions, this.sendBackString, this.displayMemberNew, this.updateSearchBarLabel, this.displayMemberDetails);

  Future<void> onQueryChanged(String query) async {
    await updateOptions(query);
  }

  @override
  List<Widget> buildActions(BuildContext context)
  {
    return [
      IconButton(
        onPressed: ()
        {
          query = "";
        }, 
        icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context)
  {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: ()
      {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context)
  {
    onQueryChanged(query);
    List<String> matchQuery = [];
    for(var person in searchTerms)
    {
      if(person.toLowerCase().contains(query.toLowerCase()) && matchQuery.length < 5)
      {
        matchQuery.add(person);
      }
    }

    return ListView.builder
    (
      itemCount: matchQuery.length,
      itemBuilder: (context, index)
      {
        var result = matchQuery[index];
        return ListTile
        (
          title: TextButton(
          onPressed: ()
          {
            query = result; 
            matchQuery = [];
            showResults(context);
            //sendBackString(query);
            updateSearchBarLabel(query);
            displayMemberNew(query);
            displayMemberDetails(query);
            close(context, null);
            }, 
          child: Text(result))
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context){
    List<String> matchQuery = [];
    for(var person in searchTerms)
    {
      if(person.toLowerCase().contains(query.toLowerCase()) && matchQuery.length < 5 && query.isNotEmpty)
      {
        matchQuery.add(person);
      }
    }

    return ListView.builder
    (
      itemCount: matchQuery.length,
      itemBuilder: (context, index)
      {
        var result = matchQuery[index];
        return ListTile
        (
          title: TextButton(
          onPressed: ()
          {
            query = result; 
            matchQuery = [];
            showResults(context);
            //sendBackString(query);
            updateSearchBarLabel(query);
            displayMemberNew(query);
            displayMemberDetails(query);
            close(context, null);
          }, 
          child: Text(result))
        );
      },
    );
  }
}
