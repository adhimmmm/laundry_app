import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 1)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String body;

  @HiveField(2)
  final Map<String, dynamic> data;

  @HiveField(3)
  final DateTime receivedAt;

  @HiveField(4)
  bool isRead;

  NotificationModel({
    required this.title,
    required this.body,
    required this.data,
    required this.receivedAt,
    this.isRead = false,
  });
}
