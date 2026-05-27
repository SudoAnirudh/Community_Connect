import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../shared/widgets/modern_card.dart';
import '../../../../core/theme/app_colors.dart';

class InvitationCard extends StatefulWidget {
  final Map<String, dynamic> invitation;

  const InvitationCard({super.key, required this.invitation});

  @override
  State<InvitationCard> createState() => _InvitationCardState();
}

class _InvitationCardState extends State<InvitationCard> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.invitation['status'];
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _currentStatus = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ModernCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.invitation['imageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Hosted by ${widget.invitation['host']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.invitation['title'],
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(context, PhosphorIconsRegular.calendarBlank, '${widget.invitation['date']} at ${widget.invitation['time']}'),
                  const SizedBox(height: 8),
                  _buildInfoRow(context, PhosphorIconsRegular.mapPin, widget.invitation['venue']),
                  const SizedBox(height: 16),
                  
                  // RSVP Actions
                  if (_currentStatus == 'pending')
                    Row(
                      children: [
                        Expanded(
                          child: _buildRsvpButton(
                            context,
                            'Accept',
                            AppColors.primaryGreen,
                            () => _updateStatus('accepted'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRsvpButton(
                            context,
                            'Maybe',
                            AppColors.warning,
                            () => _updateStatus('maybe'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRsvpButton(
                            context,
                            'Decline',
                            AppColors.error,
                            () => _updateStatus('declined'),
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _currentStatus == 'accepted'
                            ? AppColors.primaryGreen.withOpacity(0.1)
                            : _currentStatus == 'maybe'
                                ? AppColors.warning.withOpacity(0.1)
                                : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'You responded: ${_currentStatus.toUpperCase()}',
                          style: TextStyle(
                            color: _currentStatus == 'accepted'
                                ? AppColors.primaryGreen
                                : _currentStatus == 'maybe'
                                    ? AppColors.warning
                                    : AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildRsvpButton(BuildContext context, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
