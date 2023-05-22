import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage_hive.dart';
import 'package:pump_progress_frontend/l10n/l10n.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class App extends StatelessWidget {
  const App({super.key});
  static const router = PumpProgressRouter();
  // await HiveStorage().inits();
  static final localStorage = HiveStorage();

  @override
  Widget build(BuildContext context) {
    final providers = [
      RepositoryProvider<PumpProgressRepository>(
        create: (context) => PumpProgressRepository(),
      )
    ];
    return MultiRepositoryProvider(
      providers: providers,
      child: BlocProvider<CoreBloc>(
        create: (context) {
          return CoreBloc(localStorage)..add(const CoreInit());
        },
        child: MaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: const Color(0xFF13B9FF),
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: router.onGenerateRoute,
        ),
      ),
    );

    // return MaterialApp(
    //   theme: ThemeData(
    //     appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
    //     colorScheme: ColorScheme.fromSwatch(
    //       accentColor: const Color(0xFF13B9FF),
    //     ),
    //   ),
    //   localizationsDelegates: AppLocalizations.localizationsDelegates,
    //   supportedLocales: AppLocalizations.supportedLocales,
    //   home: const CounterPage(),
    // );
  }
}
