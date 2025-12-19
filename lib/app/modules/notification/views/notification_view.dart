import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          Obx(() => controller.notifications.isEmpty
              ? const SizedBox()
              : IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmClearAll(context),
                )),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const _EmptyState();
        }

        final grouped = controller.groupedByDate;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: grouped.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DateHeader(entry.key),
                const SizedBox(height: 8),
                ...entry.value.map(
                  (notif) => _NotificationCard(
                    notif: notif,
                    onTap: () => controller.markRead(notif),
                    onDelete: () => controller.delete(notif),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        );
      }),
    );
  }

  void _confirmClearAll(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus semua notifikasi?'),
        content:
            const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearAll();
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= CARD ITEM =================
class _NotificationCard extends StatelessWidget {
  final dynamic notif;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notif,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = DateFormat('HH:mm').format(notif.receivedAt);

    return Dismissible(
      key: ValueKey(notif.key),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notif.isRead
                ? theme.cardColor
                : theme.colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                    theme.brightness == Brightness.dark
                        ? 0.2
                        : 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationIcon(isRead: notif.isRead),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: notif.isRead
                            ? FontWeight.w500
                            : FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif.body,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (!notif.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5757),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= ICON =================
class _NotificationIcon extends StatelessWidget {
  final bool isRead;
  const _NotificationIcon({required this.isRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: isRead
            ? Colors.grey.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isRead
            ? Icons.notifications_none_rounded
            : Icons.notifications_active_rounded,
        color: isRead ? Colors.grey : Colors.red,
        size: 22,
      ),
    );
  }
}

/// ================= DATE HEADER =================
class _DateHeader extends StatelessWidget {
  final String date;
  const _DateHeader(this.date);

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
    );
  }
}

/// ================= EMPTY STATE =================
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada notifikasi',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Notifikasi baru akan muncul di sini',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
