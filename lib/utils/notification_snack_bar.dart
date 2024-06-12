import 'package:flutter/material.dart';

class NotificationSnackbar {
  static void show({
    required BuildContext context,
    required String text,
    Color backgroundColor = Colors.green,
    TextStyle? textStyle,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(5)),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _SnackbarOverlay(
        text: text,
        backgroundColor: backgroundColor,
        textStyle: textStyle,
        borderRadius: borderRadius,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  static void showError(BuildContext context, String message) {
    show(
      context: context,
      text: message,
      backgroundColor: Theme.of(context).colorScheme.error,
      textStyle:
          Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(
      context: context,
      text: message,
      backgroundColor: Colors.green,
      textStyle:
          Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
    );
  }
}

class _SnackbarOverlay extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final BorderRadiusGeometry borderRadius;

  const _SnackbarOverlay({
    required this.text,
    required this.backgroundColor,
    required this.textStyle,
    required this.borderRadius,
  });

  @override
  __SnackbarOverlayState createState() => __SnackbarOverlayState();
}

class __SnackbarOverlayState extends State<_SnackbarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        _controller.reverse();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 10,
      right: 10,
      child: SlideTransition(
        position: _offsetAnimation,
        child: AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            );
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: widget.borderRadius,
              ),
              child: Text(
                widget.text,
                style: widget.textStyle ??
                    const TextStyle(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
