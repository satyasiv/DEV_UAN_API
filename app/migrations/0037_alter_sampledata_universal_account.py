# Generated by Django 5.0.4 on 2024-05-06 09:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0036_alter_sampledata_universal_account'),
    ]

    operations = [
        migrations.AlterField(
            model_name='sampledata',
            name='Universal_Account',
            field=models.BigIntegerField(blank=True, default=None),
        ),
    ]