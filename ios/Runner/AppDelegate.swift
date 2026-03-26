import CoreHaptics
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var hapticEngine: CHHapticEngine?
  private var hapticPlayer: CHHapticAdvancedPatternPlayer?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let messenger = engineBridge.applicationRegistrar.messenger()
    let channel = FlutterMethodChannel(name: "app/haptics", binaryMessenger: messenger)

    weak var weakSelf = self
    channel.setMethodCallHandler { call, result in
      guard let self = weakSelf else {
        result(FlutterError(code: "unavailable", message: nil, details: nil))
        return
      }
      switch call.method {
      case "playTransient":
        self.handlePlayTransient(call: call, result: result)
      case "playWaveform":
        self.handlePlayWaveform(call: call, result: result)
      case "stop":
        self.handleStop(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func ensureHapticEngine() throws -> CHHapticEngine {
    if let e = hapticEngine {
      return e
    }
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
      throw NSError(domain: "haptics", code: 1, userInfo: [
        NSLocalizedDescriptionKey: "Device does not support Core Haptics",
      ])
    }
    let engine = try CHHapticEngine()
    engine.resetHandler = { [weak self] in
      try? self?.hapticEngine?.start()
    }
    engine.stoppedHandler = { _ in }
    try engine.start()
    hapticEngine = engine
    return engine
  }

  private func handlePlayTransient(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard
      let args = call.arguments as? [String: Any],
      let intensity = args["intensity"] as? Double,
      let sharpness = args["sharpness"] as? Double
    else {
      result(FlutterError(code: "bad_args", message: nil, details: nil))
      return
    }
    do {
      let engine = try ensureHapticEngine()
      let event = CHHapticEvent(
        eventType: .hapticTransient,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(intensity)),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(sharpness)),
        ],
        relativeTime: 0
      )
      let pattern = try CHHapticPattern(events: [event], parameters: [])
      let player = try engine.makeAdvancedPlayer(with: pattern)
      try player.start(atTime: 0)
      result(nil)
    } catch {
      result(nil)
    }
  }

  private func handlePlayWaveform(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard
      let args = call.arguments as? [String: Any],
      let timings = args["timings"] as? [Int],
      let amplitudes = args["amplitudes"] as? [Int],
      !timings.isEmpty,
      !amplitudes.isEmpty
    else {
      result(FlutterError(code: "bad_args", message: nil, details: nil))
      return
    }
    do {
      let engine = try ensureHapticEngine()
      let events = buildContinuousEvents(timings: timings, amplitudes: amplitudes)
      guard !events.isEmpty else {
        result(nil)
        return
      }
      let pattern = try CHHapticPattern(events: events, parameters: [])
      hapticPlayer?.stop(atTime: 0)
      let player = try engine.makeAdvancedPlayer(with: pattern)
      hapticPlayer = player
      try player.start(atTime: 0)
      result(nil)
    } catch {
      result(nil)
    }
  }

  /// 与 Android `VibrationEffect.createWaveform` 的 timings 语义对齐：偶数位为等待/关闭，奇数位为开启。
  private func buildContinuousEvents(timings: [Int], amplitudes: [Int]) -> [CHHapticEvent] {
    var events: [CHHapticEvent] = []
    var cursor = 0.0
    var ampIndex = 0
    for i in 0..<timings.count {
      let sec = Double(timings[i]) / 1000.0
      if i % 2 == 0 {
        cursor += sec
      } else {
        let raw = ampIndex < amplitudes.count ? amplitudes[ampIndex] : amplitudes.last!
        ampIndex += 1
        let intensity = Float(raw) / 255.0
        let event = CHHapticEvent(
          eventType: .hapticContinuous,
          parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.45),
          ],
          relativeTime: cursor,
          duration: max(sec, 0.008)
        )
        events.append(event)
        cursor += sec
      }
    }
    return events
  }

  private func handleStop(result: @escaping FlutterResult) {
    hapticPlayer?.stop(atTime: 0)
    hapticPlayer = nil
    hapticEngine?.stop(completionHandler: nil)
    hapticEngine = nil
    result(nil)
  }
}
