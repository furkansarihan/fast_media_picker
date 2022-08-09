import 'dart:io';

import 'package:fast_media_picker/fast_media_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      scaffoldMessengerKey: _messangerKey,
      title: 'fast_media_picker',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          onPrimary: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          onPrimary: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('fast_media_picker'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  final result = await FastMediaPicker.pick(
                    _navigatorKey.currentContext!,
                    configs: const FastMediaPickerConfigs(
                      type: RequestType.image,
                      pickLimit: 1,
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                    ),
                  );
                  if (result == null) return;
                  _messangerKey.currentState!.showSnackBar(
                    SnackBar(
                      content: Text(result.toString()),
                    ),
                  );
                },
                child: const Text('Push picker - modal sheet'),
              ),
              TextButton(
                onPressed: () async {
                  final result = await FastMediaPicker.pick(
                    _navigatorKey.currentContext!,
                    configs: const FastMediaPickerConfigs(
                      type: RequestType.image,
                      pickLimit: 1,
                      crossAxisCount: 3,
                      childAspectRatio: 9 / 16,
                    ),
                  );
                  if (result == null) return;
                  _messangerKey.currentState!.showSnackBar(
                    SnackBar(
                      content: Text(result.toString()),
                    ),
                  );
                },
                child: const Text('Push picker - story sheet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
