import 'package:flutter/material.dart';

import '../food_rules.dart';

/// CTA Banner ชวนตั้งโปรไฟล์ (food ui-spec §2.1 #9b, AC-8, EC-4) — แยกจาก
/// FoodDashboardScreen เพื่อใช้ซ้ำบน S-1 ของ dashboard (owner รอบ 3 ข้อ 5)
/// widget tree / keys / สไตล์ เหมือนเดิมทุกอย่าง (`food_profile_cta_banner`, `food_cta_text`,
/// `food_cta_total_text`)
class FoodProfileCtaBanner extends StatelessWidget {
  const FoodProfileCtaBanner({
    super.key,
    required this.totalText,
    required this.onTap,
  });

  /// ยอดรวมวันนี้ (FoodController.ctaTotalText)
  final String totalText;

  /// เปิด S-3 ตั้งโปรไฟล์
  final VoidCallback onTap;

  static const double padH = 16;
  static const double padV = 8;
  static const double iconGap = 8;
  static const double iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = scheme.onSecondaryContainer;
    return Material(
      color: scheme.secondaryContainer,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        key: const Key('food_profile_cta_banner'),
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padH, vertical: padV),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FoodRules.profileCtaText,
                      key: const Key('food_cta_text'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(color: fg),
                    ),
                    Text(
                      totalText,
                      key: const Key('food_cta_total_text'),
                      // BUG-FOOD-2 (DECIDED D-5): ยอดรวมต้องแสดงครบ ห้ามตัด — ขึ้นบรรทัด
                      // ใหม่ได้ (ช่องโตตาม) · ellipsis ใช้เฉพาะข้อความชวนตาม ui-spec #9b
                      style: theme.textTheme.titleMedium?.copyWith(color: fg),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: iconGap),
              Icon(Icons.chevron_right, size: iconSize, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}
