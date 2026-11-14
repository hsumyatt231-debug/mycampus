import 'package:flutter/material.dart';

import 'services/app_dependencies.dart';
import 'ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await AppDependencies.create();
  runApp(MyCampusApp(dependencies: dependencies));
}
