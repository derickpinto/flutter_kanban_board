import 'package:get/get.dart';
import '../constants/app_string.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../utils/helper_functions.dart';

class CommentController extends GetxController {
  final TodoistApiService apiService;
  final Task currentTask;
  RxList<Comment> comments = <Comment>[].obs;

  CommentController(this.apiService, this.currentTask);

  @override
  void onInit() {
    super.onInit();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final response = await apiService.getComments(currentTask.id);

      if (response.statusCode == 200) {
        final apiTasks = List<Map<String, dynamic>>.from(response.data);

        comments.value = apiTasks
            .map(
              (apiTask) => Comment.fromJson(apiTask),
            )
            .toList();
      } else {
        // Handle non-200 response codes
        throw Exception(
            'Failed to fetch tasks, status code: ${response.statusCode}');
      }
    } catch (e) {
      showToast("Something went wrong");
    }
  }


  Future<void> addComment(String commentText) async {
    try {
      final payload = {
        "task_id": currentTask.id,
        "content": commentText
      };

      final response = await apiService.addComment(payload);

      if (response.statusCode == 200) {
        Comment newComment = Comment.fromJson(response.data);

        comments.add(newComment);
      } else {
        // Handle non-200 response codes
        throw Exception(
            'Failed to fetch tasks, status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors and update UI accordingly
      showToast(AppString.warning);
    }
  }
}
