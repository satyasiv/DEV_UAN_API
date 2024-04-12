from django.urls import path
from . import views
from app import views


urlpatterns = [
    path('uuid/', views.ObtainAuthTokenView.as_view(), name='obtain-auth-token'),
    path('api/insert_user_data/', views.InsertUserData.as_view(), name='insert_user_data'),
]



