import 'package:flutter/material.dart';
import 'package:flutter_tdd_learn/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({Key? key}) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final inputController = TextEditingController();
  late String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: inputController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            addConcrete();
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: addConcrete,
                child: const Text('Search'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey.shade500,
                ),
                onPressed: addRandom,
                child: const Text('Get random trivia'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void addConcrete() {
    inputController.clear();
    context.read<NumberTriviaBloc>().add(GetTriviaForConcreteNumber(inputStr));
  }

  void addRandom() {
    inputController.clear();
    context.read<NumberTriviaBloc>().add(GetTriviaForRandomNumber());
  }
}
