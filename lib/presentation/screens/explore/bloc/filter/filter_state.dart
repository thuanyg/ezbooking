import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/data/models/category.dart';
import 'package:flutter/material.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}

class FilterUpdated extends FilterState {
  final List<Category> selectedFilterItems;
  final DateTimeRange? selectedDateRange;
  final RangeValues currentRangeValues;

  FilterUpdated({
    required this.selectedFilterItems,
    required this.selectedDateRange,
    required this.currentRangeValues,
  });
}
