import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loundry_app/app/core/models/notification_model.dart';
import '../../../core/services/notification_hive_service.dart';

class NotificationController extends GetxController {
  final NotificationHiveService _hive = Get.find();
  final notifications = <NotificationModel>[].obs;

  bool get hasUnread => notifications.any((n) => !n.isRead);

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    notifications.assignAll(_hive.getAll());
    notifications.refresh();
  }

  void markAllAsRead() {
    for (var notif in notifications) {
      if (!notif.isRead) {
        _hive.markAsRead(notif);
      }
    }
    loadNotifications();
  }

  void markRead(NotificationModel notif) {
    _hive.markAsRead(notif);
    loadNotifications();
  }

  void delete(NotificationModel notif) async {
    await notif.delete();
    loadNotifications();
  }

  void clearAll() async {
    await _hive.clearAll();
    loadNotifications();
  }

  Map<String, List<NotificationModel>> get groupedByDate {
    final Map<String, List<NotificationModel>> map = {};
    final formatter = DateFormat('EEEE, dd MMM yyyy');

    for (final notif in notifications) {
      final key = formatter.format(notif.receivedAt);
      map.putIfAbsent(key, () => []).add(notif);
    }
    return map;
  }

  int get unreadCount => notifications.where((e) => !e.isRead).length;
}