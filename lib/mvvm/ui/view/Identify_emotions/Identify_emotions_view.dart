import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view_model/Identify_emotions_view_model.dart';
import 'package:provider/provider.dart';

class IdentifyEmotionsView extends StatelessWidget {
  const IdentifyEmotionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<IdentifyEmotionsViewModel>();
    final emotions = viewModel.emotions;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Identify Emotions"),
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          physics: const ClampingScrollPhysics(),
          overscroll: false,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Wrap(
              spacing: 50,
              runSpacing: 50,
              children: _buildEmotionCircles(emotions, viewModel),
            ),
          ),
        ),
      ),
      floatingActionButton: viewModel.selectedEmotion != null
          ? FloatingActionButton(
              backgroundColor: Color(0xFF7C8FBB),
              onPressed: () {
                if (viewModel.confirmSelection()) {
                  Navigator.pushNamed(
                    context,
                    "/next",
                    arguments: viewModel.selectedEmotion,
                  );
                }
              },
              child: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }

  List<Widget> _buildEmotionCircles(
    List<String> emotions,
    IdentifyEmotionsViewModel viewModel,
  ) {
    const double circleSize = 130;

    return emotions.map((emotion) {
      final isSelected = viewModel.selectedEmotion == emotion;

      return GestureDetector(
        onTap: () {
          viewModel.selectEmotion(emotion);
          print("Selected: $emotion");
        },
        child: Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF86D9F0),
            border: Border.all(
              color: isSelected ? const Color(0xFF7C8FBB) : Color(0xFF8CC0CF),
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              emotion,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }).toList();
  }
}
