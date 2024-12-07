import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/data/models/category.dart';
import 'package:flutter/material.dart';

abstract class FilterEvent {}

class SelectFilterItem extends FilterEvent {
  final Category item;
  SelectFilterItem(this.item);
}


class SetSelectedDate extends FilterEvent {
  final DateTimeRange selectedDateRange;
  SetSelectedDate(this.selectedDateRange);
}

class SetRangeValues extends FilterEvent {
  final RangeValues rangeValues;
  SetRangeValues(this.rangeValues);
}
