# Generated by Django 5.0.4 on 2024-05-07 11:26

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0045_alter_userdata_time_taken'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='userdata',
            name='time_taken',
        ),
    ]
