class PaginationParams {
  const PaginationParams({
    this.page = 1,
    this.perPage = 10,
    this.filters = const <String, dynamic>{},
  });

  final int page;
  final int perPage;
  final Map<String, dynamic> filters;

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      ...filters,
    };

    params.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String) return value.trim().isEmpty;
      return false;
    });

    return params;
  }
}
