# Generated by Django 5.0.4 on 2024-05-07 11:24

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0043_remove_userdata_time_taken'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='userdata',
            name='time_difference',
        ),
        migrations.AddField(
            model_name='userdata',
            name='time_taken',
            field=models.CharField(default=None, max_length=500),
        ),
    ]