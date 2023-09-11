part of 'core_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

@immutable
class CoreState extends Equatable {
  const CoreState(
      {this.status = AuthenticationStatus.unknown,
      this.user = User.unknown,
      this.workouts = const []});

  final AuthenticationStatus status;
  final User user;
  final List<Workout> workouts;

  @override
  List<Object> get props => [status, user, workouts];

  CoreState copyWith({
    AuthenticationStatus? status,
    User? user,
    List<Workout>? workouts,
  }) {
    return CoreState(
      status: status ?? this.status,
      user: user ?? this.user,
      workouts: workouts ?? this.workouts,
    );
  }
}
