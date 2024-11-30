import 'package:bloc/bloc.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter/filter_event.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter/filter_state.dart';
import 'package:flutter/material.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  List<FilterItem> selectedFilterItems = [];
  List<String> selectedTime = [];
  DateTime? selectedDate;
  RangeValues currentRangeValues = const RangeValues(0, 0);

  FilterBloc() : super(FilterInitial()) {
    on<SelectFilterItem>(_onSelectFilterItem);
    on<SetSelectedTime>(_onSetSelectedTime);
    on<SetSelectedDate>(_onSetSelectedDate);
    on<SetRangeValues>(_onSetRangeValues);
  }

  void _onSelectFilterItem(SelectFilterItem event, Emitter<FilterState> emit) {
    if (selectedFilterItems.contains(event.item)) {
      selectedFilterItems.remove(event.item);
    } else {
      selectedFilterItems.add(event.item);
    }
    emit(_buildUpdatedState());
  }

  void _onSetSelectedTime(SetSelectedTime event, Emitter<FilterState> emit) {
    selectedTime = event.selectedTime;
    emit(_buildUpdatedState());
  }

  void _onSetSelectedDate(SetSelectedDate event, Emitter<FilterState> emit) {
    selectedDate = event.selectedDate;
    emit(_buildUpdatedState());
  }

  void _onSetRangeValues(SetRangeValues event, Emitter<FilterState> emit) {
    currentRangeValues = event.rangeValues;
    emit(_buildUpdatedState());
  }

  FilterUpdated _buildUpdatedState() {
    return FilterUpdated(
      selectedFilterItems: selectedFilterItems,
      selectedTime: selectedTime,
      selectedDate: selectedDate,
      currentRangeValues: currentRangeValues,
    );
  }

  void resetFilter() {
    selectedFilterItems = [];
    selectedTime = [];
    selectedDate = null;
    currentRangeValues = const RangeValues(0, 0);
    emit(FilterUpdated(
      selectedFilterItems: selectedFilterItems,
      selectedTime: selectedTime,
      selectedDate: selectedDate,
      currentRangeValues: currentRangeValues,
    ));
  }

  bool hasFilter() {
    return selectedFilterItems.isNotEmpty ||
        selectedTime.isNotEmpty ||
        selectedDate != null ||
        currentRangeValues != const RangeValues(0, 0);
  }
}
