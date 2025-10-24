import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_config.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_provider_type.dart';
import 'package:shotgun_flutter/features/llm_executor/presentation/providers/llm_provider.dart';

/// Screen for executing LLM generation with streaming support
class LLMExecutorScreen extends ConsumerStatefulWidget {
  final String prompt;

  const LLMExecutorScreen({super.key, required this.prompt});

  @override
  ConsumerState<LLMExecutorScreen> createState() => _LLMExecutorScreenState();
}

class _LLMExecutorScreenState extends ConsumerState<LLMExecutorScreen> {
  LLMProviderType _selectedProvider = LLMProviderType.gemini;
  String _apiKey = '';
  String _model = 'gemini-2.0-flash-exp';
  double _temperature = 0.1;

  // Default models for each provider
  final Map<LLMProviderType, String> _defaultModels = {
    LLMProviderType.gemini: 'gemini-2.0-flash-exp',
    LLMProviderType.openai: 'gpt-4-turbo',
    LLMProviderType.deepseek: 'deepseek-chat',
    LLMProviderType.claude: 'claude-3-5-sonnet-20241022',
  };

  @override
  Widget build(BuildContext context) {
    final llmState = ref.watch(lLMNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Processing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showConfigDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Provider selector
          _buildProviderSelector(),
          const Divider(),

          // Main content area
          Expanded(
            child: llmState.when(
              data: (state) => state.when(
                initial: () => const Center(
                  child: Text(
                    'Ready to generate\nConfigure API key in settings',
                    textAlign: TextAlign.center,
                  ),
                ),
                generating: (response) => _buildStreamingView(response),
                completed: (diff) => _buildCompletedView(diff),
                cancelled: () => const Center(
                  child: Text('Generation cancelled'),
                ),
                error: (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: $message'),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),

          // Action buttons
          _buildActions(llmState),
        ],
      ),
    );
  }

  Widget _buildProviderSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Text('Provider:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButton<LLMProviderType>(
              value: _selectedProvider,
              isExpanded: true,
              items: LLMProviderType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getProviderDisplayName(type)),
                );
              }).toList(),
              onChanged: (provider) {
                if (provider != null) {
                  setState(() {
                    _selectedProvider = provider;
                    _model = _defaultModels[provider]!;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamingView(String response) {
    return Column(
      children: [
        LinearProgressIndicator(
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: SelectableText(
              response.isEmpty ? 'Waiting for response...' : response,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedView(String diff) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              const Text(
                'Generation completed',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${diff.length} characters',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const Divider(),
          SelectableText(
            diff,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(AsyncValue<LLMState> llmState) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: llmState.maybeWhen(
        data: (state) => state.maybeWhen(
          initial: () => ElevatedButton(
            onPressed: _apiKey.isEmpty ? null : _startGeneration,
            child: const Text('Generate Diff'),
          ),
          generating: (_) => ElevatedButton(
            onPressed: () => ref.read(lLMNotifierProvider.notifier).cancel(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel'),
          ),
          completed: (diff) => Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _proceedToApplyPatch(diff),
                  child: const Text('Apply Changes (Phase 5)'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _reset,
                child: const Text('Reset'),
              ),
            ],
          ),
          cancelled: () => ElevatedButton(
            onPressed: _reset,
            child: const Text('Reset'),
          ),
          error: (_) => ElevatedButton(
            onPressed: _reset,
            child: const Text('Reset'),
          ),
          orElse: () => const SizedBox(),
        ),
        orElse: () => const SizedBox(),
      ),
    );
  }

  void _startGeneration() {
    final config = LLMConfig(
      provider: _selectedProvider,
      apiKey: _apiKey,
      model: _model,
      temperature: _temperature,
    );

    ref.read(lLMNotifierProvider.notifier).startGeneration(
          prompt: widget.prompt,
          config: config,
        );
  }

  void _reset() {
    setState(() {
      // Keep provider and credentials, just reset state
    });
    ref.invalidate(lLMNotifierProvider);
  }

  void _proceedToApplyPatch(String diff) {
    // TODO: Navigate to Phase 5 (Patch Applier)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Phase 5 (Patch Applier) not yet implemented'),
      ),
    );
  }

  void _showConfigDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Configure ${_getProviderDisplayName(_selectedProvider)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'API Key'),
              obscureText: true,
              controller: TextEditingController(text: _apiKey),
              onChanged: (value) => _apiKey = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Model'),
              controller: TextEditingController(text: _model),
              onChanged: (value) => _model = value,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Temperature:'),
                Expanded(
                  child: Slider(
                    value: _temperature,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: _temperature.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _temperature = value;
                      });
                    },
                  ),
                ),
                Text(_temperature.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {}); // Trigger rebuild with new values
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _getProviderDisplayName(LLMProviderType provider) {
    switch (provider) {
      case LLMProviderType.gemini:
        return 'Google Gemini';
      case LLMProviderType.openai:
        return 'OpenAI';
      case LLMProviderType.deepseek:
        return 'DeepSeek';
      case LLMProviderType.claude:
        return 'Anthropic Claude';
    }
  }
}
