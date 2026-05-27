import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/mocks/mock_data.dart';
import '../../../../shared/widgets/primary_button.dart';

class SelectGuestsScreen extends StatefulWidget {
  const SelectGuestsScreen({super.key});

  @override
  State<SelectGuestsScreen> createState() => _SelectGuestsScreenState();
}

class _SelectGuestsScreenState extends State<SelectGuestsScreen> {
  // Sets to track selected IDs
  final Set<String> _selectedFamilies = {};
  final Set<String> _selectedMembers = {};

  void _toggleFamily(Map<String, dynamic> family, bool? selected) {
    setState(() {
      final familyId = family['familyId'] as String;
      if (selected == true) {
        _selectedFamilies.add(familyId);
        for (var member in family['members']) {
          _selectedMembers.add(member['userId'] as String);
        }
      } else {
        _selectedFamilies.remove(familyId);
        for (var member in family['members']) {
          _selectedMembers.remove(member['userId'] as String);
        }
      }
    });
  }

  void _toggleMember(String familyId, String memberId, bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedMembers.add(memberId);
      } else {
        _selectedMembers.remove(memberId);
        _selectedFamilies.remove(familyId); // Uncheck family if a member is unchecked
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Guests', style: theme.textTheme.displayMedium),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search families or members...',
                prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: MockData.communityFamilies.length,
              itemBuilder: (context, index) {
                final family = MockData.communityFamilies[index];
                final familyId = family['familyId'] as String;
                final members = family['members'] as List<dynamic>;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  color: theme.cardTheme.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.05)),
                  ),
                  child: ExpansionTile(
                    shape: const Border(),
                    leading: Checkbox(
                      value: _selectedFamilies.contains(familyId),
                      onChanged: (val) => _toggleFamily(family, val),
                    ),
                    title: Text(
                      family['familyName'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${family['houseName']} • Ward ${family['wardNumber']}'),
                    children: members.map((member) {
                      final memberId = member['userId'] as String;
                      return ListTile(
                        contentPadding: const EdgeInsets.only(left: 72, right: 16),
                        title: Text(member['name']),
                        subtitle: Text(member['role']),
                        trailing: Checkbox(
                          value: _selectedMembers.contains(memberId),
                          onChanged: (val) => _toggleMember(familyId, memberId, val),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: PrimaryButton(
              text: 'Send Invitation (${_selectedMembers.length} selected)',
              onPressed: _selectedMembers.isEmpty ? null : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invitation sent successfully!')),
                );
                // Return to home/invites
                context.go('/home');
              },
            ),
          ),
        ],
      ),
    );
  }
}
