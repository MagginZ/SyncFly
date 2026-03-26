/// 呼吸节律与视觉/触觉耦合方式。
enum BreathPatternKind {
  /// 连续正弦，适合待机与平飞。
  smoothSine,

  /// 4-7-8：吸气 4s → 屏息 7s → 呼气 8s（周期 19s）。
  fourSevenEight,
}
