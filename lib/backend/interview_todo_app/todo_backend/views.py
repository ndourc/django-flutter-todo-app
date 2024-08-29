from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Task
from .serializers import TaskSerializer

@api_view(['GET'])
def getRoutes(request):
    routes = [
        {
            'Endpoint': '/todo_app',
            'method': 'GET',
            'body': None,
            'description': 'Returns array of tasks'
        },
        {
            'Endpoint': '/todo_app/id',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single task object'
        },
        {
            'Endpoint': '/todo_app/create',
            'method': 'POST',
            'body': {'body': ""},
            'description': 'Creates a new task object'
        },
        {
            'Endpoint': '/todo_app/id/update',
            'method': 'PUT',
            'body': {'body': ""},
            'description': 'Updates an existing task object'
        },
        {
            'Endpoint': '/todo_app/id/delete',
            'method': 'DELETE',
            'body': {'body': ""},
            'description': 'Creates a new task object'
        },
    ]
    return Response(routes)


@api_view(['POST'])
def add_task(request):
    data = request.data
    task = Task.objects.create(
        title=data.get('title'),
        body=data.get('body'),
        task_status=data.get('task_status', False)  # Ensure you use the correct key
    )
    serializer = TaskSerializer(task, many=False)
    return Response(serializer.data, status=status.HTTP_201_CREATED)



@api_view(['GET'])
def get_tasks(request):
    tasks = Task.objects.all()
    serializer = TaskSerializer(tasks, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def get_single_task(request, pk):
    task = Task.objects.get(id=pk)
    serializer = TaskSerializer(task, many=False)
    return Response(serializer.data)


@api_view(['PUT'])
def update_task(request, pk):
    data = request.data
    task = Task.objects.get(id=pk)
    serializer = TaskSerializer(task, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    
@api_view(['PUT'])
def update_task_status(request, pk):
    try:
        task = Task.objects.get(id=pk)
        task_status = request.data.get('task_status')
        
        if task_status is None:
            return Response({'error': 'Task status not provided'}, status=status.HTTP_400_BAD_REQUEST)
        
        task.task_status = task_status
        task.save()
        serializer = TaskSerializer(task, many=False)
        return Response(serializer.data, status=status.HTTP_200_OK)

    except Task.DoesNotExist:
        return Response({'error': 'Task not found'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        print(f"Error updating task status: {str(e)}")  # Log the error for debugging
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['DELETE'])
def delete_task(request, pk):
    try:
        task = Task.objects.get(id=pk)
        task.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    except Task.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)