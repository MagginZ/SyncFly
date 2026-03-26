import 'package:audioplayers/audioplayers.dart';

/// 离线白噪音：将 `white_noise.mp3` 放入 `assets/audio/` 并在 pubspec 声明后调用 [tryPrepareLoop].
class AmbientAudioService {
  AmbientAudioService() : _player = AudioPlayer();

  final AudioPlayer _player;
  bool _prepared = false;

  Future<void> tryPrepareLoop(String assetPath) async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setSource(AssetSource(assetPath));
      _prepared = true;
    } catch (_) {
      _prepared = false;
    }
  }

  bool get isPrepared => _prepared;

  Future<void> setVolume(double v) => _player.setVolume(v.clamp(0.0, 1.0));

  Future<void> pause() => _player.pause();

  Future<void> resume() async {
    if (_prepared) await _player.resume();
  }

  Future<void> dispose() => _player.dispose();
}
