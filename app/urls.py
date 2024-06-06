from django.urls import path
from . import views
from app import views
from . import views



urlpatterns = [
    path('uuid/', views.ObtainAuthTokenView.as_view(), name='obtain-auth-token'),
    path('api/insert_user_data/', views.InsertUserData.as_view(), name='insert_user_data'),
    path('api/insert_initial_user_data/', views.InsertInitialUserData.as_view(), name='insert_initial_user_data'),    #fail (user_id)
    path('api/user_status/', views.UserStatus.as_view(), name='user_status'),                  
    path('api/update_initial_user_data/', views.UpdateInitialUserData.as_view(), name='update_initial_user_data'),    #success (user_id) 
]





# http://localhost:8000/api/insert_initial_user_data/
# http://localhost:8000/api/user_status/