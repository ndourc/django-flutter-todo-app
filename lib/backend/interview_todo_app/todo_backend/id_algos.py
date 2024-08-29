import random, string

alphanumeric_chars = string.ascii_uppercase + string.digits

def generate_task_id():
    special_chars = ['T', 'O', 'D', 'O']
    task_id_array = [None] * 7
    i = 0
    while i < 7:
        if i % 3 == 0 and i < 7:
            task_id_array[i] = random.choice(special_chars)
        else:
            task_id_array[i] = random.choice(alphanumeric_chars)
        i += 1

    return ''.join(task_id_array)