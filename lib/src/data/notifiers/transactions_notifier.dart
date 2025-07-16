import 'dart:developer';
import 'package:familytree/src/data/api_routes/finance_api/finance_api.dart';
import 'package:familytree/src/data/models/transaction_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'transactions_notifier.g.dart';

@riverpod
class TransactionsNotifier extends _$TransactionsNotifier {
  List<TransactionModel> transactions = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 20;
  bool hasMore = true;

  @override
  List<TransactionModel> build() {
    return [];
  }

  Future<void> fetchMoreTransactions() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    Future(() => state = [...transactions]);
    try {
      final newTxs = await ref.read(
        getAllTransactionsProvider(page: pageNo, limit: limit).future,
      );
      transactions = [...transactions, ...newTxs];
      pageNo++;
      hasMore = newTxs.length == limit;
      Future(() => state = [...transactions]);
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
      Future(() => state = [...transactions]);
    }
  }

  Future<void> refresh() async {
    isLoading = true;
    pageNo = 1;
    hasMore = true;
    transactions = [];
    state = [...transactions];
    try {
      final newTxs = await ref.read(
        getAllTransactionsProvider(page: pageNo, limit: limit).future,
      );
      transactions = [...newTxs];
      hasMore = newTxs.length == limit;
      state = [...transactions];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
} 