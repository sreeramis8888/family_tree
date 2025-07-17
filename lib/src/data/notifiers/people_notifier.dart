import 'dart:developer';
import 'package:familytree/src/data/api_routes/people_api/people_api.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'people_notifier.g.dart';

@riverpod
class PeopleNotifier extends _$PeopleNotifier {
  List<UserModel> users = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 20;
  bool hasMore = true;
  String? searchQuery;
  String? district;
  bool isFirstLoad = true;
  List<String>? tags;

  @override
  List<UserModel> build() {
    return [];
  }

  Future<void> fetchMoreUsers() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    Future(() {
      state = [...users];
    });

    try {
      final newUsers = await ref.read(
        fetchActiveUsersProvider(
          pageNo: pageNo,
          limit: limit,
          query: searchQuery,
          district: district,
          tags: tags, 
        ).future,
      );

      users = [...users, ...newUsers];
      pageNo++;
      isFirstLoad = false;
      hasMore = newUsers.length == limit;

      Future(() {
        state = [...users];
      });
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;

      Future(() {
        state = [...users];
      });

      log('Fetched users: $users');
    }
  }

  Future<void> searchUsers(String query,
      {String? districtFilter, List<String>? tagsFilter}) async {
    isLoading = true;
    pageNo = 1;
    users = [];
    searchQuery = query;
    district = districtFilter; // Apply district filter
    tags = tagsFilter; // Apply tags filter

    try {
      final newUsers = await ref.read(
        fetchActiveUsersProvider(
          pageNo: pageNo,
          limit: limit,
          query: query,
          district: district, // Pass district filter
          tags: tags, // Pass tags filter
        ).future,
      );

      users = [...newUsers];
      hasMore = newUsers.length == limit;

      state = [...users];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh() async {
    isLoading = true;
    pageNo = 1;
    hasMore = true;
    users = [];
    state = [...users];

    try {
      final newUsers = await ref.read(
        fetchActiveUsersProvider(
          pageNo: pageNo,
          limit: limit,
          query: searchQuery,
          district: district, // Pass district filter
          tags: tags, // Pass tags filter
        ).future,
      );

      users = [...newUsers];
      hasMore = newUsers.length == limit;

      state = [...users];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  void setDistrict(String? newDistrict) {
    district = newDistrict;
    refresh(); // Auto-refresh when district is updated
  }

  void setTags(List<String>? newTags) {
    tags = newTags;
    refresh(); // Auto-refresh when tags are updated
  }
}
