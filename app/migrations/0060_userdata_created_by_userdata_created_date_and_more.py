# Generated by Django 5.0.4 on 2024-05-10 05:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0059_remove_userdata_created_by_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='userdata',
            name='name',
            field=models.CharField(default=None, max_length=255),
        ),
        migrations.AddField(
            model_name='userdata',
            name='entry_status',
            field=models.TextField(default=None),
        ),
        migrations.AddField(
            model_name='userdata',
            name='created_by',
            field=models.CharField(blank=True, default=None, max_length=100, null=True),
        ),
        migrations.AddField(
            model_name='userdata',
            name='created_date',
            field=models.DateTimeField(auto_now=True),
        ),
        migrations.AddField(
            model_name='userdata',
            name='remarks',
            field=models.TextField(default=None),
        ),
        migrations.AddField(
            model_name='userdata',
            name='time',
            field=models.CharField(blank=True, default=None, max_length=100, null=True),
        ),
        migrations.AddField(
            model_name='userdata',
            name='uan_num',
            field=models.CharField(default=None, max_length=100),
        ),
        migrations.AddField(
            model_name='userdata',
            name='uan_status',
            field=models.CharField(default=None, max_length=500),
        ),
        migrations.AddField(
            model_name='userdata',
            name='updated_date',
            field=models.DateTimeField(auto_now=True),
        ),
        migrations.AddField(
            model_name='userdata',
            name='user_uuid',
            field=models.CharField(default=None, max_length=100),
        ),
    ]