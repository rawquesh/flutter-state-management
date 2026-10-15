import 'package:flutter/material.dart';
import '../bloc_example/views/bloc_view.dart';
import '../getx_example/views/getx_view.dart';
import '../provider_example/views/provider_view.dart';
import '../riverpod_example/views/riverpod_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Lab'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          // Header introduction
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade600, Colors.deepPurple.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.school_rounded, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Learn Flutter State Management',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Explore how Provider, Riverpod, BLoC, and GetX solve the exact same problems '
                  '(Counter + Task List) with side-by-side code architectures.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Choose an Architecture to Inspect',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          // Provider Card
          _ModuleCard(
            title: '1. Provider',
            subtitle: 'ChangeNotifier, MultiProvider, context.watch & Consumer',
            tags: const ['ChangeNotifier', 'InheritedWidget', 'context.watch'],
            color: Colors.blue.shade700,
            icon: Icons.alt_route_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProviderView()),
              );
            },
          ),
          const SizedBox(height: 12),

          // Riverpod Card
          _ModuleCard(
            title: '2. Riverpod 3',
            subtitle: 'Compile-time safe, NotifierProvider, ConsumerWidget & ref.watch',
            tags: const ['ProviderScope', 'NotifierProvider', 'ref.watch', 'Compile-Safe'],
            color: Colors.teal.shade700,
            icon: Icons.waves_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RiverpodView()),
              );
            },
          ),
          const SizedBox(height: 12),

          // BLoC & Cubit Card
          _ModuleCard(
            title: '3. BLoC & Cubit',
            subtitle: 'Event-driven streams, BlocBuilder, emit() & enterprise predictability',
            tags: const ['Bloc', 'Cubit', 'Events & States', 'BlocBuilder'],
            color: Colors.purple.shade700,
            icon: Icons.account_tree_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BlocView()),
              );
            },
          ),
          const SizedBox(height: 12),

          // GetX Card
          _ModuleCard(
            title: '4. GetX',
            subtitle: 'Micro-framework with .obs, Obx, GetBuilder & context-free DI',
            tags: ['.obs & Rx', 'Obx', 'GetBuilder', 'Get.put'],
            color: Colors.orange.shade800,
            icon: Icons.flash_on_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GetXView()),
              );
            },
          ),
          const SizedBox(height: 24),

          // Quick Comparison Table Card
          _buildComparisonSection(context, theme),
        ],
      ),
    );
  }

  Widget _buildComparisonSection(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.compare_arrows_rounded, color: Colors.indigo.shade700),
                const SizedBox(width: 8),
                Text(
                  'Quick Comparison Cheat Sheet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 18,
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                columns: const [
                  DataColumn(label: Text('Package')),
                  DataColumn(label: Text('Needs Context?')),
                  DataColumn(label: Text('Boilerplate')),
                  DataColumn(label: Text('Best Used For')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Provider', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Text('Yes (context.watch)')),
                    DataCell(Text('Low - Medium')),
                    DataCell(Text('Small-to-medium apps, official starting point')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Riverpod', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Text('No (uses WidgetRef)')),
                    DataCell(Text('Low')),
                    DataCell(Text('Modern apps, clean dependency injection & testing')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('BLoC', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Text('Yes (tree-scoped)')),
                    DataCell(Text('Medium - High')),
                    DataCell(Text('Enterprise, strict architecture, event tracking')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('GetX', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Text('No (Get.find)')),
                    DataCell(Text('Minimal')),
                    DataCell(Text('Rapid prototyping, all-in-one ecosystem')),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> tags;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    radius: 22,
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: tags
                    .map(
                      (tag) => Chip(
                        label: Text(
                          tag,
                          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: color.withValues(alpha: 0.08),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
