# Generated by Django 5.0.4 on 2024-04-09 18:48

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0002_alter_userdata_aadhaar_number_and_more'),
    ]

    operations = [
        migrations.RenameField(
            model_name='userdata',
            old_name='unique_id',
            new_name='user_uuid',
        ),
    ]