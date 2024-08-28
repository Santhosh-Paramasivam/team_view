import 'package:flutter/material.dart';
import 'search_page.dart';
import 'dropdown.dart';

class AccountDetails extends StatelessWidget
{
  const AccountDetails({super.key});

  void logOut(BuildContext context)
  {
    Navigator.pop(context);
  }

  void searchPage(context)
  {
    Navigator.push
    (
      context,
      MaterialPageRoute(builder: (context) => const SearchPage())
    );
  }
  
  void nothing(context)
  {
    
  }

  void dropDown(context)
  {
    Navigator.push
    (
      context,
      MaterialPageRoute(builder: (context) => const IconDropdownPage())
    );
  }

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
          MenuButton("Set Status", this.nothing),
          MenuButton("Set Visibility", this.nothing),
          MenuButton("Search members and venues", this.searchPage),
          MenuButton("Log Out", this.logOut),
          MenuButton("Drop Down", this.dropDown)
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