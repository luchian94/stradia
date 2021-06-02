import 'package:stacked/stacked.dart';
import 'package:stradia/locator.dart';
import 'package:stradia/services/capture.service.dart';

class CaptureCounterModel extends ReactiveViewModel{
  final CaptureService _captureService = locator<CaptureService>();

  int get captureCount => _captureService.captureCount;
  int get failedCapturesCount => _captureService.failedCapturesCount;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_captureService];

}
