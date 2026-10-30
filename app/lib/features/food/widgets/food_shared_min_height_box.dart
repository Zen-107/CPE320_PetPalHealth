import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// คำนวณความสูงขั้นต่ำจากความกว้างที่ได้รับจริงตอนจัด layout
typedef MinHeightForWidth = double Function(double width);

/// กล่องที่ให้ลูกสูง "อย่างน้อย" [minHeightFor] (คำนวณจากความกว้างจริง) แล้วโตต่อได้
/// ตามเนื้อหา — ใช้กับช่องพลังงาน S-1 (AC-8) เพื่อให้หลอดพลังงานและ CTA Banner ใช้
/// ความสูงขั้นต่ำร่วมกัน (ค่ามากสุดของทั้งสองแบบ) โดยไม่ต้องล็อกความสูงตายตัว
///
/// ต่างจาก LayoutBuilder ตรงที่รองรับ intrinsic size (หน้า S-1 ครอบด้วย IntrinsicHeight)
class FoodSharedMinHeightBox extends SingleChildRenderObjectWidget {
  const FoodSharedMinHeightBox({
    super.key,
    required this.minHeightFor,
    super.child,
  });

  final MinHeightForWidth minHeightFor;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderFoodSharedMinHeightBox(minHeightFor);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderFoodSharedMinHeightBox renderObject,
  ) {
    renderObject.minHeightFor = minHeightFor;
  }
}

/// RenderObject ของ [FoodSharedMinHeightBox]
class RenderFoodSharedMinHeightBox extends RenderProxyBox {
  RenderFoodSharedMinHeightBox(this._minHeightFor);

  MinHeightForWidth _minHeightFor;
  set minHeightFor(MinHeightForWidth value) {
    if (identical(value, _minHeightFor)) return;
    _minHeightFor = value;
    // closure ใหม่ทุก build (ข้อความ/สไตล์อาจเปลี่ยน) — วัดใหม่เสมอ
    markNeedsLayout();
  }

  BoxConstraints _withMin(BoxConstraints c) {
    final minH = math.max(c.minHeight, _minHeightFor(c.maxWidth));
    return c.copyWith(minHeight: math.min(minH, c.maxHeight));
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      math.max(_minHeightFor(width), super.computeMinIntrinsicHeight(width));

  @override
  double computeMaxIntrinsicHeight(double width) =>
      math.max(_minHeightFor(width), super.computeMaxIntrinsicHeight(width));

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final c = _withMin(constraints);
    return child?.getDryLayout(c) ?? c.smallest;
  }

  @override
  void performLayout() {
    final c = _withMin(constraints);
    final child = this.child;
    if (child == null) {
      size = c.smallest;
      return;
    }
    child.layout(c, parentUsesSize: true);
    size = child.size;
  }
}
