import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSProvider extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  bool _isInitialized = false;
  double _speechRate = 0.5;
  double _pitch = 1.0;
  double _volume = 0.8;

  bool get isPlaying => _isPlaying;
  bool get isInitialized => _isInitialized;
  double get speechRate => _speechRate;
  double get pitch => _pitch;
  double get volume => _volume;

  TTSProvider() {
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    try {
      // Set language to Arabic
      await _flutterTts.setLanguage("ar-SA");
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setPitch(_pitch);
      await _flutterTts.setVolume(_volume);

      // Set up handlers
      _flutterTts.setStartHandler(() {
        _isPlaying = true;
        notifyListeners();
      });

      _flutterTts.setCompletionHandler(() {
        _isPlaying = false;
        notifyListeners();
      });

      _flutterTts.setErrorHandler((msg) {
        _isPlaying = false;
        notifyListeners();
        debugPrint("TTS Error: $msg");
      });

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint("TTS Initialization Error: $e");
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) return;
    
    try {
      if (_isPlaying) {
        await stop();
      }
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint("TTS Stop Error: $e");
    }
  }

  Future<void> pause() async {
    try {
      await _flutterTts.pause();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint("TTS Pause Error: $e");
    }
  }

  void setSpeechRate(double rate) {
    _speechRate = rate;
    _flutterTts.setSpeechRate(rate);
    notifyListeners();
  }

  void setPitch(double pitch) {
    _pitch = pitch;
    _flutterTts.setPitch(pitch);
    notifyListeners();
  }

  void setVolume(double volume) {
    _volume = volume;
    _flutterTts.setVolume(volume);
    notifyListeners();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}