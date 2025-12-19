import 'package:hive/hive.dart';
import '../../core/models/notification_model.dart';

class NotificationHiveService {
  static const String boxName = 'notifications';

  late Box<NotificationModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<NotificationModel>(boxName);
  }

  List<NotificationModel> getAll() =>
      _box.values.toList().reversed.toList();

  Future<void> add(NotificationModel notif) async {
    await _box.add(notif);
  }

  Future<void> markAsRead(NotificationModel notif) async {
    notif.isRead = true;
    await notif.save();
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  int get unreadCount =>
      _box.values.where((e) => !e.isRead).length;
}
