import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:story_box/growth/growth_config.dart';
import 'package:story_box/growth/referral_service.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/ui/refill/view/store_view.dart';
import 'package:story_box/utils/guest_gate.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

/// "Invite friends" card for the Earn Rewards page.
class InviteFriendsTile extends StatelessWidget {
  const InviteFriendsTile({super.key});

  @override
  Widget build(BuildContext context) {
    if (!GrowthConfig.referralEnabled) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        if (GuestGate.allow()) Get.to(() => const ReferralView());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [Color(0xFFed3a57), Color(0xFFff7a59)]),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: const Icon(Icons.group_add_rounded, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invite friends, earn ${GrowthConfig.referrerCoins} coins', style: AppFontStyle.styleW800(AppColor.colorWhite, 16)),
                  const SizedBox(height: 2),
                  Text(
                    GrowthConfig.vipCoinPrice > 0 ? 'Collect ${GrowthConfig.vipCoinPrice} coins = free VIP, no ads' : 'For every friend who joins with your link',
                    style: AppFontStyle.styleW500(AppColor.colorWhite.withValues(alpha: 0.9), 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Text('Invite', style: AppFontStyle.styleW700(AppColor.primaryColor, 14)),
            ),
          ],
        ),
      ),
    );
  }
}

class ReferralView extends StatefulWidget {
  const ReferralView({super.key});

  @override
  State<ReferralView> createState() => _ReferralViewState();
}

class _ReferralViewState extends State<ReferralView> {
  Map<String, dynamic>? data;
  bool loading = true;
  bool sending = false;
  final codeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    final d = await ReferralService.summary();
    if (!mounted) return;
    setState(() {
      data = d;
      loading = false;
    });
  }

  Future<void> _useCode() async {
    final code = codeCtrl.text.trim();
    if (code.isEmpty) return;
    setState(() => sending = true);
    final r = await ReferralService.claim(code, source: 'manual');
    if (!mounted) return;
    setState(() => sending = false);
    Utils.showToast(context, r.message);
    if (r.ok) {
      codeCtrl.clear();
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xff0D0B0A);
    const surface = Color(0xff1c1816);
    final d = data;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Invite friends', style: AppFontStyle.styleW700(AppColor.colorWhite, 18)),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: AppColor.primaryColor))
          : d == null
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('Could not load your invite link.', style: AppFontStyle.styleW500(AppColor.colorWhite, 15)),
                    TextButton(onPressed: _load, child: const Text('Try again')),
                  ]),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(colors: [Color(0xFFed3a57), Color(0xFFff7a59)]),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Earn ${d['referrerCoins']} coins for every friend', style: AppFontStyle.styleW800(AppColor.colorWhite, 20)),
                            const SizedBox(height: 6),
                            Text(
                              '${(d['newUserCoins'] ?? 0) > 0 ? 'Your friend gets ${d['newUserCoins']} welcome coins. ' : ''}'
                              'You get your coins when they sign up${(d['qualifyEpisodes'] ?? 0) > 0 ? ' and watch ${d['qualifyEpisodes']} episode${d['qualifyEpisodes'] == 1 ? '' : 's'}' : ''}.',
                              style: AppFontStyle.styleW500(AppColor.colorWhite.withValues(alpha: 0.92), 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your invite code', style: AppFontStyle.styleW500(Colors.white70, 13)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(child: SelectableText('${d['code']}', style: AppFontStyle.styleW800(AppColor.colorWhite, 22))),
                                IconButton(
                                  icon: const Icon(Icons.copy_rounded, color: Colors.white70),
                                  tooltip: 'Copy link',
                                  onPressed: () async {
                                    await Clipboard.setData(ClipboardData(text: '${d['link']}'));
                                    if (context.mounted) Utils.showToast(context, 'Invite link copied');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                icon: const Icon(Icons.share_rounded),
                                label: Text('Share invite link', style: AppFontStyle.styleW700(AppColor.colorWhite, 15)),
                                onPressed: () => SharePlus.instance.share(ShareParams(text: '${d['shareText']}', subject: 'Join me on Dramabest')),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _stat(surface, '${d['invited']}', 'Friends joined'),
                          const SizedBox(width: 12),
                          _stat(surface, '${d['coinsEarned']}', 'Coins earned'),
                          const SizedBox(width: 12),
                          _stat(surface, '${d['pending']}', 'Waiting'),
                        ],
                      ),
                      if ((d['pending'] ?? 0) > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('“Waiting” friends have joined but not watched enough episodes yet.', style: AppFontStyle.styleW400(Colors.white54, 12)),
                        ),
                      if (GrowthConfig.vipCoinPrice > 0) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.amber.withValues(alpha: 0.6))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('👑 Swap your coins for VIP', style: AppFontStyle.styleW800(Colors.amber, 17)),
                              const SizedBox(height: 6),
                              Text('Collect ${GrowthConfig.vipCoinPrice} coins and get VIP free: every episode unlocked and NO ADS.', style: AppFontStyle.styleW500(Colors.white70, 13)),
                              const SizedBox(height: 4),
                              Obx(() => Text('You have ${Preference.userCoin.value} coins.', style: AppFontStyle.styleW700(AppColor.colorWhite, 13))),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(foregroundColor: Colors.amber, side: const BorderSide(color: Colors.amber), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                  onPressed: () => Get.to(() => StoreView()),
                                  child: Text('Get VIP with coins', style: AppFontStyle.styleW700(Colors.amber, 14)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (d['canEnterCode'] == true) ...[
                        const SizedBox(height: 24),
                        Text('Were you invited?', style: AppFontStyle.styleW700(AppColor.colorWhite, 15)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: codeCtrl,
                                style: const TextStyle(color: Colors.white),
                                textCapitalization: TextCapitalization.characters,
                                decoration: InputDecoration(
                                  hintText: 'Enter invite code',
                                  hintStyle: const TextStyle(color: Colors.white38),
                                  filled: true,
                                  fillColor: surface,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                onPressed: sending ? null : _useCode,
                                child: sending ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Apply'),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (d['myInvite'] is Map && d['myInvite']['status'] == 'pending')
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'You joined with an invite. Watch ${d['myInvite']['episodesNeeded']} episode${d['myInvite']['episodesNeeded'] == 1 ? '' : 's'} to unlock your welcome coins.',
                            style: AppFontStyle.styleW500(Colors.white70, 13),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Text('How it works', style: AppFontStyle.styleW700(AppColor.colorWhite, 15)),
                      const SizedBox(height: 8),
                      _step('1', 'Share your link with friends.'),
                      _step('2', 'They install Dramabest from your link and sign up.'),
                      _step('3', 'You both get coins${(d['qualifyEpisodes'] ?? 0) > 0 ? ' after they watch their first episode${d['qualifyEpisodes'] == 1 ? '' : 's'}' : ''}.'),
                      const SizedBox(height: 8),
                      Text('One reward per new account and per phone.', style: AppFontStyle.styleW400(Colors.white38, 12)),
                    ],
                  ),
                ),
    );
  }

  Widget _stat(Color surface, String value, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            Text(value, style: AppFontStyle.styleW800(AppColor.colorWhite, 20)),
            const SizedBox(height: 2),
            Text(label, style: AppFontStyle.styleW500(Colors.white54, 12)),
          ]),
        ),
      );

  Widget _step(String n, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          CircleAvatar(radius: 12, backgroundColor: AppColor.primaryColor, child: Text(n, style: AppFontStyle.styleW700(AppColor.colorWhite, 12))),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppFontStyle.styleW500(Colors.white70, 13))),
        ]),
      );
}
