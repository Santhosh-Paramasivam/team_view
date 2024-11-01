import 'package:flutter/material.dart';
import 'drop_down_box.dart';
import 'draw_map_set_location.dart';
import 'building_details.dart';

class RoomEventDetails {
  String roomName;
  String eventName;

  RoomEventDetails(this.roomName, this.eventName);
}

class LocationSetPage extends StatefulWidget {
  const LocationSetPage({super.key});

  @override
  State<LocationSetPage> createState() => _LocationSetPageState();
}

class _LocationSetPageState extends State<LocationSetPage> {

  String selectedBuilding = BuildingDetails.buildings[0];
  String selectedFloor = BuildingDetails.floors[0];

  List<DropdownMenuItem<String>> dynamicValuesBuilding()
  {
    List<DropdownMenuItem<String>> valuesBuilding = [];

    for(String building in BuildingDetails.buildings)
    {
      valuesBuilding.add(DropdownMenuItem(value: building, child: Text(building)));
    }

    return valuesBuilding;
  }

  List<DropdownMenuItem<String>> dynamicValuesFloors()
  {
    List<DropdownMenuItem<String>> valuesFloors = [];

    for(String floor in BuildingDetails.floors)
    {
      valuesFloors.add(DropdownMenuItem(value: floor, child: Text(floor)));
    }

    return valuesFloors;
  }

  final GlobalKey<SetLocationMapWidgetState> _mapDetailsDisplayWidget =
      GlobalKey<SetLocationMapWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Venue Details"),
      ),
      body: Column(
        children: [
          // Wrapping Row inside a Container with width constraints
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Ensure Row shrinks to fit
              children: [
                CustomDropdownButton(
                  value: selectedBuilding,
                  items: dynamicValuesBuilding(),
                  onChanged: (String? chosenBuilding) {
                    setState(() {
                      if (chosenBuilding != null) {
                        selectedBuilding = chosenBuilding;
                        _mapDetailsDisplayWidget.currentState!
                            .changeFloorAndBuilding(
                                selectedFloor, selectedBuilding);
                      }
                    });
                  },
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                ),
                CustomDropdownButton(
                  value: selectedFloor,
                  items: dynamicValuesFloors(),
                  onChanged: (String? chosenFloor) {
                    setState(() {
                      if (chosenFloor != null) {
                        selectedFloor = chosenFloor;
                        _mapDetailsDisplayWidget.currentState!
                            .changeFloorAndBuilding(
                                selectedFloor, selectedBuilding);
                      }
                    });
                  },
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                ),
                const Spacer(),
              ],
            ),
          ),
          SetLocationMap(key: _mapDetailsDisplayWidget),
        ],
      ),
    );
  }
}
