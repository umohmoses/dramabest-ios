import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/login_page/controller/login_page_controller.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';

void showEmailLoginSheet() {
  Get.bottomSheet(
    const EmailLoginSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

/// Email and password sign-in, in one short form.
class EmailLoginSheet extends StatefulWidget {
  const EmailLoginSheet({super.key});

  @override
  State<EmailLoginSheet> createState() => _EmailLoginSheetState();
}

class _EmailLoginSheetState extends State<EmailLoginSheet> {
  final _email = TextEditingController(text: Preference.shared.getString(LoginPageController.rememberedEmailKey) ?? "");
  final _password = TextEditingController();
  bool _isSignUp = false;
  bool _hidePassword = true;
  bool _remember = true;
  bool _waitingForVerification = false;

  LoginPageController get _controller => Get.find<LoginPageController>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final needsVerification = await _controller.onEmailLogin(
      email: _email.text.trim(),
      password: _password.text,
      isSignUp: _isSignUp,
      remember: _remember,
    );
    if (needsVerification && mounted) setState(() => _waitingForVerification = true);
  }

  InputDecoration _field(String hint, {Widget? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: AppColor.colorWhite.withAlpha(25),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      );

  Widget _primaryButton(String label, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), gradient: AppColor.primaryGradient),
          child: Text(label, style: AppFontStyle.styleW700(AppColor.colorWhite, 16)),
        ),
      );

  Widget _textButton(String label, VoidCallback onTap) => TextButton(
        onPressed: onTap,
        child: Text(label, style: AppFontStyle.styleW600(AppColor.colorWhite, 14)),
      );

  List<Widget> _form() => [
        Text(_isSignUp ? "Create your account" : "Sign in with email", style: AppFontStyle.styleW700(AppColor.colorWhite, 20)),
        const SizedBox(height: 16),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          autofillHints: const [AutofillHints.email],
          style: const TextStyle(color: AppColor.colorWhite),
          decoration: _field("Email"),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _password,
          obscureText: _hidePassword,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: [_isSignUp ? AutofillHints.newPassword : AutofillHints.password],
          onSubmitted: (_) => _submit(),
          style: const TextStyle(color: AppColor.colorWhite),
          decoration: _field(
            _isSignUp ? "Password (at least 6 characters)" : "Password",
            suffix: IconButton(
              icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
              onPressed: () => setState(() => _hidePassword = !_hidePassword),
            ),
          ),
        ),
        CheckboxListTile(
          value: _remember,
          onChanged: (value) => setState(() => _remember = value ?? true),
          activeColor: AppColor.primaryColor,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text("Remember me", style: AppFontStyle.styleW600(AppColor.colorWhite, 14)),
        ),
        _primaryButton(_isSignUp ? "Create account" : "Sign in", _submit),
        if (!_isSignUp) _textButton("Forgot password?", () => _controller.onForgotPassword(_email.text.trim())),
        _textButton(
          _isSignUp ? "Already have an account? Sign in" : "New here? Create an account",
          () => setState(() => _isSignUp = !_isSignUp),
        ),
      ];

  List<Widget> _verification() => [
        const Icon(Icons.mark_email_unread_outlined, color: AppColor.colorWhite, size: 44),
        const SizedBox(height: 12),
        Text("Check your email", style: AppFontStyle.styleW700(AppColor.colorWhite, 20)),
        const SizedBox(height: 8),
        Text(
          "We sent a link to ${_email.text.trim()} from info@dramabest.com. Open it to confirm your email, then come back here. Please check your spam folder too.",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 16),
        _primaryButton("I've confirmed my email", _controller.onEmailVerified),
        _textButton("Send the link again", _controller.onResendVerification),
      ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.colorBlack,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(10)),
                ),
                AutofillGroup(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _waitingForVerification ? _verification() : _form(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
