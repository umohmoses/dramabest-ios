import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/guest_gate.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

/// Secure purchases of coins and VIP (server: /api/client/payments).
/// The SERVER sets the price and currency, the buyer pays on Stripe's, Paystack's or
/// Flutterwave's own page, and coins/VIP are added only after the server has
/// verified the payment with the gateway. No gateway keys are used in the app.
class SecureCheckout with WidgetsBindingObserver {
  SecureCheckout._();
  static final SecureCheckout instance = SecureCheckout._();

  static Map<String, dynamic>? catalog; // prices in the buyer's currency
  String? _ref;
  DateTime? _startedAt;
  bool _polling = false;
  bool _buying = false; // one purchase at a time: a double tap must not create two orders
  bool _observing = false;
  VoidCallback? _onDone;

  static String get _base => '${ApiConstant.getBaseURL()}api/client/payments';
  static Map<String, String> get _headers => {'key': ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};

  /// Hint only: the server detects the country from the IP address first (works even when the phone is set to en_US).
  /// Country from the phone's region setting (e.g. en_NG -> NG).
  static String country() {
    final m = RegExp(r'[_-]([A-Za-z]{2})\b').firstMatch(Platform.localeName);
    return m?.group(1)?.toUpperCase() ?? '';
  }

  static Future<Map<String, dynamic>?> loadCatalog() async {
    try {
      final r = await http.get(Uri.parse('$_base/catalog?country=${country()}'), headers: _headers);
      final j = jsonDecode(r.body);
      if (j is Map && j['status'] == true) catalog = Map<String, dynamic>.from(j['data']);
    } catch (e) {
      Utils.showLog('catalog failed: $e');
    }
    return catalog;
  }

  /// Local price for a plan from the catalogue: {price, symbol} or null.
  static Map<String, dynamic>? localPrice(String kind, String? planId) {
    final list = (catalog?[kind == 'vip' ? 'vipPlans' : 'coinPlans'] as List?) ?? const [];
    for (final p in list) {
      if (p is Map && p['planId'] == planId) return {'price': p['price'], 'symbol': p['symbol']};
    }
    return null;
  }

  /// When more than one gateway is available, the buyer chooses; each shows what it will charge
  /// (the server converts automatically when a gateway cannot charge the buyer's currency).
  static Future<String?> _chooseGateway(String kind, String planId) async {
    final opts = (catalog?['gatewayOptions'] as List?) ?? const [];
    if (opts.isEmpty) return null;
    if (opts.length == 1) return (opts.first as Map)['id'] as String?;
    Map? plan;
    for (final p in (catalog?[kind == 'vip' ? 'vipPlans' : 'coinPlans'] as List?) ?? const []) {
      if (p is Map && p['planId'] == planId) plan = p;
    }
    return Get.bottomSheet<String>(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Color(0xFF16161A), borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('Choose how to pay', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            for (final o in opts) _option(o as Map, plan),
          ]),
        ),
      ),
    );
  }

  /// How each gateway the server offers is shown in the chooser.
  static const Map<String, ({String name, String hint, String logo, Color color, Color tile})> _gatewayLooks = {
    'stripe': (name: 'Stripe', hint: 'Visa, Mastercard and more', logo: 'assets/icons/pay_stripe.png', color: Color(0xFF8A84FF), tile: Color(0xFF635BFF)),
    'flutterwave': (name: 'Flutterwave', hint: 'Card, bank transfer, USSD', logo: 'assets/icons/pay_flutterwave.png', color: Color(0xFFFF9B00), tile: Colors.white),
    'paystack': (name: 'Paystack', hint: 'Card, bank transfer, USSD', logo: 'assets/icons/paystack_image.png', color: Color(0xFF00C3F7), tile: Colors.white),
  };

  static Widget _option(Map o, Map? plan) {
    final id = o['id'] as String;
    final g = _gatewayLooks[id] ?? _gatewayLooks['flutterwave']!;
    final ch = (plan?['charges'] as Map?)?[id] as Map?;
    final price = ch == null ? '' : '${ch['symbol']}${ch['price']}';
    final brand = g.color;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFF0F0F12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: brand, width: 2)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (Get.isBottomSheetOpen == true) Get.back(result: id); // a second tap must not close the page underneath
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(children: [
              Container(
                width: 46,
                height: 46,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: g.tile, borderRadius: BorderRadius.circular(12)),
                child: Image.asset(g.logo, fit: BoxFit.contain),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(g.name, style: TextStyle(color: brand, fontSize: 19, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(g.hint, style: const TextStyle(color: Color(0xFFB4B4BC), fontSize: 14)),
                ]),
              ),
              const SizedBox(width: 8),
              Text(price, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> buy({required String kind, required String planId, VoidCallback? onDone}) async {
    if (planId.isEmpty || _buying) return;
    if (!GuestGate.allow()) return; // gateways need a real email
    _buying = true;
    try {
      if (catalog == null) await loadCatalog();
      final gateway = await _chooseGateway(kind, planId);
      if (((catalog?['gatewayOptions'] as List?)?.length ?? 0) > 1 && gateway == null) return; // sheet dismissed
      final r = await http.post(Uri.parse('$_base/orders'),
          headers: _headers,
          body: jsonEncode({'userId': Preference.userId, 'kind': kind, 'planId': planId, 'country': country(), 'currency': catalog?['currency'], 'gateway': gateway, 'platform': 'app'}));
      final j = jsonDecode(r.body);
      if (j is! Map || j['status'] != true) {
        Utils.showToast(Get.context!, (j is Map ? j['message'] : null) ?? 'Payment is not available right now.');
        return;
      }
      final data = Map<String, dynamic>.from(j['data']);
      _ref = data['ref'];
      _startedAt = DateTime.now();
      _onDone = onDone;
      if (!_observing) {
        WidgetsBinding.instance.addObserver(this);
        _observing = true;
      }
      final ok = await launchUrl(Uri.parse(data['checkoutUrl']), mode: LaunchMode.externalApplication);
      if (!ok) Utils.showToast(Get.context!, 'Could not open the payment page.');
      _poll();
    } catch (e) {
      Utils.showLog('order failed: $e');
      Utils.showToast(Get.context!, 'Payment is not available right now.');
    } finally {
      _buying = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _poll(); // back from the payment page
  }

  Future<void> _poll() async {
    if (_polling || _ref == null) return;
    _polling = true;
    try {
      for (var i = 0; i < 40 && _ref != null; i++) {
        final r = await http.get(Uri.parse('$_base/orders/$_ref?userId=${Preference.userId}'), headers: _headers);
        final j = jsonDecode(r.body);
        final o = (j is Map && j['status'] == true) ? Map<String, dynamic>.from(j['data']) : null;
        if (o != null && o['credited'] == true) {
          final model = await ProfileApi.callApi(); // refreshes coins
          if (o['kind'] == 'vip') await Preference.onIsVip(model?.user?.isVip ?? true);
          Utils.showToast(Get.context!, o['kind'] == 'vip' ? 'VIP activated. Enjoy all episodes!' : 'Coins added to your wallet.');
          _finish();
          return;
        }
        if (o != null && (o['status'] == 'failed' || o['status'] == 'expired')) {
          Utils.showToast(Get.context!, 'Payment was not completed.');
          _finish();
          return;
        }
        if (_startedAt != null && DateTime.now().difference(_startedAt!) > const Duration(minutes: 30)) {
          _finish();
          return;
        }
        await Future.delayed(const Duration(seconds: 3));
      }
    } catch (e) {
      Utils.showLog('poll failed: $e');
    } finally {
      _polling = false;
    }
  }

  void _finish() {
    final cb = _onDone;
    _ref = null;
    _onDone = null;
    cb?.call();
  }
}
