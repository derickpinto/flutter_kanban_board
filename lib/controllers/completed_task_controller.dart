import 'package:get/get.dart';
import '../constants/app_string.dart';
import '../models/task.dart';
import '../service_injection.dart';
import '../services/task_service.dart';
import '../utils/helper_functions.dart';

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

        completedTasks.value = apiTasks
            .map(
              (apiTask) => Task(
                id: apiTask['id'].toString(),
                title: apiTask['content'],
                status: getStatus(apiTask['section_id']),
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
}
