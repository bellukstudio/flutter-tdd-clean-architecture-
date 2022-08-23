import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_learn/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_tdd_learn/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
          primaryColor: Colors.green[800],
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.green.shade600)),
      home: NumberTriviaPage(),
    );
  }
}
