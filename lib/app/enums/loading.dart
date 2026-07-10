enum GeneralLoading { initial, loading, success, failure, empty }

extension GeneralLoadingX on GeneralLoading {
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function() success,
    required T Function() failure,
    required T Function() empty,
  }) {
    switch (this) {
      case GeneralLoading.initial:
        return initial();
      case GeneralLoading.loading:
        return loading();
      case GeneralLoading.success:
        return success();
      case GeneralLoading.failure:
        return failure();
      case GeneralLoading.empty:
        return empty();
    }
  }

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function()? success,
    T Function()? failure,
    T Function()? empty,
    required T Function() orElse,
  }) {
    switch (this) {
      case GeneralLoading.initial:
        return initial?.call() ?? orElse();
      case GeneralLoading.loading:
        return loading?.call() ?? orElse();
      case GeneralLoading.success:
        return success?.call() ?? orElse();
      case GeneralLoading.failure:
        return failure?.call() ?? orElse();
      case GeneralLoading.empty:
        return empty?.call() ?? orElse();
    }
  }
}
