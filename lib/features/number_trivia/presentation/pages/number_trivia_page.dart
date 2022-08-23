import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_learn/injection_container.dart';

import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: _buildBody(context),
    ));
  }

  BlocProvider<NumberTriviaBloc> _buildBody(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(msg: 'Start Searching');
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                      numberTrivia: state.trivia,
                    );
                  } else if (state is Error) {
                    return MessageDisplay(msg: state.message);
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: const Placeholder(),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                TriviaControls()
              ],
            ),
          ),
        ));
  }
}
