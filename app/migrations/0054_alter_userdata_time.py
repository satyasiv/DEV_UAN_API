# Generated by Django 5.0.4 on 2024-05-07 12:53

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0053_userdata_time'),
    ]

    operations = [
        migrations.AlterField(
            model_name='userdata',
            name='time',
            field=models.CharField(default=None, max_length=100),
        ),
    ]
