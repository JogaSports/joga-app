import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../repositories/booking_repository.dart';
import 'db.dart';

/// Booking through the database functions: quote, hold a space for five
/// minutes, confirm, cancel, waitlist.
///
/// Card payments aren't switched on yet, so a booking goes through when
/// wallet credit covers it (staging accounts get £20 test credit). The
/// wallet holds pounds, so that's UK games only for now.
class SupabaseBookingRepository implements BookingRepository {
  SupabaseBookingRepository(this._client, this._changes);

  final SupabaseClient _client;
  final DbChanges _changes;

  @override
  Future<BookingQuote> quote(String gameId) => guard(() => _quote(gameId, useWallet: true));

  Future<BookingQuote> _quote(String gameId, {required bool useWallet}) async {
    final results = await Future.wait<dynamic>([
      _client.rpc<dynamic>('booking_quote', params: {'p_game': gameId, 'p_use_wallet': useWallet}),
      _client.from('game_listing').select('currency').eq('id', gameId).maybeSingle(),
    ]);
    final q = firstRow(results[0]);
    if (q == null) throw StateError('This game no longer exists.');
    final currencyCode = (results[1] as Map<String, dynamic>?)?['currency'];
    return BookingQuote(
      gamePence: asInt(q['game_pence']),
      feePence: asInt(q['fee_pence']),
      walletAvailablePence: asInt(q['wallet_available_pence']),
      isMember: q['is_member'] == true,
      currency: Currency.values.firstWhere(
        (c) => c.code == currencyCode,
        orElse: () => Currency.gbp,
      ),
    );
  }

  @override
  Future<SpaceHold> holdSpace(String gameId) => guard(() async {
        final row = firstRow(await _client.rpc<dynamic>('hold_space', params: {'p_game': gameId}));
        if (row == null) throw StateError('Something went wrong. Please try again.');
        return SpaceHold(
          id: row['id'] as String,
          gameId: row['game_id'] as String,
          expiresAt: parseTime(row['expires_at']),
        );
      });

  @override
  Future<Booking> confirm(SpaceHold hold, {required bool useWallet}) => guard(() async {
        final quote = await _quote(hold.gameId, useWallet: useWallet);
        if (quote.totalPence(useWallet: useWallet) > 0) {
          throw StateError(
            quote.currency == Currency.gbp
                ? "Card payments aren't switched on yet. Use wallet credit to "
                    'book for now.'
                : "Card payments aren't switched on yet, so games outside "
                    "the UK can't be booked in the app for now.",
          );
        }
        final row = firstRow(
          await _client.rpc<dynamic>('confirm_booking_with_wallet', params: {'p_hold': hold.id}),
        );
        if (row == null) throw StateError('Something went wrong. Please try again.');
        _changes.changed();
        return Booking(
          id: row['id'] as String,
          gameId: row['game_id'] as String,
          playerId: row['player_id'] as String,
          paidPence: asInt(row['card_pence']),
          walletUsedPence: asInt(row['wallet_pence']),
          createdAt: parseTime(row['created_at']),
        );
      });

  @override
  Future<CancelOutcome> cancel(String gameId) => guard(() async {
        final result = await _client.rpc<dynamic>('cancel_booking', params: {'p_game': gameId});
        _changes.changed();
        return result == 'refunded' ? CancelOutcome.refunded : CancelOutcome.refundIfFilled;
      });

  @override
  Future<void> joinWaitlist(String gameId) => guard(() async {
        await _client.rpc<dynamic>('join_waitlist', params: {'p_game': gameId});
        _changes.changed();
      });
}
