import 'package:ezbooking/core/config/constants.dart';
import 'package:flutter/material.dart';

abstract class FilterEvent {}

class SelectFilterItem extends FilterEvent {
  final FilterItem item;
  SelectFilterItem(this.item);
}

class SetSelectedTime extends FilterEvent {
  final List<String> selectedTime;
  SetSelectedTime(this.selectedTime);
}

class SetSelectedDate extends FilterEvent {
  final DateTime selectedDate;
  SetSelectedDate(this.selectedDate);
}

class SetRangeValues extends FilterEvent {
  final RangeValues rangeValues;
  SetRangeValues(this.rangeValues);
}
