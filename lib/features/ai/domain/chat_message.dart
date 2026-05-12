import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.text,
    required this.isUser,
    this.isStreaming = false,
  });

  final String text;
  final bool isUser;
  final bool isStreaming;

  ChatMessage copyWith({String? text, bool? isStreaming}) => ChatMessage(
        text: text ?? this.text,
        isUser: isUser,
        isStreaming: isStreaming ?? this.isStreaming,
      );

  @override
  List<Object> get props => [text, isUser, isStreaming];
}
