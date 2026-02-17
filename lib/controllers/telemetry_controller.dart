import 'dart:async';
import 'package:flutter/material.dart';
import '../models/telemetry_message.dart';
import '../core/app_socket.dart';

class PageState<T> {
  final T? data;
  final DateTime? lastUpdated;

  const PageState({
    required this.data,
    required this.lastUpdated,
  });

  bool isStale(Duration timeout) {
    if (lastUpdated == null) return true;
    return DateTime.now().difference(lastUpdated!) > timeout;
  }
}

class TelemetryController extends ChangeNotifier {
  final Map<PageType, PageState<Object>> _pages = {};

  Map<PageType, PageState<Object>> get pages => _pages;

  static const Duration _timeout = Duration(seconds: 2);

  late final StreamSubscription _socketSub;

  void start(String url) {
    AppSocket().connect(url);

    _socketSub = AppSocket().stream.listen((raw) {
      final trimmed = raw.trim();

      if (trimmed.isEmpty) return;
      if (!trimmed.startsWith('{')) return;

      try {
        final message = TelemetryMessage.fromRaw(trimmed);

        _pages[message.pageType] = PageState(
          data: message.data,
          lastUpdated: DateTime.now(),
        );

        notifyListeners();
      } catch (_) {}
    });
  }

  bool isPageStale(PageType type) {
    final state = _pages[type];
    if (state == null) return true;
    return state.isStale(_timeout);
  }

  T? getData<T>(PageType type) {
    final state = _pages[type];

    if (state == null) return null;

    if (state.isStale(_timeout)) {
      return null;
    }

    return state.data as T?;
  }

  @override
  void dispose() {
    _socketSub.cancel();
    super.dispose();
  }
}