# Generated by Django 5.0.4 on 2024-05-07 11:26

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0044_remove_userdata_time_difference_userdata_time_taken'),
    ]

    operations = [
        migrations.AlterField(
            model_name='userdata',
            name='time_taken',
            field=models.CharField(default='', max_length=500),
        ),
    ]