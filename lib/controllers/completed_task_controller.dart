import 'package:get/get.dart';
import 'package:kanban_board/utils/helper_functions.dart';
import '../models/task.dart';
import '../service_injection.dart';
import '../services/task_service.dart';

class CompletedTasksController extends GetxController {
  final TodoistApiService apiService;
  RxList<Task> completedTasks = <Task>[].obs;

  CompletedTasksController({required this.apiService});

  @override
  void onInit() {
    super.onInit();
    fetchCompletedTasks();
  }

  void fetchCompletedTasks() async {
    try {
      final response = await apiService
          .getAllCompleteTasks(getIt.get<String>(instanceName: "projectId"));

      if (response.statusCode == 200) {
        final apiTasks =
            List<Map<String, dynamic>>.from(response.data["items"]);

        List<String> ids = [];
        completedTasks.value = apiTasks.map(
          (apiTask) {
            Task data = Task(
              id: apiTask['id'].toString(),
              title: apiTask['content'],
              status: getStatus(apiTask['section_id']),
            );
            ids.add(data.id);
            return Task(
              id: apiTask['id'].toString(),
              title: apiTask['content'],
              status: getStatus(apiTask['section_id']),
            );
          },
        ).toList();
        print(ids);
      } else {
        throw Exception(
            'Failed to fetch tasks, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }
}
