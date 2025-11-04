import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/flavors.dart';
import 'package:pump_progress_frontend/utils/helpers/global_bloc_observer.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = GlobalObserver();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

// Install model
  // await FlutterGemma.installModel(
  //   modelType: ModelType.gemmaIt,
  // )
  //     .fromNetwork(
  //   'https://huggingface.co/litert-community/gemma-3-270m-it/resolve/main/gemma3-270m-it-q8.task',
  //   token: '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',
  // )
  //     .withProgress((progress) {
  //   print('Downloading: ${progress}%');
  // }).install();
  await FlutterGemma.installModel(
    modelType: ModelType.gemmaIt,
  )
      .fromAsset(
    'assets/models/gemma3-270m-it-q8.task',
  )
      .withProgress((progress) {
    print('Downloading: ${progress}%');
  }).install();

  // FlutterGemma.initialize(
  //   huggingFaceToken:
  //       const String.fromEnvironment('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'),
  //   maxDownloadRetries: 10,
  // );

  // Create model with specific configuration
  // final model = await FlutterGemma.getActiveModel(
  //   maxTokens: 2048,
  //   preferredBackend: PreferredBackend.gpu,
  // );

// Use model
  // final chat = await model.createChat();
  // await chat.addQueryChunk(Message.text(
  //   text:
  //       'Dame una rutina de ejercicios para entrenar el pecho en el gymnasio y pesos para alguien con nivel intermedio',
  //   isUser: true,
  // ));
  StreamSubscription<ModelResponse>? _streamSubscription;

  String _message = '';
  // final responseStream = chat.generateChatResponseAsync();

  // _streamSubscription = responseStream.listen(
  //   (response) {
  //     if (response is String) {
  //       // _message = response as String;
  //       _message = "$_message$response";
  //     } else if (response is TextResponse) {
  //       _message = "$_message${response.token}";

  //       // DEBUG: Track text accumulation
  //       debugPrint(
  //           '📝 GemmaInputField: Text accumulated: "${response.token}" -> total: "${_message}"');
  //     } else if (response is ThinkingResponse) {
  //       // print thinking content
  //       debugPrint('💭 GemmaInputField: Thinking: ${response.content}');
  //     } else if (response is FunctionCallResponse) {
  //       debugPrint(
  //           '🔧 GemmaInputField: Function call received: ${response.name}');
  //     }
  //   },
  //   onError: (error) {
  //     debugPrint('❌ GemmaInputField: Stream error: $error');
  //   },
  //   onDone: () {
  //     debugPrint('🏁 GemmaInputField: Stream completed');
  //   },
  // );

// Cleanup
  // await chat.close();
  // await model.close();

  // Try to initialize Sentry with better error handling
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://81c58da756449805f48d4cea7ed19ba8@o4509293403635712.ingest.us.sentry.io/4509297944756224';
      options.sendDefaultPii = true;
      options.environment = F.name;
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
      options.debug = true;
      // Add some additional safety options
      options.captureFailedRequests = false;
      options.autoInitializeNativeSdk = true;
    },
    appRunner: () async {
      try {
        runApp(
          SentryWidget(
            child: await builder(),
          ),
        );
      } catch (e) {
        print('Error running app with Sentry widget: $e');
        runApp(await builder());
      }
    },
  );
  // runApp(await builder());
}
