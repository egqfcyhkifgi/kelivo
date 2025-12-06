import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  final List<Message> _messages = [];
  bool _isTyping = false;

  List<Message> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  void setTyping(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    addMessage(userMessage);

    // Simulate AI typing
    setTyping(true);
    
    // Simulate AI response delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Add AI response
    final aiResponse = _generateAIResponse(text);
    final aiMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: aiResponse,
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    setTyping(false);
    addMessage(aiMessage);
  }

  String _generateAIResponse(String userMessage) {
    // Simple AI responses in Arabic
    final responses = [
      'مرحباً! كيف يمكنني مساعدتك اليوم؟',
      'هذا سؤال رائع! دعني أفكر في الإجابة...',
      'أفهم ما تقصده. هل يمكنك توضيح أكثر؟',
      'شكراً لك على هذا السؤال المثير للاهتمام.',
      'أعتقد أن الإجابة تعتمد على عدة عوامل...',
      'هذا موضوع معقد، ولكن سأحاول تبسيطه لك.',
      'من وجهة نظري، أرى أن...',
      'هل تريد مني أن أوضح هذه النقطة أكثر؟',
    ];

    if (userMessage.contains('مرحبا') || userMessage.contains('السلام')) {
      return 'وعليكم السلام ورحمة الله وبركاته! أهلاً وسهلاً بك. كيف يمكنني مساعدتك؟';
    }
    
    if (userMessage.contains('كيف حالك') || userMessage.contains('كيفك')) {
      return 'الحمد لله، أنا بخير وجاهز لمساعدتك. كيف حالك أنت؟';
    }

    if (userMessage.contains('شكرا') || userMessage.contains('شكراً')) {
      return 'العفو! أنا سعيد لأنني استطعت مساعدتك. هل تحتاج لأي شيء آخر؟';
    }

    // Return random response
    return responses[DateTime.now().millisecond % responses.length];
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}