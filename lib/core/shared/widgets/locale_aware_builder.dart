import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/locale_cubit.dart';

/// Wraps one screen's builder so it automatically rebuilds — and so
/// re-resolves every `.tr()` call inside it with the new language —
/// the moment [LocaleCubit] changes.
///
/// Why this exists: a screen is only built once by `Navigator` when
/// its route is pushed, and Flutter doesn't re-invoke that builder
/// just because some ancestor (like `MaterialApp`) rebuilt with a new
/// `locale` — only widgets that actually *depend on* an
/// `InheritedWidget` that changed get marked dirty. Plain `.tr()`
/// calls don't register that dependency on their own, so without
/// this, every already-pushed screen's text would stay frozen in
/// whatever language was active when it was first built. `onGenerateRoute`
/// wraps every route's builder with this once, centrally, so no
/// individual screen needs to remember `context.watch<LocaleCubit>()`
/// itself.
///
/// The [ValueKey] below is the part that actually makes this work for
/// *every* screen, not just some: most entries in `_simpleRoutes` are
/// written as `(_) => const SomeScreen()`. Watching `LocaleCubit` here
/// does make this widget itself rebuild on a language change, but
/// `builder(context)` then returns that exact same `const` instance
/// every time — and when a parent element reconciles an *identical*
/// child widget, Flutter's `Element.updateChild` short-circuits and
/// never calls `build()` on that child at all, so the screen's own
/// `.tr()` calls never re-resolve. Wrapping the result in a
/// `KeyedSubtree` keyed by the current locale forces Flutter to treat
/// it as a genuinely new subtree whenever the language changes —
/// unmounting and remounting it fresh — regardless of whether the
/// screen is `const` or remembers to watch the cubit itself. (This is
/// exactly what was silently broken on the role-selection screen.)
class LocaleAwareBuilder extends StatelessWidget {
  final WidgetBuilder builder;

  const LocaleAwareBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state;
    return KeyedSubtree(key: ValueKey(locale), child: builder(context));
  }
}
