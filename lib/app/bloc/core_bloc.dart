import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage.dart';
import 'package:pump_progress_frontend/repositories/models/user.dart';

part 'core_event.dart';
part 'core_state.dart';

class CoreBloc extends Bloc<CoreEvent, CoreState> {
  CoreBloc(this.localStorage) : super(const CoreState()) {
    print('cre bkic created');
    on<CoreInit>(_onCoreInit);
    on<CoreLogout>(_onCoreLogout);
  }

  final LocalStorage localStorage;

  Future<void> _onCoreInit(CoreInit event, Emitter<CoreState> emit) async {
    try {
      final token = await localStorage.read(
        LocalStorageKey.jwt,
      );
      print('token:');
      print(token);
      if (token != null) {
        emit(state.copyWith(status: AuthenticationStatus.authenticated));
        return;
      }
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
  }

  Future<void> _onCoreLogout(CoreLogout event, Emitter<CoreState> emit) async {
    await localStorage.delete(LocalStorageKey.jwt);
    emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
  }
}
