import 'package:flutter_riverpod/flutter_riverpod.dart';

final errorControllerProvider =
    StateNotifierProvider<ErrorController, String?>((ref) {
  return ErrorController();
});

class ErrorController extends StateNotifier<String?> {
  ErrorController() : super(null);
  void getError(String errorMessage) {
    state = errorMessage;
  }
}
