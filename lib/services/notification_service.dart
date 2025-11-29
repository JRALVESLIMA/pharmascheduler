import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  ///Inicializa notificações e timezones
  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.actionId == 'confirm_action') {
          debugPrint("Agendamento confirmado!");
        } else if (response.actionId == 'reschedule_action') {
          debugPrint("Reagendar solicitado!");
        }
      },
    );

    tz.initializeTimeZones();
  }

  /// Metodo interno para agendar notificações
  static Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    DateTimeComponents? repeat,
    List<AndroidNotificationAction>? actions,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'pharma_channel',
      'Agendamentos',
      channelDescription: 'Notificações de agendamentos',
      importance: Importance.max,
      priority: Priority.high,
      actions: actions,
    );

    final details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: repeat,
    );
  }

  ///Notificação simples
  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required int id,
    required DateTime scheduledDate,
  }) async {
    await _schedule(
      id: id,
      title: title,
      body: body,
      dateTime: scheduledDate,
      repeat: DateTimeComponents.dateAndTime,
    );
  }

  ///Lembrete 30 minutos antes
  static Future<void> scheduleReminder({
    required String title,
    required String body,
    required int id,
    required DateTime scheduledDate,
  }) async {
    final reminderDate = scheduledDate.subtract(const Duration(minutes: 30));

    await _schedule(
      id: id,
      title: "Lembrete: $title",
      body: body,
      dateTime: reminderDate,
      repeat: DateTimeComponents.dateAndTime,
    );
  }

  ///Notificação diária no mesmo horário
  static Future<void> scheduleDaily({
    required String title,
    required String body,
    required int id,
    required int hour,
    required int minute,
  }) async {
    final now = DateTime.now();
    final firstSchedule = DateTime(now.year, now.month, now.day, hour, minute);

    await _schedule(
      id: id,
      title: title,
      body: body,
      dateTime: firstSchedule,
      repeat: DateTimeComponents.time,
    );
  }

  ///Notificação com ações
  static Future<void> scheduleWithActions({
    required String title,
    required String body,
    required int id,
    required DateTime scheduledDate,
  }) async {
    await _schedule(
      id: id,
      title: title,
      body: body,
      dateTime: scheduledDate,
      actions: const [
        AndroidNotificationAction('confirm_action', 'Confirmar'),
        AndroidNotificationAction('reschedule_action', 'Reagendar'),
      ],
    );
  }
}