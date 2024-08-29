from django.urls import include, path
from . import views

urlpatterns = [
    path('', views.getRoutes),

    path('tasks/add-task/', views.add_task),
    path('tasks/', views.get_tasks),
    path('tasks/<str:pk>/', views.get_single_task),
    path('tasks/<str:pk>/update/', views.update_task),
    path('tasks/<str:pk>/update-task-status/', views.update_task_status),
    path('tasks/<str:pk>/delete/', views.delete_task),
]
