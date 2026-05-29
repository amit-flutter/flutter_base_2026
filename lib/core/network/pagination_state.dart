import 'package:flutter/foundation.dart';

@immutable
class PaginationState<T> {
  final List<T> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasReachedEnd;
  final int? totalItems;

  const PaginationState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasReachedEnd = false,
    this.totalItems,
  });

  PaginationState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasReachedEnd,
    int? totalItems,
  }) =>
      PaginationState<T>(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        error: error,
        currentPage: currentPage ?? this.currentPage,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
        totalItems: totalItems ?? this.totalItems,
      );

  bool get hasItems => items.isNotEmpty;
  bool get hasError => error != null;
}