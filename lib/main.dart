import 'package:firebase_core/firebase_core.dart';
import 'package:first_todo_app/firebase_options.dart';
import 'package:first_todo_app/src/app.dart';
import 'package:first_todo_app/src/core/service_locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ServiceManager.setupServices();

  runApp(const MyApp());
}
