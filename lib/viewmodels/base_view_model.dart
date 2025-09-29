import 'package:flutter/foundation.dart';

/// Base class for all view models
/// Provides common functionality for change notification
class BaseViewModel extends ChangeNotifier {
  /// Indicates if the view model is currently busy (loading, processing, etc.)
  bool _isBusy = false;
  bool get isBusy => _isBusy;

  /// Sets the busy state and notifies listeners
  void setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  /// Sets the busy state to true, executes the provided function,
  /// and then sets the busy state to false when complete
  Future<T> busy<T>(Future<T> Function() function) async {
    setBusy(true);
    try {
      final result = await function();
      return result;
    } finally {
      setBusy(false);
    }
  }
}
