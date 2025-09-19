import 'package:flutter/foundation.dart';

class JournalingViewModel extends ChangeNotifier {
  final String emotion;

  JournalingViewModel(this.emotion);

  String? _journalText;
  String? get journalText => _journalText;

  void addToJournal(String text) {
    if (text.trim().isEmpty) return;

    _journalText = text;


    notifyListeners();
  }
}
