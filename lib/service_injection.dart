import 'package:get_it/get_it.dart';

import 'controllers/completed_task_controller.dart';
import 'controllers/task_controller.dart';
import 'network/api_services.dart';
import 'services/task_service.dart';
import 'utils/env_config.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<String>(EnvConfig.authToken,
      instanceName: 'authToken');
  getIt.registerSingleton<String>(EnvConfig.projectId,
      instanceName: 'projectId');

  getIt.registerLazySingleton<DioService>(
    () => DioService(
      getIt.get(instanceName: 'authToken'),
    ),
  );
  getIt.registerLazySingleton<TodoistApiService>(
    () => TodoistApiService(
      getIt<DioService>(),
    ),
  );

  getIt.registerLazySingleton<TaskController>(
    () => TaskController(
      getIt<TodoistApiService>(),
    ),
  );
  getIt.registerLazySingleton<CompletedTasksController>(
    () => CompletedTasksController(
      apiService: getIt<TodoistApiService>(),
    ),
  );
}
