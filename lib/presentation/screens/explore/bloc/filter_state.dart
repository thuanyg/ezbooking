import 'package:ezbooking/core/config/constants.dart';
import 'package:flutter/material.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}

class FilterUpdated extends FilterState {
  final List<FilterItem> selectedFilterItems;
  final List<String> selectedTime;
  final DateTime? selectedDate;
  final RangeValues currentRangeValues;

  FilterUpdated({
    required this.selectedFilterItems,
    required this.selectedTime,
    required this.selectedDate,
    required this.currentRangeValues,
  });
}
