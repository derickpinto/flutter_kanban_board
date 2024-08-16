import 'package:dio/dio.dart';
import '../network/api_config.dart';
import '../network/api_services.dart';

class TodoistApiService {
  final DioService dioService;

  TodoistApiService(this.dioService);

  Future<Response<dynamic>> fetchTasks() async {
    return await dioService.get('${BaseUrl.restBaseUrl}/tasks');
  }

  Future<Response<dynamic>> updateTask(
      String taskId, Map<String, dynamic> updates) async {
    return await dioService.post(
      '${BaseUrl.restBaseUrl}/tasks/$taskId',
      data: updates,
    );
  }

  Future<Response<dynamic>> addTask(
      {required Map<String, dynamic> payload}) async {
    return await dioService.post('${BaseUrl.restBaseUrl}/tasks', data: payload);
  }

  Future<Response<dynamic>> deleteTask(String taskId) async {
    return await dioService.delete('${BaseUrl.restBaseUrl}/tasks/$taskId');
  }

  Future<Response<dynamic>> updateSection(
      String taskId, Map<String, dynamic> updates) async {
    return await dioService.post('${BaseUrl.syncBaseUrl}/sync', data: updates);
  }

  Future<Response<dynamic>> getComments(String taskId) async {
    return await dioService.get(
      '${BaseUrl.restBaseUrl}/comments?task_id=$taskId',
    );
  }

  Future<Response<dynamic>> addComment(Map<String, dynamic> payload) async {
    return await dioService.post(
      '${BaseUrl.restBaseUrl}/comments',
      data: payload,
    );
  }

  Future<Response<dynamic>> completeTask(Map<String, dynamic> payload) async {
    return await dioService.post(
      '${BaseUrl.syncBaseUrl}/sync',
      data: payload,
    );
  }

  Future<Response<dynamic>> getAllCompleteTasks(String projectId) async {
    return await dioService.get(
      '${BaseUrl.syncBaseUrl}/completed/get_all?project_id=$projectId',
    );
  }
}
