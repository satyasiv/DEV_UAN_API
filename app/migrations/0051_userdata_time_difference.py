# Generated by Django 5.0.4 on 2024-05-07 11:47

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0050_remove_userdata_time_difference'),
    ]

    operations = [
        migrations.AddField(
            model_name='userdata',
            name='time_difference',
            field=models.CharField(default=None, max_length=500, null=True),
        ),
    ]
