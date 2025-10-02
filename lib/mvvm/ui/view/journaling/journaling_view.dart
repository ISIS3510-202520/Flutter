import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view_model/journaling_view_model.dart';
import 'package:here4u/models/emotion.dart';
import 'package:provider/provider.dart';

class JournalingView extends StatelessWidget {
  final Emotion emotion;

  const JournalingView({super.key, required this.emotion});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JournalingViewModel(emotion.name),
      child: _JournalingContent(emotion: emotion),
    );
  }
}

class _JournalingContent extends StatefulWidget {
  final Emotion emotion;

  const _JournalingContent({required this.emotion});

  @override
  State<_JournalingContent> createState() => _JournalingContentState();
}

class _JournalingContentState extends State<_JournalingContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<JournalingViewModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Describe what makes you feel '),
                    TextSpan(
                      text: widget.emotion.name, // <-- emotion name
                      style: TextStyle(
                        color: widget.emotion.color, // <-- emotion color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Write your thoughts here...",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 2.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  viewModel.addToJournal(_controller.text);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Entry added to journal!"),
                    ),
                  );

                  _controller.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF86D9F0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add to Journal",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
