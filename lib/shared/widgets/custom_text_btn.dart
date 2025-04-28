import 'package:flutter/material.dart';

class CustomTextBtn extends StatelessWidget {
  final VoidCallback? onTap;
  final TextStyle style;
  final Color? onPressColor;
  final String text;
  const CustomTextBtn({
    super.key,
    required this.onTap,
    required this.style,
    required this.onPressColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        textStyle: WidgetStateProperty.resolveWith<TextStyle>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return style.copyWith(
              decorationColor:
                  onPressColor ?? Theme.of(context).colorScheme.primaryFixedDim,
            );
          }
          return style;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return onPressColor ??
                Theme.of(context).colorScheme.primaryFixedDim;
          }
          return style.color ?? Theme.of(context).colorScheme.primary;
        }),
        padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
      ),
      child: Text(text),
    );
  }
}
