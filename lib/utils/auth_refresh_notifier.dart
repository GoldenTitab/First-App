import 'dart:async';

import 'package:flutter/foundation.dart';

/// Turns a stream (e.g. `FirebaseAuth.authStateChanges()`) into a [Listenable]
/// that GoRouter can use as `refreshListenable`, so the router re-evaluates
/// its redirect whenever the auth state changes (sign-out from another place,
/// expired session, ...).
class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
