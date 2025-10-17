import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:here4u/models/emotion.dart';
import 'package:here4u/mvvm/ui/view/journaling/journaling_view.dart';
import 'package:here4u/mvvm/ui/view_model/auth_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/identify_emotions_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/journaling_view_model.dart';
import 'package:provider/provider.dart';

class IdentifyEmotionsView extends StatefulWidget {
  const IdentifyEmotionsView({super.key});

  @override
  State<IdentifyEmotionsView> createState() => _IdentifyEmotionsViewState();
}

class _IdentifyEmotionsViewState extends State<IdentifyEmotionsView> with WidgetsBindingObserver {
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTime = DateTime.now();
    debugPrint("[IdentifyEmotionsView] logging screen view");
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'IdentifyEmotionsView',
      screenClass: 'IdentifyEmotionsView',
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final engagementTime = DateTime.now().difference(_startTime).inMilliseconds;
    debugPrint('[IdentifyEmotionsView] User engagement time: $engagementTime ms');
    FirebaseAnalytics.instance.logEvent(
      name: 'identify_emotions_engagement',
      parameters: {
        'screen_name': 'IdentifyEmotionsView',
        'engagement_time_msec': engagementTime,
      },
    );
    super.dispose();
  }

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
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 30,
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
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => JournalingViewModel(
                          emotion: viewModel.selectedEmotion!,
                          authViewModel: context.read<AuthViewModel>(),
                        ),
                        child: const JournalingView(),
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
    List<Emotion> emotions,
    IdentifyEmotionsViewModel viewModel,
  ) {
    const double circleSize = 120;

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
