# Generated by Django 5.0.4 on 2024-04-29 06:55

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0029_remove_userdata_updated_date'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='userdata',
            name='created_date',
        ),
    ]