from django.db import models
from .id_algos import generate_task_id


class Task(models.Model):
    id = models.CharField(primary_key=True, max_length=7, editable=False, default=generate_task_id)
    title = models.CharField(max_length=100)
    body = models.TextField()
    task_status = models.BooleanField(default=False)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-updated']