import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'fllama_event.dart';
part 'fllama_state.dart';

class FllamaBloc extends Bloc<FllamaEvent, FllamaState> {
  FllamaBloc() : super(FllamaInitial()) {
    on<LoadFllamaEvent>(_onLoadFllamaEvent);
  }

  Future<void> _onLoadFllamaEvent(
    LoadFllamaEvent event,
    Emitter<FllamaState> emit,
  ) async {
    // final dylibPath = await prepareAllLlamaLibs();
    // final modelPath = await prepareAssetFile(
    //   "assets/models/tinyllama-1.1b-chat-v1.0.Q3_K_M.gguf",
    // );

    // final dir = Directory(dylibPath).parent;
    // print("Dylib folder content:");
    // for (final file in dir.listSync()) {
    //   print(" - ${file.path}");
    // }
    try {
      //   // 1️⃣ Copy libllama.dylib to a filesystem path
      //   // final dylibPath = await prepareAssetFile("assets/libs/libllama.dylib");
      //   Llama.libraryPath = dylibPath;

      //   // 2️⃣ Copy the GGUF model to a filesystem path
      //   // final modelPath = await prepareAssetFile(
      //   //   "assets/models/Qwen3-Embedding-0.6B-Q8_0.gguf",
      //   // );

      //   // 3️⃣ Set safe parameters for mobile
      //   final contextParams = ContextParams()
      //     ..nCtx = 256 // safe upper limit for mobile
      //     ..nBatch = 32; // how many tokens to process per forward pass
      //   // ..seed = -1; // random seed (optional, -1 = random)

      //   final samplerParams = SamplerParams()
      //     ..temp = 0.7 // creativity
      //     ..topK = 40 // limit sampling pool
      //     ..topP = 0.9 // nucleus sampling
      //     ..penaltyRepeat = 1.1; // discourage repetition
      //   // ..repeatLastN = 64; // memory window for repetition

      //   final modelParams = ModelParams()
      //     ..nGpuLayers = 0 // 0 = CPU only (avoid Metal)
      //     // ..useMlock = false // iOS doesn’t allow mlock
      //     ..vocabOnly = false;
      //   // ..useMmap = true; // enables memory-mapped loading

      //   final loadCommand = LlamaLoad(
      //     path: modelPath,
      //     modelParams: modelParams,
      //     contextParams: contextParams,
      //     samplingParams: samplerParams,
      //   );

      //   final llamaParent = LlamaParent(loadCommand);
      //   await llamaParent.init().timeout(
      //     Duration(minutes: 5),
      //     onTimeout: () {
      //       throw TimeoutException("Model loading took too long");
      //     },
      //   );
      //   print("FllamaBloc: Model loaded successfully.");

      // Optional: streaming output
      // llamaParent.stream.listen((response) => print(response));
      // llamaParent.sendPrompt("2 * 2 = ?");
      print(" FllamaBloc: Model loaded successfully.");
      // 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
    } catch (e) {
      print(" Error loading model: $e");
    }
  }
}
