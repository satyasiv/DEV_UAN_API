# Generated by Django 5.0.4 on 2024-04-10 09:26

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0004_remove_userdata_created_by_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='userdata',
            name='created_by',
            field=models.CharField(default='Unknown', max_length=500),
        ),
    ]
