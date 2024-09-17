import json

jsonFilePath = r'assets/buildings.json'
with open(jsonFilePath,'r') as jsonToFlatten:
    jsonDict = json.loads(jsonToFlatten.read())
    flattenedJson = json.dumps(jsonDict['buildings'][0]['GroundFloor'])
    print(flattenedJson)