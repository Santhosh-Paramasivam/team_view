import 'package:flutter/material.dart';
//import 'search_page.dart';
//import 'search_page_persons.dart';
import 'search_page_members.dart';
import 'status_and_visibility.dart';
import 'search_page_room.dart';
import 'firebase_templates/firestore_query.dart';
import 'firebase_templates/firestore_query_autoupdate.dart';
import 'firebase_templates/firebase_query_returndata copy.dart';

class AccountDetails extends StatelessWidget
{
  const AccountDetails({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text("Welcome Back, Santhosh"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body:Column(children:
        [
          MenuButton("Status And Visibility", (context)
          {
            Navigator.push
            (
              context,
              MaterialPageRoute(builder: (context) => const StatusAndVisibility())
            );
          }),
          MenuButton("Room Search Page",  (context){
            Navigator.push
            (
              context,
              MaterialPageRoute(builder: (context) => const RoomSearchPage())
            );}),
          MenuButton("Search members and venues", (context){
            Navigator.push
            (
              context,
              MaterialPageRoute(builder: (context) => const SearchPage())
            );
          }),
           MenuButton("Firestore Query", (context){
            Navigator.push
            (
              context,
              MaterialPageRoute(builder: (context) => UsersPage())
            );
          }),
            MenuButton("Firestore Stream", (context){
            Navigator.push
            (
              context,
              MaterialPageRoute(builder: (context) => UserPageAutoupdate())
            );
          }),
          MenuButton("Firestore Data", (context){
            Navigator.push
            (
              context,
              MaterialPageRoute(builder: (context) => ReturnPrintData())
            );
          }),
          MenuButton("Log Out", (context){
            Navigator.pop(context);
          }),
          MenuButton("Search Page", (context){})
        ]
      )
      );
  }
}

class MenuButton extends StatelessWidget
{
  String label = "";
  //final VoidCallback onPressed; 
  //final Function(BuildContext) onPressed;
  final void Function(BuildContext) onPressed;

  MenuButton(this.label, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context)
  {
    return SizedBox
        (
          width: double.infinity,
          height: 60,
          child:  TextButton(
            style: const ButtonStyle
            (
              shape: WidgetStatePropertyAll<RoundedRectangleBorder>
                (
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    )
                )
            ),
            onPressed: () => this.onPressed(context), 
            child: Text(
              this.label, 
              style: const TextStyle(fontSize: 18, color: Colors.blue),)),
        );
  }
}