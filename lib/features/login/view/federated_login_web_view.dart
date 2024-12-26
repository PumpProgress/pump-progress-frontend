import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/login/bloc/login_bloc.dart';
import 'package:pump_progress_frontend/utils/services/cognito_user_pool/cognito_user_pool.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FederatedLoginWebView extends StatelessWidget {
  final String provider;

  FederatedLoginWebView({
    super.key,
    required this.provider,
  });

  final webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setUserAgent('userAgent');

  @override
  Widget build(BuildContext context) {
    final url = PPUserPool().getLoginUrl(provider);
    webViewController
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            print('onNavigationRequest: ${request.url}');
            if (!request.url.startsWith("myapp://pumpprogress?code=")) {
              return NavigationDecision.navigate;
            }
            String code =
                request.url.substring("myapp://pumpprogress?code=".length);
            if (code.isEmpty) {
              context.read<LoginBloc>().add(const UnknownError());
              return NavigationDecision.prevent;
            }
            // handle error
            context.read<LoginBloc>().add(LogInCode(code: code));
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return SafeArea(child: WebViewWidget(controller: webViewController));
  }
}
