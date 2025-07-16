<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedIndexNotifier extends StateNotifier<int> {
  SelectedIndexNotifier() : super(0);

  void updateIndex(int index) {
    state = index;
  }
}

final selectedIndexProvider =
    StateNotifierProvider<SelectedIndexNotifier, int>((ref) {
  return SelectedIndexNotifier();
});
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedIndexNotifier extends StateNotifier<int> {
  SelectedIndexNotifier() : super(0);

  void updateIndex(int index) {
    state = index;
  }
}

final selectedIndexProvider =
    StateNotifierProvider<SelectedIndexNotifier, int>((ref) {
  return SelectedIndexNotifier();
});
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
