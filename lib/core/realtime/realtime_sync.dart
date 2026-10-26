import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/offers/cubit/offers_cubit.dart';
import '../../features/requests/cubit/requests_cubit.dart';

/// Keeps the screens in step with the database while the app is open: when an
/// offer or a request changes (an offer is sent / accepted / declined, a request
/// is closed...) the lists are reloaded, so nobody has to pull to refresh.
///
/// Needs the tables in the `supabase_realtime` publication (migration
/// `enable_realtime_offers_requests`). Row-level security still applies, so a
/// user only gets events for rows they can read.
class RealtimeSync extends StatefulWidget {
  final Widget child;
  const RealtimeSync({super.key, required this.child});

  @override
  State<RealtimeSync> createState() => _RealtimeSyncState();
}

class _RealtimeSyncState extends State<RealtimeSync> {
  final _client = Supabase.instance.client;
  RealtimeChannel? _channel;
  StreamSubscription<AuthState>? _auth;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _auth = _client.auth.onAuthStateChange.listen((s) {
      if (s.session == null) {
        _unsubscribe();
      } else if (_channel == null) {
        _subscribe();
      }
    });
    if (_client.auth.currentSession != null) _subscribe();
  }

  bool get _isMarketer {
    final user = _client.auth.currentUser;
    return (user?.appMetadata['user_role'] ?? user?.userMetadata?['role']) == 'marketer';
  }

  void _subscribe() {
    final channel = _client.channel('app-sync');
    for (final table in const ['offers', 'property_requests']) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: table,
        callback: (_) => _scheduleRefresh(),
      );
    }
    channel.subscribe();
    _channel = channel;
  }

  void _unsubscribe() {
    _debounce?.cancel();
    final channel = _channel;
    _channel = null;
    if (channel != null) _client.removeChannel(channel);
  }

  // Several rows usually change together (accepting declines the others and
  // closes the request), so wait a moment and refresh once.
  void _scheduleRefresh() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _refresh);
  }

  void _refresh() {
    if (!mounted) return;
    final requests = context.read<RequestsCubit>();
    final openId = requests.state.selected?.id;
    requests.load();
    if (openId != null) requests.open(openId); // the details screen + its offers
    if (_isMarketer) context.read<OffersCubit>().load();
  }

  @override
  void dispose() {
    _auth?.cancel();
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
