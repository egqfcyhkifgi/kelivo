import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryProvider extends ChangeNotifier {
  static const String _memoryEnabledKey = 'memory_enabled';
  static const String _memoryContentKey = 'memory_content';
  
  bool _isMemoryEnabled = false;
  String _currentMemory = '';
  
  bool get isMemoryEnabled => _isMemoryEnabled;
  String get currentMemory => _currentMemory;

  MemoryProvider() {
    _loadMemorySettings();
  }

  Future<void> _loadMemorySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isMemoryEnabled = prefs.getBool(_memoryEnabledKey) ?? false;
      _currentMemory = prefs.getString(_memoryContentKey) ?? '';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading memory settings: $e');
    }
  }

  Future<void> setMemoryEnabled(bool enabled) async {
    try {
      _isMemoryEnabled = enabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_memoryEnabledKey, enabled);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving memory enabled setting: $e');
    }
  }

  Future<void> updateMemory(String content) async {
    try {
      _currentMemory = content;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_memoryContentKey, content);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving memory content: $e');
    }
  }

  Future<void> clearMemory() async {
    try {
      _currentMemory = '';
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_memoryContentKey);
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing memory: $e');
    }
  }

  String getMemoryForChat() {
    if (!_isMemoryEnabled || _currentMemory.isEmpty) {
      return '';
    }
    return 'Remember this information: $_currentMemory\n\n';
  }
}

