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
  }

  final LocalStorage localStorage;

  Future<void> _onCoreInit(CoreInit event, Emitter<CoreState> emit) async {
    try {
      print('core bloc on core Init');
      final token = await localStorage.read(
        LocalStorageKey.jwt,
      );
      if (token == 'token') {
        print('auth');
        emit(state.copyWith(status: AuthenticationStatus.authenticated));
        return;
      }
      print('un auth');
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    } catch (e) {
      print(e);
      print('un auth');
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
  }

  Future<void> _onValidateToken(CoreInit event, Emitter<CoreState> emit) async {
    print('core bloc on core Init');
    final token = await localStorage.read(
      LocalStorageKey.jwt,
    );
    if (token == 'token') {
      emit(state.copyWith(status: AuthenticationStatus.authenticated));
      return;
    }
    emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
  }
}
