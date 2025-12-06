import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/tts_provider.dart';
import '../providers/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary,
                  colorScheme.secondary,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        LucideIcons.bot,
                        color: Colors.white,
                        size: 30,
                      ),
                    ).animate().scale(delay: 200.ms),
                    const SizedBox(height: 16),
                    Text(
                      'الذكي العربي',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),
                    Text(
                      'مساعدك الذكي الشخصي',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.3),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: LucideIcons.messageCircle,
                  title: 'محادثة جديدة',
                  onTap: () {
                    context.read<ChatProvider>().clearMessages();
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: LucideIcons.volume2,
                  title: 'إعدادات الصوت',
                  onTap: () {
                    Navigator.pop(context);
                    _showTTSSettings(context);
                  },
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return _buildDrawerItem(
                      context,
                      icon: themeProvider.isDarkMode
                          ? LucideIcons.sun
                          : LucideIcons.moon,
                      title: themeProvider.isDarkMode
                          ? 'الوضع النهاري'
                          : 'الوضع الليلي',
                      onTap: () {
                        themeProvider.toggleTheme();
                      },
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: LucideIcons.info,
                  title: 'حول التطبيق',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: LucideIcons.settings,
                  title: 'الإعدادات',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('الإعدادات قريباً'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    ).animate().fadeIn().slideX(begin: -0.3);
  }

  void _showTTSSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const TTSSettingsSheet(),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حول التطبيق'),
        content: const Text(
          'الذكي العربي هو تطبيق محادثة ذكي يدعم اللغة العربية مع ميزات تحويل النص إلى كلام.\n\nتم تطويره باستخدام Flutter.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}

class TTSSettingsSheet extends StatelessWidget {
  const TTSSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إعدادات الصوت',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Consumer<TTSProvider>(
            builder: (context, ttsProvider, child) {
              return Column(
                children: [
                  _buildSlider(
                    context,
                    title: 'سرعة الكلام',
                    value: ttsProvider.speechRate,
                    min: 0.1,
                    max: 1.0,
                    onChanged: ttsProvider.setSpeechRate,
                  ),
                  _buildSlider(
                    context,
                    title: 'نبرة الصوت',
                    value: ttsProvider.pitch,
                    min: 0.5,
                    max: 2.0,
                    onChanged: ttsProvider.setPitch,
                  ),
                  _buildSlider(
                    context,
                    title: 'مستوى الصوت',
                    value: ttsProvider.volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: ttsProvider.setVolume,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ttsProvider.speak('هذا اختبار للصوت العربي');
                    },
                    child: const Text('اختبار الصوت'),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context, {
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 20,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}