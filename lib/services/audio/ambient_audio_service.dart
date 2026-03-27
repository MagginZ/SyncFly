import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// 离线白噪音：将 `white_noise.mp3` 放入 `assets/audio/` 并在 pubspec 声明后调用 [tryPrepareLoop].
///
/// 路径与 [AssetSource] 一致：不含 `assets/` 前缀，例如 `audio/white_noise.mp3`
///（对应 pubspec 中 `assets/audio/` 目录下的文件）。
///
/// **Web**：浏览器禁止在无用户手势时启动 AudioContext。不要在首帧 `play()`；
/// 需在 [unlockWebAudioAfterUserGesture] 中（任意 PointerDown / 按钮 onPressed）再无声 play→pause。
class AmbientAudioService {
  AmbientAudioService() : _player = AudioPlayer();

  final AudioPlayer _player;
  bool _prepared = false;
  String? _assetPath;
  bool _webPrimedWithGesture = false;

  Future<void> tryPrepareLoop(String assetPath) async {
    if (_prepared && _assetPath == assetPath) return;
    _assetPath = assetPath;
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      if (kIsWeb) {
        // Web：仅加载音源，不 play，避免 "AudioContext was not allowed to start"。
        await _player.setSource(AssetSource(assetPath));
        _prepared = true;
        return;
      }
      // 移动端：无声 play 再 pause，便于后续 resume。
      await _player.setVolume(0);
      await _player.play(AssetSource(assetPath));
      await _player.pause();
      await _player.setVolume(1.0);
      _prepared = true;
    } catch (e, st) {
      _prepared = false;
      debugPrint('AmbientAudioService.tryPrepareLoop failed: $e\n$st');
    }
  }

  bool get isPrepared => _prepared;

  /// Web：是否已在用户手势内完成无声 play→pause（未完成时 [resume] 不会出声）。
  bool get isWebAudioUnlocked => !kIsWeb || _webPrimedWithGesture;

  /// Web 专用：在 [PointerDown] / [onPressed] 等用户手势回调里调用一次（可多次调用，仅首次生效）。
  Future<void> unlockWebAudioAfterUserGesture() async {
    if (!kIsWeb || _webPrimedWithGesture || _assetPath == null) return;
    if (!_prepared) {
      await tryPrepareLoop(_assetPath!);
      if (!_prepared) return;
    }
    try {
      await _player.setVolume(0);
      await _player.play(AssetSource(_assetPath!));
      await _player.pause();
      await _player.setVolume(1.0);
      _webPrimedWithGesture = true;
    } catch (e, st) {
      debugPrint('AmbientAudioService.unlockWebAudioAfterUserGesture: $e\n$st');
    }
  }

  Future<void> setVolume(double v) => _player.setVolume(v.clamp(0.0, 1.0));

  Future<void> pause() => _player.pause();

  Future<void> resume() async {
    if (!_prepared) return;
    if (kIsWeb && !_webPrimedWithGesture) return;
    await _player.resume();
  }

  Future<void> dispose() => _player.dispose();
}
