from rest_framework.authentication import BasicAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.authtoken.models import Token
from rest_framework.views import APIView
from rest_framework.response import Response
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from psycopg2 import Timestamp
from django.forms import model_to_dict
from django.http import JsonResponse
from django.views import View
from django.urls import reverse
from django.http import HttpRequest
import pandas as pd
from rest_framework import status
from datetime import datetime,date
from django.utils import timezone
# from .models import IndividualUserStatus
from .models import output
from .models  import  sampledata
import subprocess
import threading
from decimal import Decimal
import subprocess
import uuid
import json
from django.forms.models import model_to_dict
from django.core.exceptions import ObjectDoesNotExist








#run_bot
def run_bot(validated_data):
    # Take only the first 500 data entries
    # print("validated--2", validated_data)
    robot_path = "/home/buzzadmin/Desktop/apitask/DEV_UAN_API/tasks.robot"
    output_directory = "/home/buzzadmin/Desktop/apitask/DEV_UAN_API/output"
    validated_data_json = json.dumps(validated_data)
    print(' validated_data_json ', validated_data_json )
    # print(validated_data_json)
    try:
        command = ['robot',
                   '--variable', f'validated_data:{validated_data_json}',
                   '--outputdir', output_directory,  
                   '--log', f'{output_directory}/log.html',  
                   robot_path]
        result = subprocess.run(command, capture_output=True)
        print('Result:', result)
        print('stdout:', result.stdout.decode())
        print('stderr:', result.stderr.decode())
        if result.returncode == 0:
            print("Robot Framework execution was successful.")
        else:
            print("Robot Framework execution failed.")
    except Exception as e:
        print("An error occurred during the execution:", str(e))
        print("Error occurred while processing the following data:")
        return "error"


class ObtainAuthTokenView(APIView):
    authentication_classes = [BasicAuthentication]
    permission_classes = [IsAuthenticated]
    def post(self, request, *args, **kwargs):
        # user auth
        user_credentials = f"{request.user.username}_{request.user.password}" 
        #uuid in response
        user_uuid = uuid.uuid3(uuid.NAMESPACE_OID, user_credentials)
        request.session['user_uuid'] = str(user_uuid)
        timestamp = (user_uuid.time - 0x01b21dd213814000) * 100 / 1e9  # timestamp
        print('sampledata',sampledata)
        data_queryset = sampledata.objects.filter(is_active=True).order_by('id')[:200]
        print(data_queryset, "datadfg")  # Debug print to check data_queryset
        print("Length of data_queryset:", data_queryset.count())
        validated_rows = []
        invalid_rows = []
        for instance in data_queryset:
            errors = []
            if not instance.member_name:
                errors.append('Member Name is required')
                print(f'Error: Member Name is required for {instance}')  # Debug print
            if errors:
                invalid_rows.append({'instance': instance, 'errors': errors})
            else:
                validated_rows.append(instance)
        # Handle invalid rows
        for row in invalid_rows:
            instance = row['instance']
            errors = row['errors']
            print(f'Errors for {instance.member_name}: {", ".join(errors)}')
        validated_data = []
        for instance in validated_rows:
            print("instance idddddddddddddd")
            print(instance.id)
            universal_account = instance.Universal_Account if instance.Universal_Account is not None else 'None'
            print( universal_account )
            validated_data.append({
                'user_id': instance.id,
                'member_name': instance.member_name,
                'gender': instance.gender,
                'father_husband_name': instance.father_husband_name,
                'relationship_with_member': instance.relationship_with_member,
                'nationality': instance.nationality,
                'marital_status': instance.marital_status,
                'aadhaar_number': instance.aadhaar_number,
                'name_as_on_aadhaar': instance.name_as_on_aadhaar,
                'date_of_birth': str(convert_to_dd_mm_yyyy(instance.date_of_birth)),
                'date_of_joining': str(convert_to_dd_mm_yyyy(instance.date_of_joining)),
                'Universal_Account': instance.Universal_Account,
                'wages_as_on_joining': instance.wages_as_on_joining,
            })
        threading.Thread(target=run_bot, args=(validated_data,)).start()
        return JsonResponse({'message': 'Robot is in progress for valid users. Please view the status from localhost:8000/boturl to know about the bot status', 'uuid': str(user_uuid), 'timestamp': timestamp, 'error': invalid_rows}, status=status.HTTP_400_BAD_REQUEST)


#date function
def convert_to_dd_mm_yyyy(date_input):
    if isinstance(date_input, datetime):
        return date_input.strftime("%d/%m/%Y")
    elif isinstance(date_input, date):
        return date_input.strftime("%d/%m/%Y")
    else:
        try:
            parsed_date = datetime.strptime(date_input, "%Y-%m-%d")
            return parsed_date.strftime("%d/%m/%Y")
        except ValueError:
            return date_input




# class UserStatus(APIView):  
#     def get(self, request, *args, **kwargs):
#         data_queryset = list(sampledata.objects.filter(is_failed=True).values())
#         print("fsdghjkl;", type(data_queryset))
#         data_dict={
#                    "pending_user" : data_queryset }
#         return JsonResponse({'message': 'Bot status is ...', 'pending_data': data_dict} )
     

class UserStatus(APIView):
    def get(self, request, *args, **kwargs):
        global bot_status
        
        # Fetch the data queryset for failed users
        failed_users_queryset = sampledata.objects.filter(is_failed=True)
        success_users_queryset = sampledata.objects.filter(is_failed=False)

        # Convert querysets to list of dictionaries for JSON response
        failed_users_list = list(failed_users_queryset.values())
        for user in failed_users_list:
            user['status'] = 'failed'
        
        success_users_list = list(success_users_queryset.values())
        for user in success_users_list:
            user['status'] = 'success'

        # Debug prints
        print("Type of failed_users_queryset:", type(failed_users_queryset))
        print("Failed users queryset:", failed_users_queryset)
        print("Length of failed_users_queryset using count():", failed_users_queryset.count())
        print("Length of failed_users_list:", len(failed_users_list))

        print("Type of success_users_queryset:", type(success_users_queryset))
        print("Success users queryset:", success_users_queryset)
        print("Length of success_users_queryset using count():", success_users_queryset.count())
        print("Length of success_users_list:", len(success_users_list))

        # Prepare the data dictionary
        data_dict = {
            'no_of_users_failed': failed_users_queryset.count(),
            'failed_users_list': failed_users_list,
            'no_of_users_success': success_users_queryset.count(),
            'success_users_list': success_users_list
        }

        # Include the bot status in the response
        if bot_status == "running":
            return JsonResponse({'message': 'Bot is currently running...', 'data': data_dict})
        elif bot_status == "failed":
            return JsonResponse({'message': 'Bot execution failed.', 'data': data_dict})
        elif bot_status == "success":
            return JsonResponse({'message': 'Bot execution was successful.', 'data': data_dict})
        else:
            return JsonResponse({'message': 'Bot status is idle.', 'data': data_dict})



#condition if userfailed
class InsertInitialUserData(APIView):
    def post(self, request, *args, **kwargs):
        member_data = request.data.get('member_data') 
        user_id = member_data.get('user_id')
        print('memeber_dat:', member_data)
        print("Received user_id:", user_id)  
        try:
            samp_user_obj = sampledata.objects.get(id=user_id)
            samp_user_obj.is_failed = True
            samp_user_obj.is_active = True
            samp_user_obj.save()
            print("User is_active set to True")
            return Response({'status': 'success', 'member_data': member_data}, status=status.HTTP_201_CREATED)
        except ObjectDoesNotExist:
            print("User not found in the database")
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            print("An error occurred:", e)  # Print any other exception that occurred
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

#condition if usersuccess 
class UpdateInitialUserData(APIView):
    def post(self, request, *args, **kwargs):
        member_data = request.data.get('member_data')
        user_id = member_data.get('user_id')
        print('memeber data',member_data)
        print('user_id',user_id)
        try:
            samp_user_obj = sampledata.objects.get(id=user_id)
            samp_user_obj.is_failed = False
            samp_user_obj.is_active = False
            samp_user_obj.save()
            print("User is_active set to False")
            return Response({'status': 'success'}, status=status.HTTP_201_CREATED)
        except ObjectDoesNotExist:
            print("User not found in the database")
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            print("An error occurred:", e)  # Print any other exception that occurred
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            



class InsertUserData(APIView):
    def post(self, request, *args, **kwargs):
        aadhaar_number = request.data.get('aadhaar_number')
        name = request.data.get('name')
        entity_status = request.data.get('entity_status')
        uan_status = request.data.get('uan_status')
        uan_num = request.data.get('uan_num')
        remarks = request.data.get('remarks')
        user_uuid = request.data.get('user_uuid')
        time = request.data.get('time')

        print('Received data:')
        print('aadhaar_number:', aadhaar_number)
        print('name:', name)
        print('entity_status:', entity_status)
        print('uan_status:', uan_status)
        print('uan_num:', uan_num)
        print('remarks:', remarks)
        print('user_uuid:', user_uuid)
        print('time:', time)

        existing_user = output.objects.filter(aadhaar_number=aadhaar_number).first()
        print('existing_user:', existing_user)

        if existing_user:
            if existing_user.remarks != 'success':
                print(f'Aadhaar number {aadhaar_number} already exists but remarks are not "success". Updating the row.')
                existing_user.name = name
                existing_user.entity_status = entity_status
                existing_user.uan_status = uan_status
                existing_user.uan_num = uan_num
                existing_user.remarks = remarks
                existing_user.user_uuid = user_uuid
                existing_user.time = time
                existing_user.save()
                return Response({'status': 'Aadhaar number already exists but was updated due to remarks not being "success".'}, status=status.HTTP_200_OK)
            else:
                print(f'Aadhaar number {aadhaar_number} already exists in the database with remarks as "success". Skipping insertion for this user.')
                return Response({'status': 'Aadhaar number already exists in the database with remarks as "success". Skipped.'}, status=status.HTTP_200_OK)
        else:
            new_data = output.objects.create(
                aadhaar_number=aadhaar_number,
                name=name,
                entity_status=entity_status,
                uan_status=uan_status,
                uan_num=uan_num,
                remarks=remarks,
                user_uuid=user_uuid,
                time=time
            )
            new_data.save()
            print(f'New user with Aadhaar number {aadhaar_number} has been created.')
            return Response({'status': 'success'}, status=status.HTTP_201_CREATED)








