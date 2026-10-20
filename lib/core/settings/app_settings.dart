import 'package:flutter/foundation.dart';

/// Device-level preferences: notifications, motion and the demo phone
/// frame.
///
/// Demo: kept in memory. Real version: saved with `shared_preferences`.
class AppSettings extends ChangeNotifier {
  bool _reduceMotion = false;
  bool _phoneFrame = true;
  bool _locationAllowed = false;
  bool _notificationsAllowed = false;
  bool _shareStats = true;
  final Map<NotificationType, bool> _notifications = {
    for (final type in NotificationType.values) type: true,
  };

  bool get reduceMotion => _reduceMotion;
  bool get phoneFrame => _phoneFrame;
  bool get locationAllowed => _locationAllowed;
  bool get notificationsAllowed => _notificationsAllowed;
  bool get shareStats => _shareStats;
  bool notification(NotificationType type) => _notifications[type] ?? false;

  set reduceMotion(bool value) => _update(() => _reduceMotion = value);
  set phoneFrame(bool value) => _update(() => _phoneFrame = value);
  set locationAllowed(bool value) => _update(() => _locationAllowed = value);
  set notificationsAllowed(bool value) =>
      _update(() => _notificationsAllowed = value);
  set shareStats(bool value) => _update(() => _shareStats = value);

  void setNotification(NotificationType type, bool value) =>
      _update(() => _notifications[type] = value);

  /// Demo reset: back to defaults, but keep the phone frame the presenter
  /// chose.
  void resetForDemo() => _update(() {
        _reduceMotion = false;
        _locationAllowed = false;
        _notificationsAllowed = false;
        _shareStats = true;
        for (final type in NotificationType.values) {
          _notifications[type] = true;
        }
      });

  void _update(VoidCallback change) {
    change();
    notifyListeners();
  }
}

enum NotificationType { kickOff, streak, newGames, results }
