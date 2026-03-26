import 'package:flutter/material.dart';

class BodyGuidanceBanner extends StatelessWidget {
  const BodyGuidanceBanner({
    super.key,
    required this.text,
    required this.visible,
  });

  final String text;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      opacity: visible ? 1 : 0,
      child: IgnorePointer(
        ignoring: !visible,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      height: 1.35,
                      letterSpacing: 0.2,
                      color: const Color(0xFFE8E8E8),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
