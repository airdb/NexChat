import '../system/runtime.dart';


Future<void> checkFirstRun() async {
  final isFirstRun = await AppRuntime.isFirstRun();

  if (isFirstRun) {
    // Todo: execute first run logic
    // ...

    // Update flag to false, indicating it's no longer the first run
    await prefs.setBool('is_first_run', false);
  } else {
    // Todo: execute normal (non-first) run logic
    // ...
  }
}