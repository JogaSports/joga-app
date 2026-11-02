import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

// Shared helpers for the Supabase repositories: database names <-> app
// enums, rows -> models, and backend errors -> messages the screens show.

/// Fires when data changes, so open screens reload ([AppServices.changes]).
class DbChanges extends ChangeNotifier {
  void changed() => notifyListeners();
}

// ---- Names ------------------------------------------------------------------

/// `five_a_side` -> `fiveASide`
String _camel(String snake) {
  final parts = snake.split('_');
  return parts.first +
      parts.skip(1).map((p) => p.isEmpty ? p : p[0].toUpperCase() + p.substring(1)).join();
}

/// `fiveASide` -> `five_a_side`. Use for every enum sent to the database.
String dbName(Enum value) => value.name.replaceAllMapped(
      RegExp('[A-Z]'),
      (m) => '_${m[0]!.toLowerCase()}',
    );

/// The enum value whose [dbName] is [value], or null.
T? fromDb<T extends Enum>(List<T> values, Object? value) {
  if (value is! String) return null;
  final name = _camel(value);
  for (final v in values) {
    if (v.name == name) return v;
  }
  return null;
}

/// A list of database enum strings -> enum values, skipping unknown ones.
List<T> listFromDb<T extends Enum>(List<T> values, Object? raw) => [
      for (final item in (raw as List<dynamic>?) ?? const [])
        if (fromDb(values, item) case final T v) v,
    ];

DateTime parseTime(Object? value) => DateTime.parse(value! as String);

int asInt(Object? value) => switch (value) {
      final int i => i,
      final num n => n.round(),
      final String s => num.tryParse(s)?.round() ?? 0,
      _ => 0,
    };

/// An RPC that returns a table gives a list; one that returns a single
/// composite value gives a map. This returns the first row either way.
Map<String, dynamic>? firstRow(Object? result) => switch (result) {
      final List<dynamic> rows when rows.isNotEmpty =>
        rows.first as Map<String, dynamic>,
      final Map<String, dynamic> row => row,
      _ => null,
    };

List<Map<String, dynamic>> rows(Object? result) => [
      for (final r in (result as List<dynamic>?) ?? const [])
        r as Map<String, dynamic>,
    ];

// ---- Errors -----------------------------------------------------------------

/// Runs [action] and turns backend errors into a [StateError] carrying a
/// sentence the player can read. Screens already show `StateError.message`
/// (checkout, full-screen errors), so nothing else needs to change.
Future<T> guard<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on PostgrestException catch (e) {
    throw StateError(_postgrestMessage(e));
  } on AuthException catch (e) {
    throw StateError(e.message);
  } on TimeoutException {
    throw StateError(_offline);
  } catch (e) {
    if (e is StateError || e is AuthFailure) rethrow;
    if ('$e'.contains('SocketException') || '$e'.contains('ClientException')) {
      throw StateError(_offline);
    }
    rethrow;
  }
}

const _offline = 'No connection. Check your internet and try again.';

/// Database functions raise a stable code as the message and a human
/// sentence as the detail (see joga-backend docs/API.md).
String _postgrestMessage(PostgrestException e) {
  final details = e.details;
  if (details is String && details.trim().isNotEmpty) return details;
  return switch (e.message) {
    'not_authenticated' => 'Please sign in again.',
    'admins_only' => 'Admins only.',
    _ => 'Something went wrong. Please try again.',
  };
}

/// The backend's error code (e.g. `game_full`), if [error] carries one.
String? backendCode(Object error) =>
    error is PostgrestException ? error.message : null;
