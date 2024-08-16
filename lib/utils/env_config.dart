class EnvConfig {
  static const String authToken = String.fromEnvironment('TODOIST_TOKEN', defaultValue: '');
  static const String projectId = String.fromEnvironment('PROJECT_ID', defaultValue: '');
}
