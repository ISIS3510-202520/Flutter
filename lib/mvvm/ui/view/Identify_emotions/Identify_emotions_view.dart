import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view_model/Identify_emotions_view_model.dart';
import 'package:provider/provider.dart';

class IdentifyEmotionsView extends StatelessWidget {
  const IdentifyEmotionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<IdentifyEmotionsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Identify Emotions"),
      ),
      body: Center(
        child: Text(
          "This is the Identify Emotions View",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example of using the view model
          if (viewModel.confirmSelection()) {
            Navigator.pushNamed(
              context,
              "/next",
              arguments: viewModel.selectedEmotion,
            );
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
