import 'package:flutter/foundation.dart';

class OnlineSearchActivity {
  final String query;
  final String provider;
  final int resultCount;
  final bool demoMode;
  final DateTime searchedAt;

  const OnlineSearchActivity({
    required this.query,
    required this.provider,
    required this.resultCount,
    required this.demoMode,
    required this.searchedAt,
  });
}

class OnlineSearchActivityService extends ChangeNotifier {
  OnlineSearchActivityService._();

  static final OnlineSearchActivityService instance = OnlineSearchActivityService._();

  final List<OnlineSearchActivity> _recentSearches = <OnlineSearchActivity>[];

  List<OnlineSearchActivity> get recentSearches => List.unmodifiable(_recentSearches);

  void recordSearch({
    required String query,
    required String provider,
    required int resultCount,
    required bool demoMode,
  }) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    _recentSearches.removeWhere(
      (entry) => entry.query.toLowerCase() == trimmed.toLowerCase() && entry.provider == provider,
    );

    _recentSearches.insert(
      0,
      OnlineSearchActivity(
        query: trimmed,
        provider: provider,
        resultCount: resultCount,
        demoMode: demoMode,
        searchedAt: DateTime.now(),
      ),
    );

    if (_recentSearches.length > 12) {
      _recentSearches.removeRange(12, _recentSearches.length);
    }

    notifyListeners();
  }
}
