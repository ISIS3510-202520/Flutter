import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view/auth/auth_view.dart';
import 'package:here4u/mvvm/ui/view/home/home_view.dart';
import 'package:here4u/mvvm/ui/view_model/home_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/journaling_view_model.dart';
import 'package:provider/provider.dart';

class JournalingView extends StatelessWidget {
  const JournalingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _JournalingContent();
  }
}

class _JournalingContent extends StatefulWidget {
  const _JournalingContent();

  @override
  State<_JournalingContent> createState() => _JournalingContentState();
}

class _JournalingContentState extends State<_JournalingContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                      text: viewModel.emotion.name,
                      style: TextStyle(
                        color: viewModel.emotion.color,
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
                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 2.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        if (_controller.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please write something before saving!",
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        // Store context references before async call
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);

                        final success = await viewModel.saveJournal(
                          _controller.text.trim(),
                        );

                        if (success && mounted) {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text("Entry added to journal!"),
                              backgroundColor: Colors.green,
                            ),
                          );

                          _controller.clear();

                          navigator.pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) => HomeViewModel(),
                                child: const HomeView(),
                              ),
                            ),
                          );
                        } else if (mounted) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                viewModel.errorMessage ??
                                    "Failed to save journal entry",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF86D9F0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: viewModel.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black,
                          ),
                        ),
                      )
                    : const Text(
                        "Add to Journal",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
