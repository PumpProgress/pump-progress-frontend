import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

@immutable
class ChatMessage extends Equatable {
  const ChatMessage({
    required this.text,
    required this.isUser,
    this.isStreaming = false,
    this.isSystemMessage = false,
  });

  final String text;
  final bool isUser;
  final bool isStreaming;
  final bool isSystemMessage;

  ChatMessage copyWith({
    String? text,
    bool? isStreaming,
    bool? isSystemMessage,
  }) =>
      ChatMessage(
        text: text ?? this.text,
        isUser: isUser,
        isStreaming: isStreaming ?? this.isStreaming,
        isSystemMessage: isSystemMessage ?? this.isSystemMessage,
      );

  @override
  List<Object> get props => [text, isUser, isStreaming, isSystemMessage];
}
