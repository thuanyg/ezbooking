import 'package:bloc/bloc.dart';
import 'package:ezbooking/data/models/location_result.dart';
import 'package:ezbooking/domain/usecases/maps/map_usecase.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/location_state.dart';
import 'package:flutter/cupertino.dart';

class GetLocationBloc extends Cubit<LocationState> {
  final MapUseCase _mapUseCase;

  GetLocationBloc(this._mapUseCase) : super(LocationInitial());
  LocationResult? locationResult;

  Future<void> getCurrentAddress(BuildContext context) async {
    try {
      emit(LocationLoading());
      locationResult = await _mapUseCase.getCurrentLocation(context);
      emit(LocationSuccess(
          position: locationResult?.position,
          address: locationResult?.address));
    } on Exception catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  emitLocation(LocationResult? locationResult) async {
    emit(LocationLoading());
    await Future.delayed(const Duration(milliseconds: 1500));
    this.locationResult = locationResult;
    emit(LocationSuccess(
      position: locationResult?.position,
      address: locationResult?.address,
    ));
  }
}
