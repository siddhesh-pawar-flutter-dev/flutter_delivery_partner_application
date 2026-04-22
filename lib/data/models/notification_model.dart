enum NotificationType { order, payment, review, account, system, gear }

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String description;
  final String time;
  final bool isUnread;
  final String? imageUrl;
  final String? actionLabel;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    this.isUnread = true,
    this.imageUrl,
    this.actionLabel,
    required this.createdAt,
  });

  NotificationModel copyWith({
    bool? isUnread,
  }) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      description: description,
      time: time,
      isUnread: isUnread ?? this.isUnread,
      imageUrl: imageUrl,
      actionLabel: actionLabel,
      createdAt: createdAt,
    );
  }
}
