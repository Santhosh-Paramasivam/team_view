import base64
import json

with open(r"C:\Users\Santhosh\Desktop\Studies\All Projects\Flutter\team_view_no_database\string_encoding\membertracking-e18e2-firebase-adminsdk-2w32h-77b1b03ff3.json", "r") as infile:
    json_data = infile.read()
    print(json_data)

    json_base64 = base64.b64encode(json_data.encode('utf-8')).decode('utf-8')

    # Step 3: Store the Base64 string in a file or print it
    # Option 1: Print the Base64 string
    print(json_base64)

    # Option 2: Store the Base64 string in a file
    with open('service-account-base64.txt', 'w') as output_file:
        output_file.write(json_base64)

    print("JSON file has been converted to Base64 and saved.")