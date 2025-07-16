<<<<<<< HEAD
import 'dart:developer';
import 'package:familytree/src/data/api_routes/finance_api/finance_api.dart';
import 'package:familytree/src/data/models/finance_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'members_notifier.g.dart';

@riverpod
class MembersNotifier extends _$MembersNotifier {
  List<ProgramMember> members = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 20;
  bool hasMore = true;

  @override
  List<ProgramMember> build() {
    return [];
  }

  Future<void> fetchMoreMembers() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    Future(() => state = [...members]);
    try {
      final newMembers = await ref.read(
        getAllFlatProgramMembersProvider(page: pageNo, limit: limit).future,
      );
      members = [...members, ...newMembers];
      pageNo++;
      hasMore = newMembers.length == limit;
      Future(() => state = [...members]);
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
      Future(() => state = [...members]);
    }
  }

  Future<void> refresh() async {
    isLoading = true;
    pageNo = 1;
    hasMore = true;
    members = [];
    state = [...members];
    try {
      final newMembers = await ref.read(
        getAllFlatProgramMembersProvider(page: pageNo, limit: limit).future,
      );
      members = [...newMembers];
      hasMore = newMembers.length == limit;
      state = [...members];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
=======
import 'dart:developer';
import 'package:familytree/src/data/api_routes/finance_api/finance_api.dart';
import 'package:familytree/src/data/models/finance_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'members_notifier.g.dart';

@riverpod
class MembersNotifier extends _$MembersNotifier {
  List<ProgramMember> members = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 20;
  bool hasMore = true;

  @override
  List<ProgramMember> build() {
    return [];
  }

  Future<void> fetchMoreMembers() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    Future(() => state = [...members]);
    try {
      final newMembers = await ref.read(
        getAllFlatProgramMembersProvider(page: pageNo, limit: limit).future,
      );
      members = [...members, ...newMembers];
      pageNo++;
      hasMore = newMembers.length == limit;
      Future(() => state = [...members]);
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
      Future(() => state = [...members]);
    }
  }

  Future<void> refresh() async {
    isLoading = true;
    pageNo = 1;
    hasMore = true;
    members = [];
    state = [...members];
    try {
      final newMembers = await ref.read(
        getAllFlatProgramMembersProvider(page: pageNo, limit: limit).future,
      );
      members = [...newMembers];
      hasMore = newMembers.length == limit;
      state = [...members];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
} 