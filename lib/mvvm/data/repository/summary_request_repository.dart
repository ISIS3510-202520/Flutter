import 'package:here4u/models/summary_request.dart';
import 'package:here4u/mvvm/data/services/summary_request_service.dart';

/// Repository: orquesta al service y deja la UI desacoplada.
class SummaryRequestRepository {
  final SummaryRequestService _service;

  SummaryRequestRepository(this._service);

  Future<SummaryRequest> generateFromRequest(SummaryRequest request) {
    return _service.generateFromRequest(request);
  }

  Future<SummaryRequest> generateLocalDemo() {
    return _service.generateLocalDemo();
  }
}
