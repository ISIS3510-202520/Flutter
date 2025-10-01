import 'package:flutter/material.dart';
import 'package:here4u/models/emotion_entity.dart';
import 'package:here4u/mvvm/ui/view/journaling/journaling_view.dart';
import 'package:here4u/mvvm/ui/view_model/identify_emotions_view_model.dart';
import 'package:provider/provider.dart';

class IdentifyEmotionsView extends StatelessWidget {
  const IdentifyEmotionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<IdentifyEmotionsViewModel>();
    final emotions = viewModel.emotions;

    return Scaffold(
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
              backgroundColor: const Color(0xFF7C8FBB),
              onPressed: () {
                if (viewModel.confirmSelection()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalingView(
                        emotion: viewModel.selectedEmotion!,
                      ),
                    ),
                  );
                }
              },
              child: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }

  List<Widget> _buildEmotionCircles(
    List<EmotionEntity> emotions,
    IdentifyEmotionsViewModel viewModel,
  ) {
    const double circleSize = 130;

    return emotions.map((emotion) {
      final isSelected = viewModel.selectedEmotion == emotion;

      return GestureDetector(
        onTap: () {
          viewModel.selectEmotion(emotion);
        },
        child: Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: emotion.color, // dynamic background color
            border: Border.all(
              color: isSelected ? const Color(0xFF7C8FBB) : Colors.grey,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              emotion.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // ensures readability
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
