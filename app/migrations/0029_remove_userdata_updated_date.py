# Generated by Django 5.0.4 on 2024-04-29 06:55

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0028_alter_sampledata_wages_as_on_joining'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='userdata',
            name='updated_date',
        ),
    ]
