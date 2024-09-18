class Member
{
  String name;
  String rfidLocation;
  int institutionID;
  int id;
  late String floor;
  late String building;
  late String room;
  String role;
  String memberID;
  String status;
  //int buildingID;

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