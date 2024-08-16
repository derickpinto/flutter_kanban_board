import 'package:flutter/material.dart';
import 'my_app.dart';
import 'service_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(MyApp());
}
