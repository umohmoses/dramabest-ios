import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:story_box/notification/push_token.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/refill/controller/refill_controller.dart';
import 'package:story_box/ui/splash_screen/controller/splash_controller.dart';
import 'package:story_box/utils/utils.dart';

class NotificationServices {
  static FirebaseMessaging? messaging;
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  static bool notificationVisit = false;
  static SplashScreenController splashScreenController = Get.find<SplashScreenController>();

  /// High importance makes Android pop the notification up (heads-up); showBadge adds the app icon badge.
  static const AndroidNotificationChannel alertsChannel = AndroidNotificationChannel(
    'dramabest_alerts',
    'Dramabest alerts',
    description: 'New episodes, rewards and account updates',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  static const AndroidNotificationDetails _alertDetails = AndroidNotificationDetails(
    'dramabest_alerts',
    'Dramabest alerts',
    channelDescription: 'New episodes, rewards and account updates',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_notification',
    playSound: true,
    enableVibration: true,
    channelShowBadge: true,
    ticker: 'Dramabest',
  );

  /// Creates the channel before any push can use it, and clears the badge now the app is open.
  static Future<void> _prepareAlerts() async {
    final plugin = flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_notification'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    final android = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(alertsChannel);
    await android?.deleteNotificationChannel('0'); // the old low-visibility channel
    await plugin.cancelAll();
  }

  ///--------------- In Main Screen ---------------///
  /// Runs in a separate background isolate (no Activity, no GetX controllers).
  /// Must be an entry point so release (AOT) builds keep it, must not request
  /// permissions (there is no screen to ask from), and must never throw.
  @pragma('vm:entry-point')
  static Future<void> backgroundNotification(RemoteMessage message) async {
    try {
      await _showBackgroundNotification(message);
    } catch (e) {
      Utils.showLog("Background notification error :: $e");
    }
  }

  static Future<void> _showBackgroundNotification(RemoteMessage message) async {
    Utils.showLog('Got a message!');
    Utils.showLog('Message data :: ${message.data}');

    if (message.notification != null) {
      Utils.showLog('Message Contained a Notification :: ${message.notification?.body}');
    }

    // The system already shows pushes that carry a notification while the app is in the
    // background. Showing it here as well would make every push appear twice.
    Utils.showLog('Handling background notification :: ${message.data}');
  }

  ///--------------- In Splash Screen ---------------///
  static Future<void> initFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    Utils.showLog("Setting :: $settings");
    try {
      await _prepareAlerts();
    } catch (e) {
      Utils.showLog("Notification channel setup error :: $e");
    }
    await messaging.getToken().then((value) {
      Utils.showLog("This is FCM token :: $value");
    });

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      Utils.showLog("NotificationVisit with start :: $notificationVisit");
      notificationVisit = !notificationVisit;
      Utils.showLog("NotificationVisit with SetState :: $notificationVisit");

      handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Utils.showLog("This is event log :: $event");
      handleMessage(event);
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        Utils.showLog('Got a message whilst in the foreground!');
        Utils.showLog('Message data :: ${message.data}');

        if (message.notification != null) {
          Utils.showLog('Message also contained a notification :: ${message.notification}');
        }

        // Handle notification type logic (COIN_PURCHASE -> close bottomsheet & open profile).
        // A drama push (SERIES) only opens the drama when the user taps it, never by itself.
        if (message.data['type']?.toString() != 'SERIES') handleNotificationType(message.data);

        const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_notification');
        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin?.initialize(const InitializationSettings(android: initializationSettingsAndroid),
            onDidReceiveNotificationResponse: (payload) {
          Utils.showLog("payload is:- $payload");

          handleMessage(message);
        });

        showNotificationWithSound(message);
      },
    );
  }

  static Future<void> handleMessage(RemoteMessage message) async {
    Utils.showLog("Handling Message Notification Data :: ${message.data}");
    handleNotificationType(message.data);
  }

  static Future<void> handleNotificationType(Map<String, dynamic> data) async {
    if (data.isEmpty) return;

    final String? type = data['type']?.toString();
    Utils.showLog("handleNotificationType :: Notification Type = $type");

    if (type == 'SERIES') {
      PushToken.openSeries(data); // daily pick / continue watching / admin message about a drama
      return;
    }

    if (type == 'COIN_PURCHASE') {
      // 2. Close bottom sheet if open
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }

      // 3. Close dialog if open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // 4. Update Profile API & Refill Controller data
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().profileApiCall();
      }

      if (Get.isRegistered<RefillController>()) {
        Get.find<RefillController>().getCoinPlanApi();
      }

      // 5. Navigate to Profile screen / BottomBar Profile tab
      if (Get.isRegistered<BottomBarController>()) {
        final bottomBarController = Get.find<BottomBarController>();
        bottomBarController.profileApiCall();
        bottomBarController.onChangeBottomBar(4); // Switch to Profile tab

        // Pop back sub-views (like store/wallet page) back to BottomBarPage
        Get.until((route) => Get.currentRoute == AppRoutes.bottomBarPage || route.isFirst);
      } else {
        Get.offAllNamed(AppRoutes.bottomBarPage);
      }
    }
  }

  static Future showNotificationWithSound(RemoteMessage message) async {
    Utils.showLog("Enter showNotificationWithSound");

    Utils.showLog("message.notification?.title :: ${message.notification?.title}");
    Utils.showLog("message.notification?.body :: ${message.notification?.body}");
    Utils.showLog("message.notification :: ${message.data}");
    Utils.showLog("message.notification :: ${message.data["image"]}");

    const platformChannelSpecifics = NotificationDetails(
      android: _alertDetails,
      iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
    );
    await flutterLocalNotificationsPlugin?.show(
      message.hashCode,
      message.notification?.title.toString(),
      message.notification?.body.toString(),
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }
}
