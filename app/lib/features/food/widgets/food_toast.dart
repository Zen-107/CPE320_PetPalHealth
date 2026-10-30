import 'package:flutter/material.dart';

import '../food_rules.dart';

/// Toast ลอยเหนือสัตว์เลี้ยง (ui-spec §2.1.1) — ไม่ใช่ SnackBar เพราะต้องยึดตำแหน่งกับ
/// สัตว์เลี้ยง (AC-12) · สี inverseSurface / onInverseSurface เท่า SnackBar M3
class FoodToast extends StatelessWidget {
  const FoodToast({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      key: const Key('food_toast'),
      color: scheme.inverseSurface,
      elevation: 6,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          message,
          key: message == FoodRules.overLimitToastText
              ? const Key('food_over_limit_toast')
              : null,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onInverseSurface,
          ),
        ),
      ),
    );
  }
}
