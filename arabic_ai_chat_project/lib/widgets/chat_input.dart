import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    context.read<ChatProvider>().sendMessage(text.trim());
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _focusNode.hasFocus
                        ? colorScheme.primary
                        : colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textDirection: TextDirection.rtl,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.trim().isNotEmpty;
                    });
                  },
                  onSubmitted: _handleSubmitted,
                  decoration: InputDecoration(
                    hintText: 'اكتب رسالتك هنا...',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(
                        LucideIcons.paperclip,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                      ),
                      onPressed: () {
                        // TODO: Implement file attachment
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ميزة إرفاق الملفات قريباً'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                gradient: _isComposing
                    ? LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                      )
                    : null,
                color: _isComposing ? null : colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                onPressed: _isComposing
                    ? () => _handleSubmitted(_controller.text)
                    : null,
                icon: Icon(
                  LucideIcons.send,
                  color: _isComposing
                      ? Colors.white
                      : colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
              ),
            )
                .animate(target: _isComposing ? 1 : 0)
                .scale(duration: 200.ms, curve: Curves.easeInOut)
                .then()
                .shimmer(
                  duration: 1000.ms,
                  color: Colors.white.withOpacity(0.3),
                ),
          ],
        ),
      ),
    );
  }
}