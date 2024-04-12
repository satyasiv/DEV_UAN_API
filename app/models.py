from django.db import models
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token
import uuid
import json


class MyModel(models.Model):
    # Your model fields here
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    token = models.CharField(max_length=40)
   
class UploadedFile(models.Model):
    file_name = models.CharField(max_length=255)
    status = models.CharField(max_length=100)
    error_message = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)



class IndividualUserStatus(models.Model):  #  table 1 
    executer_id = models.UUIDField(default=uuid.uuid4, editable=False)
    status = models.CharField(max_length=255)
    member_name = models.CharField(max_length=255)
    member_details = models.JSONField()
    created_by = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    current_index = models.CharField(max_length=255,default=0)
    total_index = models.CharField(max_length=255,default=0)

    

    pass


#   postgres
# edhi nee bot nundi vachi pade data okay ekada kanipisthundi
class UserData(models.Model):   # edhi  table name and 
    aadhaar_number = models.CharField(max_length=500)
    uan_status = models.CharField(max_length=500)
    uan_num = models.CharField(max_length=500)
    remarks = models.TextField()
    user_uuid= models.CharField(max_length=500)
    # created_date = models.DateTimeField(auto_now_add=True)
    created_by = models.CharField(max_length=500,default='Unknown')
    # updated_date = models.DateTimeField(auto_now=True)
