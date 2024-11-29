import 'package:flutter/material.dart';

class KeyboardUtil {
  // scroll chat window to bottom
  static void scrollToBottom({
    required ScrollController scrollController,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: duration,
          curve: curve,
        );
      }
    });
  }

  // Widget that dismisses keyboard when tapping outside
  static Widget dismissible({required Widget child}) {
    return _KeyboardDismissible(child: child);
  }
}

// Private widget implementation
class _KeyboardDismissible extends StatelessWidget {
  final Widget child;
  
  const _KeyboardDismissible({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
} 