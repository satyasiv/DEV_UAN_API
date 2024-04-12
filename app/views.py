import uuid
from rest_framework.authtoken.models import Token
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.authentication import BasicAuthentication
from rest_framework.permissions import IsAuthenticated
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.urls import reverse
from django.http import HttpRequest
import pandas as pd
from datetime import datetime
import subprocess
import threading
from .models import IndividualUserStatus
import json
from django.utils import timezone
from django.http import JsonResponse
from .models import UserData
from rest_framework import status
# from rest_framework.exceptions import APIException


# ENABLE = False
from django.http import JsonResponse
def run_bot(user_uuid, username, validated_data):
    print("userertyui",user_uuid)
    robot_path = "/home/buzzadmin/Documents/Django/project/tasks.robot"
    len_validated_data = len(validated_data)
    print(len_validated_data,'len_validated_datalen_validated_datalen_validated_data')
    try:
        for index, ind_user in enumerate(validated_data):
            user_uuid = str(uuid.uuid1())  # Generate user_uuid within the loop
            print('user_uuid:', user_uuid)  # Print user_uuid
            ind_user['user_uuid'] = user_uuid
            ind_user['created_by'] = username
            member_details_json = json.dumps(ind_user)
            new_user = IndividualUserStatus(
                executer_id=user_uuid,
                created_by=username,
                status='inprogress',
                member_name=ind_user.get('Member Name'),
                member_details=member_details_json,
                current_index=index,
                total_index=len_validated_data
            )
            new_user.save()
            ind_user['user_uuid'] = user_uuid
            ind_user['created_by'] = username 
            aaa = [f'{key}:{val}' for key, val in ind_user.items()]
            print('ewrtyui',user_uuid)
            aaa_str = ", ".join(aaa)
            print('aaa_str:', aaa_str)
            result = subprocess.run(['robot', '--variable', f'aaa_str:{aaa_str}', robot_path], capture_output=True)
            print('Result:', result)
            print('stdout:', result.stdout.decode())
            print('stderr:', result.stderr.decode())
            if result.returncode == 0:   
                new_user.status = "completed"
            else:
                new_user.status = "rejected"  
            new_user.updated_at = datetime.now()
            new_user.save()
    except Exception as e:
        print("An error occurred:", e)

class ObtainAuthTokenView(APIView):
    authentication_classes = [BasicAuthentication]
    permission_classes = [IsAuthenticated]
    def post(self, request, *args, **kwargs):
        # user auth
        if not request.user.is_authenticated:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
        user = request.user
        Token.objects.filter(user=user).delete()
        # uuid
       # Generate a unique UUID based on user credentials
        user_credentials = f"{request.user.username}_{request.user.password}"  # Customize this as per your requirements
        user_uuid = uuid.uuid3(uuid.NAMESPACE_OID, user_credentials)
        # Set the session with the user-specific UUID
        request.session['user_uuid'] = str(user_uuid)
        timestamp = (user_uuid.time - 0x01b21dd213814000) * 100 / 1e9  # Convert timestamp to seconds
        # uploaded file
        uploaded_file = request.FILES.get('file')
        data = pd.read_excel(uploaded_file)
        req_columns = ['Member Name', 'Gender', 'Father/Husband Name', 'Relationship with the Member',
                       'Nationality', 'Marital Status', 'AADHAAR Number', 'Name as on AADHAAR', 'Mr/Mrs',
                       'Date of Birth', 'Date of Joining', 'Wages as on Joining']
        invalid_rows = []
        validated_rows = []
        for index, row in data.iterrows():
            # print(index,"====",row)
            invalid = False
            for column in req_columns:
                # print(column,"====column===")
                if pd.isnull(row[column]):
                    row['error'] = f'{column} must be in required for {row["Member Name"]}'
                    invalid = True
                elif (column in ['Date of Birth', 'Date of Joining'] and not isinstance(row[column], datetime)):
                    row['error'] = f'{column} must be in date format for {row["Member Name"]}'
                    invalid = True
                    break
                elif (column in ['Wages as on Joining'] and not str(row[column]).isdigit()):
                    invalid = True
                    row['error'] = f'{column} must be a number for {row["Member Name"]}'
                    break
                elif (column in ['Gender'] and row['Gender'] not in ['F', 'M']):
                    invalid = True
                    row['error'] = f'{column} must required and must be in F or M for {row["Member Name"]}'
                    break
                elif column == 'AADHAAR Number' and (not str(row[column]).isdigit() or len(str(row[column])) != 12):
                    row['error'] = f'{column} Must be a 12 digit number for {row["Member Name"]}'
                    invalid = True
                    break  
            if invalid:
                invalid_rows.append(row)
            else:
                validated_rows.append(row)
        if invalid_rows:
                invalid_df = pd.DataFrame(invalid_rows)
                invalid_rowss = invalid_df['error'].to_list()
        else:
            invalid_df = pd.DataFrame()
            invalid_rowss = []
        # print("validated_rows---",len(validated_rows))
        validated_df = pd.DataFrame(validated_rows)
        validated_df.to_csv("abc.csv")
        validated_df.fillna('None')
        validated_df['Date of Birth'] = pd.to_datetime(validated_df['Date of Birth'], errors='coerce').dt.strftime('%d/%m/%Y')
        validated_df['Date of Joining'] = pd.to_datetime(validated_df['Date of Joining'], errors='coerce').dt.strftime('%d/%m/%Y')
        # Remove decimal from Universal Account number
        validated_df['Universal Account'] = validated_df['Universal Account'].astype(str).str.rstrip('.0')
        validated_data = validated_df.to_dict(orient='records')
        print(len(validated_data), '*******validated_data')
        print("validateed ",validated_data)
        print("userertyui",user_uuid)
        threading.Thread(target=run_bot, args=(user_uuid, request.user.username, validated_data,)).start()
        return JsonResponse({'message': 'Robot is in progress for valid users. Please view the status from ''url localhost:8000/boturl to know about the bot status','uuid': str(user_uuid), 'timestamp': timestamp, 'error': invalid_rowss}, status=status.HTTP_400_BAD_REQUEST)
       

class InsertUserData(APIView):
    def post(self, request, *args, **kwargs):
        # Extract the data sent with the POST request   
        aadhaar_number = request.data.get('aadhaar_number')
        uan_status = request.data.get('uan_status')
        uan_num = request.data.get('uan_num')
        remarks = request.data.get('remarks')
        user_uuid = request.data.get('user_uuid')
        created_by = request.data.get('created_by')
        print('Received data:')
        print('aadhaar_number:', aadhaar_number)
        print('uan_status:', uan_status)
        print('uan_num:', uan_num)
        print('remarks:', remarks)
        print('unique_id:', user_uuid)
        print('created_by:', created_by)
        # Check if Aadhaar number already exists in the database
        existing_user = UserData.objects.filter(aadhaar_number=aadhaar_number).first()
        if existing_user:
            #remarks==None
            if remarks is None:
                print(f'Aadhaar number {aadhaar_number} already exists in the database with remarks as None. Updating the remarks.')
                existing_user.remarks = remarks
                existing_user.save()
            else:
                print(f'Aadhaar number {aadhaar_number} already exists in the database. Skipping insertion for this user.')
                return Response({'status': 'Aadhaar number already exists in the database. Skipped.'}, status=status.HTTP_200_OK)
        else:
            # If Aadhaar number doesn't exist, proceed with creating new user data
            new_data = UserData.objects.create(
                aadhaar_number=aadhaar_number,
                uan_status=uan_status,
                uan_num=uan_num,
                remarks=remarks,
                user_uuid=user_uuid,
                created_by=created_by
            )
            new_data.save()
        return Response({'status': 'success'}, status=status.HTTP_201_CREATED)


@method_decorator(csrf_exempt, name='dispatch')
class BotRunner(View):
	def post(self, request):
		# Get the UUID from the POST 
		received_uuid = request.POST.get('text')  # Change 'uuid' to 'text'
		# user uuid
		user_uuid = request.session.get('user_uuid')
		print("received_uuid:", received_uuid)
		print("user_uuid:", user_uuid)
		if received_uuid is not None:
			if received_uuid == user_uuid:
				stored_data = IndividualUserStatus.objects.filter(executer_id=received_uuid)
				total_length = stored_data.first().total_index
				current_index = stored_data.first().current_index
				inprogress = stored_data.filter(status='pending').values('')
				completed = stored_data.filter(status='completed')
				rejected = stored_data.filter(status='rejected')
				if int(total_length) == int(current_index):
					status = 'completed'
					message = f'{total_length} out of {total_length} was successfully executed'
				elif int(total_length) != int(current_index):
					status = 'pending'
					message = f'{current_index} out of {total_length} users was successfully executed'
				response_data = {
					'uuid_number': user_uuid,
					'message': message,
					'status': status,
				}
				return JsonResponse(response_data)
			else:
				return JsonResponse({'error': 'Invalid UUID'}, status=400)
		else:
			return JsonResponse({'error': 'received_uuid is None'}, status=400)
   
















































