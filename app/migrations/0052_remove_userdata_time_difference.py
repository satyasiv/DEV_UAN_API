# Generated by Django 5.0.4 on 2024-05-07 11:49

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0051_userdata_time_difference'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='userdata',
            name='time_difference',
        ),
    ]