import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_string.dart';
import '../models/task.dart';
import '../service_injection.dart';
import '../services/task_service.dart';
import '../utils/helper_functions.dart';

class TaskController extends GetxController {
  final TodoistApiService apiService;
  var tasks = <Task>[].obs;

  TaskController(this.apiService);

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      final response = await apiService.fetchTasks();

      if (response.statusCode == 200) {
        final apiTasks = List<Map<String, dynamic>>.from(response.data);

        tasks.value = apiTasks
            .map(
              (apiTask) => Task(
                id: apiTask['id'].toString(),
                title: apiTask['content'],
                description: apiTask["description"],
                status: getStatus(apiTask['section_id']),
                creationTime: DateTime.parse(apiTask['created_at']),
                timeSpentInStatus: {},
                // Initialize as needed
                labels: List<String>.from(apiTask['labels'] ?? []),
              ),
            )
            .toList();
      } else {
        throw Exception(
            'Failed to fetch tasks, status code: ${response.statusCode}');
      }
    } catch (e) {
      showToast(AppString.warning);
    }
  }

  Future<bool> addTask(Task task) async {
    try {
      final payload = {
        'content': task.title,
        'description': task.description,
        'project_id': getIt.get<String>(instanceName: "projectId"),
        'section_id': getStatus("To Do", getId: true),
      };
      final response = await apiService.addTask(payload: payload);

      if (response.statusCode == 200) {
        task.updateId(response.data["id"]);
        task.updateCreatedDate(response.data["created_at"]);
        tasks.add(task);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String?> updateTask(Task task, String newStatus) async {
    try {
      final updates = {
        'section_id': getStatus(newStatus, getId: true),
        'project_id': getIt.get<String>(instanceName: "projectId"),
        'content': task.title,
        'description': task.description,
      };

      final response = await apiService.updateTask(task.id, updates);

      if (response.statusCode == 200) {
        task.updateStatus(newStatus);
        final index = tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          tasks[index] = task;
        }
        return null;
      } else {
        return "Something went wrong!";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteTask(Task task) async {
    try {
      final response = await apiService.deleteTask(task.id);

      if (response.statusCode == 200 || response.statusCode == 204) {
        tasks.removeWhere((t) => t.id == task.id);
        return null;
      } else {
        return "Something went wrong! Status code: ${response.statusCode}";
      }
    } catch (e) {
      return "Failed to delete task: ${e.toString()}";
    }
  }

  Future<String?> updateSection(Task task, String newStatus) async {
    try {
      final uuid = const Uuid().v4();

      final updates = {
        'commands': [
          {
            'type': 'item_move',
            'uuid': uuid,
            'args': {
              'id': task.id,
              'section_id': getStatus(newStatus, getId: true),
            },
          },
        ],
      };

      final response = await apiService.updateSection(task.id, updates);

      if (response.statusCode == 200) {
        task.updateStatus(newStatus);
        final index = tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          tasks[index] = task;
        }
        return null;
      } else {
        return "Something went wrong!";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateTime(Task task, List labels) async {
    try {
      final updates = {
        'project_id': getProjectId(),
        'labels': labels,
      };

      final response = await apiService.updateTask(task.id, updates);

      if (response.statusCode == 200) {
        task.updateLabels(labels);
        final index = tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          tasks[index] = task;
        }
        return null;
      } else {
        return "Something went wrong!";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> completeTask(Task task) async {
    try {
      final uuid = const Uuid().v4();

      final updates = {
        "commands": [
          {
            "type": "item_complete",
            "uuid": uuid,
            "args": {"id": task.id}
          }
        ]
      };

      final response = await apiService.completeTask(updates);

      if (response.statusCode == 200) {
        tasks.removeWhere((t) => t.id == task.id);
        return null;
      } else {
        return "Something went wrong!";
      }
    } catch (e) {
      return e.toString();
    }
  }

  void startTaskTimer(Task task) {
    List labels = task.labels.isEmpty
        ? ["00:00:00", DateTime.now().toString()]
        : [task.labels[0], DateTime.now().toString()];

    updateTime(task, labels);
  }

  void stopTaskTimer(Task task) {
    if (task.labels.length < 2) return;

    final labels = List<String>.from(task.labels);
    final startTime = DateTime.parse(labels[1]);
    final timeSpent = DateTime.now().difference(startTime);

    final totalDuration = task.stringToDuration(labels[0]) + timeSpent;
    labels[0] = task.durationToString(totalDuration);
    labels[1] = "STOPPED";

    updateTime(task, labels);
  }

  bool isIndexPresent(List labels, int index) {
    return index >= 0 && index < labels.length;
  }

  String getProjectId() {
    return const String.fromEnvironment("PROJECT_ID");
  }

  Task getTaskById(String id) {
    final task = tasks.firstWhere((task) => task.id == id,
        orElse: () => Task(id: id, title: '', status: ''));
    return task;
  }

  int getTaskCountOfSection(section) {
    return tasks.where((task) => task.status == section).length;
  }
}
