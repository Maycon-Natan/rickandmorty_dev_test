import 'package:teste_tecnico_fteam/app_widget.dart';
import 'package:teste_tecnico_fteam/src/core/DI/dependency_injector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'pt_BR';

  setupDependencyInjector();
  runApp(const AppWidget());
}
