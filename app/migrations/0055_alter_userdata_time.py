# Generated by Django 5.0.4 on 2024-05-07 12:55

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0054_alter_userdata_time'),
    ]

    operations = [
        migrations.AlterField(
            model_name='userdata',
            name='time',
            field=models.CharField(blank=True, default=None, max_length=100, null=True),
        ),
    ]