import 'package:flutter/material.dart';
import 'package:here4u/mvvm/data/repository/summary_request.dart';

class SummaryViewModel extends ChangeNotifier {
  final SummaryRequestRepository _repo;

  SummaryViewModel({SummaryRequestRepository? repository})
      : _repo = repository ?? SummaryRequestRepository();

  // Estado mostrado en la UI (placeholders iniciales)
  String commonFeeling = 'insert most common feeling this week';
  String highlights = '[insert highlights]';
  String insights = '[insert AI insights]';

  Future<void> init() async {
    // Por ahora demo local; luego podrás pasar fechas reales
    final demo = await _repo.generateLocalDemo();
    commonFeeling = demo.commonFeeling;
    highlights = demo.highlights;
    insights = demo.insights;
    notifyListeners();
  }

  void onTapBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
