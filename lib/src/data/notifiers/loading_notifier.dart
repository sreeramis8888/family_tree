<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void startLoading() => state = true;
  void stopLoading() => state = false;
}

final loadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void startLoading() => state = true;
  void stopLoading() => state = false;
}

final loadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
});