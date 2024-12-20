import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/data/models/category.dart';
import 'package:ezbooking/data/models/location_result.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter/filter_event.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter/filter_state.dart';
import 'package:flutter/material.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  List<Category> selectedFilterItems = [];
  DateTimeRange? selectedDateRange;
  LocationResult? locationResult;
  RangeValues currentRangeValues = const RangeValues(0, 0);

  FilterBloc() : super(FilterInitial()) {
    on<SelectFilterItem>(_onSelectFilterItem);
    on<SetSelectedDate>(_onSetSelectedDate);
    on<SetRangeValues>(_onSetRangeValues);
    on<SelectLocation>(_onSelectLocation);
  }

  void _onSelectFilterItem(SelectFilterItem event, Emitter<FilterState> emit) {
    if (selectedFilterItems.contains(event.item)) {
      selectedFilterItems.remove(event.item);
    } else {
      selectedFilterItems.add(event.item);
    }
    emit(_buildUpdatedState());
  }

  void _onSetSelectedDate(SetSelectedDate event, Emitter<FilterState> emit) {
    selectedDateRange = event.selectedDateRange;
    emit(_buildUpdatedState());
  }

  void _onSelectLocation(SelectLocation event, Emitter<FilterState> emit) {
    locationResult = event.locationResult;
    emit(_buildUpdatedState());
  }

  void _onSetRangeValues(SetRangeValues event, Emitter<FilterState> emit) {
    currentRangeValues = event.rangeValues;
    emit(_buildUpdatedState());
  }

  FilterUpdated _buildUpdatedState() {
    return FilterUpdated(
      selectedFilterItems: selectedFilterItems,
      selectedDateRange: selectedDateRange,
      currentRangeValues: currentRangeValues,
      locationResult: locationResult,
    );
  }

  void resetFilter() {
    selectedFilterItems = [];
    currentRangeValues = const RangeValues(0, 0);
    selectedDateRange = null;
    locationResult = null;
    emit(FilterUpdated(
      selectedFilterItems: selectedFilterItems,
      selectedDateRange: selectedDateRange,
      currentRangeValues: currentRangeValues,
      locationResult: locationResult,
    ));
  }

  bool hasFilter() {
    return selectedFilterItems.isNotEmpty ||
        selectedDateRange != null ||
        currentRangeValues != const RangeValues(0, 0);
  }
}
