import 'package:get/get.dart';
import '../../data/models/notification_model.dart';

class NotificationController extends GetxController {
  final _selectedTab = 0.obs;
  int get selectedTab => _selectedTab.value;

  final _notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    final now = DateTime.now();
    _notifications.value = [
      NotificationModel(
        id: '1',
        type: NotificationType.order,
        title: 'New Order Available',
        description: 'A premium catering delivery for **The Tech Hub** is available. Estimated earnings: \$24.50.',
        time: '2m ago',
        isUnread: true,
        actionLabel: 'View Details',
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.payment,
        title: 'Payment Processed',
        description: 'Your weekly earnings of \$482.00 have been successfully deposited to your linked bank account.',
        time: '1h ago',
        isUnread: true,
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      NotificationModel(
        id: '3',
        type: NotificationType.review,
        title: '5-Star Review',
        description: '"On time and very professional!" — Sarah M. from Global Logistics Partners.',
        time: '4h ago',
        isUnread: false,
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
      NotificationModel(
        id: '4',
        type: NotificationType.account,
        title: 'Account Verified',
        description: 'Your updated documents have been approved. You are now eligible for high-value orders.',
        time: '22h ago',
        isUnread: true,
        createdAt: now.subtract(const Duration(hours: 22)),
      ),
      NotificationModel(
        id: '5',
        type: NotificationType.system,
        title: 'System Maintenance',
        description: 'Scheduled maintenance tonight from 2:00 AM to 4:00 AM. App availability may be limited.',
        time: '1d ago',
        isUnread: false,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: '6',
        type: NotificationType.gear,
        title: 'New Gear Available',
        description: 'Upgrade your delivery kit with our new insulated Kinetic Thermal Bags.',
        time: '1d ago',
        isUnread: false,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDWvAGrEBfqEQWw8dcqtCy9XIeL01rDVFnRFG5yMrDxo53TPkLoeU5BbqE8FmIl8OukzcPKo8Bt3qLCO7oMCoHYIaYEOblauBBKhL3b5Wgqe9mZOiRv5sw_DRu9ltuc6XYyaVgDsBytGogN0i8AufM_5sDG7XVKn9mLE1OV2sbQ75UOQykX8r--iekPox2LgE8SdUo1yKoOTDqYpxfa9gT0rZYDNAY08odSXIj1izXHBZtfjY49cwRMShAOVezGl-VHb42GYDDDbjE',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  List<NotificationModel> get filteredNotifications {
    switch (selectedTab) {
      case 1: // Unread
        return _notifications.where((n) => n.isUnread).toList();
      case 2: // Archived/Read (Assuming Archived means Read for this mock)
        return _notifications.where((n) => !n.isUnread).toList();
      default: // All
        return _notifications;
    }
  }

  Map<String, List<NotificationModel>> get groupedNotifications {
    final filtered = filteredNotifications;
    final groups = <String, List<NotificationModel>>{};
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var n in filtered) {
      final date = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      String label;
      if (date == today) {
        label = 'Today';
      } else if (date == yesterday) {
        label = 'Yesterday';
      } else {
        label = 'Earlier';
      }
      
      if (!groups.containsKey(label)) {
        groups[label] = [];
      }
      groups[label]!.add(n);
    }
    
    return groups;
  }

  int get unreadCount => _notifications.where((n) => n.isUnread).length;

  void changeTab(int index) {
    _selectedTab.value = index;
  }

  void markAllAsRead() {
    _notifications.value = _notifications.map((n) => n.copyWith(isUnread: false)).toList();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isUnread: false);
      _notifications.refresh();
    }
  }
}
