import 'package:flutter/material.dart';
import 'package:jokita/app/theme/colors_theme.dart';

// 1. DATA MODEL
class Command {
  final IconData icon;
  final String title;
  final String subtitle;
  final String category;

  const Command({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Command &&
          runtimeType == other.runtimeType &&
          title == other.title;

  @override
  int get hashCode => title.hashCode;
}

// 2. DUMMY DATA
final List<Command> allCommands = [
  const Command(icon: Icons.flight_takeoff, title: 'Book tickets', subtitle: 'Operator', category: 'Agent'),
  const Command(icon: Icons.summarize_outlined, title: 'Summarize', subtitle: 'gpt-4o', category: 'Command'),
  const Command(icon: Icons.video_camera_back_outlined, title: 'Screen Studio', subtitle: 'gpt-4o', category: 'Application'),
  const Command(icon: Icons.mic_none_outlined, title: 'Talk to Jarvis', subtitle: 'gpt-4o voice', category: 'Active'),
  const Command(icon: Icons.translate_outlined, title: 'Translate', subtitle: 'gpt-4o', category: 'Command'),
  const Command(icon: Icons.draw_outlined, title: 'Generate Image', subtitle: 'dall-e-3', category: 'Command'),
  const Command(icon: Icons.settings_outlined, title: 'Open Settings', subtitle: 'System', category: 'Application'),
];

// 3. WIDGET AUTOCOMPLETE YANG REUSABLE
class SearchMenuWidget extends StatelessWidget {
  const SearchMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Command>(
      displayStringForOption: (Command option) => option.title,
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Command> onSelected, Iterable<Command> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final Command option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(option.icon, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(option.title, style: Theme.of(context).textTheme.bodyLarge),
                                Text(option.subtitle, style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          Text(option.category, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<Command>.empty();
        }
        return allCommands.where((Command command) {
          return command.title.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
                 command.subtitle.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (Command selection) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: ${selection.title}')),
        );
        debugPrint('You just selected ${selection.title}');
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
          decoration: InputDecoration(
            hintText: 'Whats up?',
            hintStyle: TextStyle(color: AppColors.white),
            prefixIcon: const Icon(Icons.search, color: AppColors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.white),
            ),
          ),
        );
      },
    );
  }
}