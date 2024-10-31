import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/repositories/models/user.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      print("ON CORE INIT");

      final accessToken = prefs.getString(accessTokenKey);
      final refreshToken = prefs.getString(refreshTokenKey);
      final idToken = prefs.getString(idTokenKey);

      if (accessToken != null && refreshToken != null && idToken != null) {
        final userId = CognitoIdToken(idToken).payload['custom:userID'];
        final user = await pumpProgressRepository.getUser(userId);

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(jwtKey);
    emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
  }

  Future<void> _onCoreMeUpdated(
    CoreMeUpdated event,
    Emitter<CoreState> emit,
  ) async {
    emit(state.copyWith(user: event.me));
  }
}
