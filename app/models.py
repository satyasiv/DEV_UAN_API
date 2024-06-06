from django.db import models
from django.contrib.auth.models import User
import uuid
import json
from django.utils import timezone
from django.db import models






class output(models.Model):
    aadhaar_number = models.CharField(max_length=500, default=None)
    name = models.CharField(max_length=255, default=None)  # New column
    uan_status = models.CharField(max_length=500, default=None)
    uan_num = models.CharField(max_length=100, default=None)
    remarks = models.TextField(default=None)
    entity_status= models.TextField(default=None)
    user_uuid = models.CharField(max_length=100, default=None)
    created_date = models.DateTimeField(auto_now=True)
    created_by = models.CharField(max_length=100, default=None,blank=True,null=True)
    updated_date = models.DateTimeField(auto_now=True) 
    time= models.CharField(default=None,blank=True,null=True,max_length=100)



class sampledata(models.Model):
    Universal_Account = models.BigIntegerField(default=None)
    member_name = models.CharField(max_length=255, default=None)
    gender = models.CharField(max_length=7, choices=[('F', 'Female'), ('M', 'Male')], default=None)
    father_husband_name = models.CharField(max_length=100, default=None)
    relationship_with_member = models.CharField(max_length=100, default=None)
    nationality = models.CharField(max_length=255, default=None)
    marital_status = models.CharField(max_length=100, default=None)
    aadhaar_number = models.CharField(max_length=12, default=None)
    name_as_on_aadhaar = models.CharField(max_length=255, default=None)
    date_of_birth = models.DateField(default=None)
    date_of_joining = models.DateField(default=None)
    wages_as_on_joining = models.IntegerField(default=0, blank=True)
    is_active = models.BooleanField(default=True, blank=True, null=True)
    is_failed= models.BooleanField(default=False, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    created_by = models.CharField(max_length=100, default=None, blank=True, null=True)
