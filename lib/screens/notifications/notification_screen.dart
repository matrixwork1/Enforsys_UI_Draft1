import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _generateDummyNotifications();
  }

  List<NotificationItem> _generateDummyNotifications() {
    return [
      NotificationItem(
        id: '1',
        title: 'New Offence Submitted',
        body: 'Offence #C2603271252864 for plate ABC09 has been successfully recorded at Dewan Suarah.',
        timeAgo: '2 min ago',
        icon: Icons.assignment_turned_in_outlined,
        iconColor: const Color(0xFF10B981),
      ),
      NotificationItem(
        id: '2',
        title: 'OPN Alert — Overparked Vehicle',
        body: 'Vehicle JUD8898 at Jalan Pedada has exceeded the parking limit by 45 minutes.',
        timeAgo: '15 min ago',
        icon: Icons.timer_off_outlined,
        iconColor: const Color(0xFFEF4444),
      ),
      NotificationItem(
        id: '3',
        title: 'Printer Connected',
        body: 'Thermal printer "BT-Printer-001" has been successfully paired and is ready to use.',
        timeAgo: '1 hr ago',
        icon: Icons.print_outlined,
        iconColor: const Color(0xFF3B82F6),
        isRead: true,
      ),
      NotificationItem(
        id: '4',
        title: 'Shift Reminder',
        body: 'Your parking enforcement shift at Zone A starts in 30 minutes. Please prepare your equipment.',
        timeAgo: '2 hrs ago',
        icon: Icons.schedule_outlined,
        iconColor: const Color(0xFFF59E0B),
        isRead: true,
      ),
      NotificationItem(
        id: '5',
        title: 'System Update Available',
        body: 'Enforsys v2.1.4 is available with improved plate recognition and bug fixes.',
        timeAgo: '5 hrs ago',
        icon: Icons.system_update_outlined,
        iconColor: const Color(0xFF8B5CF6),
        isRead: true,
      ),
      NotificationItem(
        id: '6',
        title: 'Offence Payment Received',
        body: 'Payment of RM10.00 received for offence #C2603251100432. Status updated to PAID.',
        timeAgo: 'Yesterday',
        icon: Icons.payments_outlined,
        iconColor: const Color(0xFF10B981),
        isRead: true,
      ),
      NotificationItem(
        id: '7',
        title: 'Area Assignment Changed',
        body: 'You have been reassigned from Zone A to Zone C effective tomorrow. Check settings for details.',
        timeAgo: 'Yesterday',
        icon: Icons.location_on_outlined,
        iconColor: const Color(0xFFF97316),
        isRead: true,
      ),
      NotificationItem(
        id: '8',
        title: 'Weekly Summary Ready',
        body: 'Your weekly enforcement summary is ready. 23 offences issued, 8 OPNs created this week.',
        timeAgo: '2 days ago',
        icon: Icons.bar_chart_outlined,
        iconColor: const Color(0xFF6366F1),
        isRead: true,
      ),
    ];
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedIds.clear();
      }
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedIds.length == _notifications.length) {
        _selectedIds.clear();
      } else {
        _selectedIds.addAll(_notifications.map((n) => n.id));
      }
    });
  }

  void _deleteSelected() {
    if (_selectedIds.isEmpty) return;
    _showDeleteConfirmation(
      count: _selectedIds.length,
      onConfirm: () {
        setState(() {
          _notifications.removeWhere((n) => _selectedIds.contains(n.id));
          _selectedIds.clear();
          _isSelectionMode = false;
        });
      },
    );
  }

  void _showDeleteConfirmation({required int count, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 22),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Delete Notification',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        content: Text(
          count == 1
              ? 'Are you sure you want to delete this notification?'
              : 'Are you sure you want to delete $count notifications?',
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            if (unreadCount > 0)
              Text(
                '$unreadCount unread',
                style: const TextStyle(
                  color: Color(0xFFF5A623),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (_isSelectionMode) ...[
            TextButton(
              onPressed: _selectAll,
              child: Text(
                _selectedIds.length == _notifications.length ? 'Deselect All' : 'Select All',
                style: const TextStyle(
                  color: Color(0xFFF5A623),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.checklist_outlined, color: Colors.black87, size: 22),
              onPressed: _notifications.isNotEmpty ? _toggleSelectionMode : null,
              tooltip: 'Select',
            ),
          ],
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Selection mode header bar
                if (_isSelectionMode)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF7ED),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFFED7AA), width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5A623),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_selectedIds.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'selected',
                            style: TextStyle(
                              color: Color(0xFF92400E),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _toggleSelectionMode,
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Cancel'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6B7280),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Notification list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _buildNotificationTile(notification, index);
                    },
                  ),
                ),
              ],
            ),

      // Bottom delete button when in selection mode
      bottomNavigationBar: _isSelectionMode && _selectedIds.isNotEmpty
          ? Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom == 0
                    ? 16
                    : MediaQuery.of(context).padding.bottom + 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _deleteSelected,
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: Text(
                      'Delete ${_selectedIds.length} Notification${_selectedIds.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildNotificationTile(NotificationItem notification, int index) {
    final isSelected = _selectedIds.contains(notification.id);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        final completer = Future<bool>.delayed(Duration.zero, () => false);
        _showDeleteConfirmation(
          count: 1,
          onConfirm: () {
            setState(() {
              _notifications.removeWhere((n) => n.id == notification.id);
            });
          },
        );
        return completer;
      },
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (_isSelectionMode) {
            _toggleSelection(notification.id);
          }
        },
        onLongPress: () {
          if (!_isSelectionMode) {
            _toggleSelectionMode();
            _toggleSelection(notification.id);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFF7ED)
                : notification.isRead
                    ? Colors.white
                    : const Color(0xFFFFFBF5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFF5A623).withValues(alpha: 0.5)
                  : const Color(0xFFE5E7EB).withValues(alpha: 0.7),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selection checkbox or Icon
                if (_isSelectionMode) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF5A623) : Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFF5A623)
                              : const Color(0xFFD1D5DB),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                // Icon container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: notification.iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5A623),
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                color: const Color(0xFF1F2937),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.body,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 48,
              color: Color(0xFFD1D5DB),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'All Caught Up!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No notifications at the moment.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
