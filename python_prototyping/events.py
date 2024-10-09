import json
query = {'floor':"FirstFloor", 'institution_id':1, 'building':'SRMIST', 'timestamp':2, 'day':'Tuesday'}
with open(r'events.json', 'r') as events:
    events_dict = json.loads(events.read())
    for i in range(len(events_dict['events'])):
        # print(events_dict['events'][i])
        if(events_dict['events'][i]['floor'] == query['floor'] and
           events_dict['events'][i]['institution_id'] == query['institution_id'] and
           events_dict['events'][i]['building'] == query['building'] and
           events_dict['events'][i]['end_timestamp'] >= query['timestamp'] and 
           events_dict['events'][i]['start_timestamp'] <= query['timestamp'] and 
           events_dict['events'][i]['day'] == query['day']
           ):
            print(events_dict['events'][i]['room'], end = " , ")
            print(events_dict['events'][i]['name'], end = " , ")
            print(events_dict['events'][i]['start_timestamp'], end = ' to ')
            print(events_dict['events'][i]['end_timestamp'])
        else:
            print(None)