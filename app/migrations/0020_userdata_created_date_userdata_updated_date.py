# Generated by Django 5.0.4 on 2024-04-27 11:06

import django.utils.timezone
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0019_delete_sampledata'),
    ]

    operations = [
        migrations.AddField(
            model_name='userdata',
            name='created_date',
            field=models.DateTimeField(default=django.utils.timezone.now),
        ),
        migrations.AddField(
            model_name='userdata',
            name='updated_date',
            field=models.DateTimeField(auto_now=True),
        ),
    ]