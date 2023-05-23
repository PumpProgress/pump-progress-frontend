import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage_hive.dart';
import 'package:pump_progress_frontend/repositories/models/user.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'core_event.dart';
part 'core_state.dart';

class CoreBloc extends Bloc<CoreEvent, CoreState> {
  CoreBloc({required this.pumpProgressRepository}) : super(const CoreState()) {
    on<CoreInit>(_onCoreInit);
    on<CoreLogout>(_onCoreLogout);
    on<CoreMeUpdated>(_onCoreMeUpdated);
  }

  final PumpProgressRepository pumpProgressRepository;

  Future<void> _onCoreInit(CoreInit event, Emitter<CoreState> emit) async {
    try {
      final token = HiveStorage.authBox!.get(LocalStorageKey.jwt);
      if (token != null) {
        final user = await pumpProgressRepository.getMe();
        emit(
          state.copyWith(
            status: AuthenticationStatus.authenticated,
            user: user,
          ),
        );
        return;
      }
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
  }

  Future<void> _onCoreLogout(CoreLogout event, Emitter<CoreState> emit) async {
    await HiveStorage.authBox!.delete(LocalStorageKey.jwt);
    emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
  }

  Future<void> _onCoreMeUpdated(
    CoreMeUpdated event,
    Emitter<CoreState> emit,
  ) async {
    emit(state.copyWith(user: event.me));
  }
}
