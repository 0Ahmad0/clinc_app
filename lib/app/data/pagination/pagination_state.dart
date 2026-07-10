import 'package:get/get.dart';

import '../models.dart';

class PaginationState<T> {
  PaginationState({this.perPage = 10});

  final int perPage;
  final RxList<T> items = <T>[].obs;
  final RxBool isInitialLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isRefreshing = false.obs;

  int currentPage = 1;
  int? total;
  bool hasMore = true;

  bool get isBusy =>
      isInitialLoading.value || isLoadingMore.value || isRefreshing.value;

  void reset() {
    currentPage = 1;
    total = null;
    hasMore = true;
    items.clear();
  }

  void setPage({required List<T> data, required int page, MetaList? meta}) {
    if (page == 1) {
      items.assignAll(data);
    } else {
      items.addAll(data);
    }

    currentPage = meta?.currentPage ?? page;
    total = meta?.total ?? total;
    hasMore = _resolveHasMore(data, meta);
  }

  bool _resolveHasMore(List<T> data, MetaList? meta) {
    if (meta?.to != null && meta?.total != null) {
      return meta!.to! < meta.total!;
    }
    if (meta?.currentPage != null &&
        meta?.perPage != null &&
        meta?.total != null) {
      return meta!.currentPage! * meta.perPage! < meta.total!;
    }
    return data.length >= perPage;
  }
}
