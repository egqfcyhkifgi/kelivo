import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:BuildX/l10n/app_localizations.dart';
import '../../../icons/lucide_adapter.dart';
import '../../../core/providers/memory_provider.dart';
import '../../../shared/widgets/ios_switch.dart';

class MemoryPage extends StatefulWidget {
  const MemoryPage({super.key});

  @override
  State<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  final TextEditingController _memoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final memoryProvider = Provider.of<MemoryProvider>(context, listen: false);
      _memoryController.text = memoryProvider.currentMemory;
    });
  }

  @override
  void dispose() {
    _memoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Lucide.Check),
            onPressed: () => _saveMemory(),
          ),
        ],
      ),
      body: Consumer<MemoryProvider>(
        builder: (context, memoryProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Memory Toggle
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Lucide.Brain,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enable Memory',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                'Allow the AI to remember context from previous conversations',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IosSwitch(
                          value: memoryProvider.isMemoryEnabled,
                          onChanged: (value) {
                            memoryProvider.setMemoryEnabled(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Memory Content
                Text(
                  'Memory Content',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add important information that the AI should remember across conversations',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 12),
                
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _memoryController,
                        maxLines: null,
                        expands: true,
                        enabled: memoryProvider.isMemoryEnabled,
                        decoration: InputDecoration(
                          hintText: 'Enter information you want the AI to remember...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: memoryProvider.isMemoryEnabled ? _clearMemory : null,
                        icon: const Icon(Lucide.Trash2),
                        label: const Text('Clear'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: memoryProvider.isMemoryEnabled ? _saveMemory : null,
                        icon: const Icon(Lucide.Check),
                        label: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveMemory() {
    final memoryProvider = Provider.of<MemoryProvider>(context, listen: false);
    memoryProvider.updateMemory(_memoryController.text);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Memory saved successfully'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _clearMemory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Memory'),
        content: const Text('Are you sure you want to clear all memory content? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final memoryProvider = Provider.of<MemoryProvider>(context, listen: false);
              memoryProvider.clearMemory();
              _memoryController.clear();
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Memory cleared successfully'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}