import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/login_page/api/auth_email_api.dart';
import 'package:story_box/ui/login_page/api/login_api.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart' hide User;

import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/custom_progress_dialog.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class LoginPageController extends GetxController {
  static const rememberedEmailKey = 'rememberedEmail';

  LoginUserModel? loginUserModel;

  int loginType = 2;
  bool isLoading = false;

  @override
  void onInit() async {
    /// FCM Token
    final fcmToken = await FirebaseMessaging.instance.getToken();

    /// Device Id
    final identity = await MobileDeviceIdentifier().getDeviceId();

    Utils.showLog("Device Id => $identity");
    Utils.showLog("FCM Token => $fcmToken");

    if (identity != null && fcmToken != null) {
      Preference.onSetFcmToken(fcmToken);
      Preference.onSetIdentity(identity);
    }

    super.onInit();
  }

  Future<void> updateLoginType(int type) async {
    loginType = type;
    update([Constant.onLoginType]);
  }

  /// Google Login
  Future<void> onGoogleLogin() async {
    try {
      Get.dialog(const CustomProgressDialog());

      UserCredential? userCredential = await signInWithGoogle();

      if (userCredential?.user?.email != null) {
        loginUserModel = await LoginApi.callApi(
          loginType: Utils.getLoginTypeValue(LoginType.GOOGLE),
          email: userCredential?.user?.email ?? "",
          identity: Preference.identity,
          fcmToken: Preference.fcmToken,
          name: userCredential?.user?.displayName ?? "",
          profilePic: userCredential?.user?.photoURL ?? '',
        );

        if (loginUserModel != null) {
          if (loginUserModel?.status == true) {
            String loginUserJson = jsonEncode(loginUserModel?.user?.toJson());
            await Preference.shared.setString(Preference.userData, loginUserJson);
            await Preference.onSetUserID(loginUserModel?.user?.id ?? "");
            await Preference.onIsLogin(true);
            Get.offAllNamed(AppRoutes.bottomBarPage);
            log("message UserID :: ${Preference.userId}");
          } else {
            await _cleanupGoogleSession();
            Utils.showToast(Get.context!, loginUserModel?.message ?? "");
          }
        } else {
          await _cleanupGoogleSession();
          Utils.showToast(Get.context!, EnumLocal.txtLoginFailedPleaseTryAgain.name.tr);
        }
      } else {
        Utils.showToast(Get.context!, EnumLocal.txtSomeThingWentWrong.name.tr);
        Utils.showLog("Google Login Failed !!");
      }
    } catch (e) {
      await _cleanupGoogleSession();
      log("Error in Google Login: $e");
      Utils.showToast(Get.context!, EnumLocal.txtAnErrorOccurredDuringLogin.name.tr);
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  Future<void> _cleanupGoogleSession() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Utils.showLog("Google session cleaned up");
    } catch (e) {
      Utils.showLog("Error cleaning up Google session: $e");
    }
  }

  /// Guest Login
  Future<void> onGuestLogin() async {
    try {
      Get.dialog(const CustomProgressDialog());

      loginUserModel = await LoginApi.callApi(
        loginType: Utils.getLoginTypeValue(LoginType.QUICK),
        email: Preference.identity,
        identity: Preference.identity,
        fcmToken: Preference.fcmToken,
        name: "Guest",
      );

      if (loginUserModel != null) {
        if (loginUserModel?.status == true) {
          String loginUserJson = jsonEncode(loginUserModel?.user?.toJson());
          await Preference.shared.setString(Preference.userData, loginUserJson);
          await Preference.onSetUserID(loginUserModel?.user?.id ?? "");
          await Preference.onIsLogin(true);
          Get.offAllNamed(AppRoutes.bottomBarPage);
          log("message UserID :: ${Preference.userId}");
        } else {
          Utils.showToast(Get.context!, loginUserModel?.message ?? "");
        }
      }

      String? userDataJson = Preference.shared.getString(Preference.userData);
      if (userDataJson != null) {
        Map<String, dynamic> userMap = jsonDecode(userDataJson);
        LoginUserModel loginUserModel = LoginUserModel.fromJson(userMap);
        log("loginUserModel :: ${loginUserModel.toJson()}");
      }
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  /// Apple Login
  Future<void> loginWithApple() async {
    try {
      Get.dialog(const CustomProgressDialog());

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      var auth = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final user = auth.user;

      log("oauthCredential :: $oauthCredential");
      log("user :: $user");

      if (user != null) {
        loginUserModel = await LoginApi.callApi(
          loginType: Utils.getLoginTypeValue(LoginType.APPLE),
          email: user.email ?? "",
          identity: Preference.identity,
          fcmToken: Preference.fcmToken,
          name: user.email ?? "",
          profilePic: user.photoURL ?? '',
        );

        if (loginUserModel != null) {
          String loginUserJson = jsonEncode(loginUserModel?.user?.toJson());
          await Preference.shared.setString(Preference.userData, loginUserJson);
          await Preference.onSetUserID(loginUserModel?.user?.id ?? "");
          await Preference.onIsLogin(true);
          Get.offAllNamed(AppRoutes.bottomBarPage);
          log("message UserID :: ${Preference.userId}");
        } else {
          Utils.showToast(Get.context!, loginUserModel?.message ?? "");
        }

        String? userDataJson = Preference.shared.getString(Preference.userData);
        if (userDataJson != null) {
          Map<String, dynamic> userMap = jsonDecode(userDataJson);
          LoginUserModel loginUserModel = LoginUserModel.fromJson(userMap);
          log("loginUserModel :: ${loginUserModel.toJson()}");
        }
      }
    } catch (e) {
      Utils.showToast(Get.context!, EnumLocal.txtSomeThingWentWrong.name.tr);
      log("Apple Login Error: $e");
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  /// Email and password sign-in. Returns true when the email still needs confirming.
  Future<bool> onEmailLogin({required String email, required String password, required bool isSignUp, required bool remember}) async {
    if (email.isEmpty || password.isEmpty) {
      Utils.showToast(Get.context!, "Please enter your email and password.");
      return false;
    }
    try {
      Get.dialog(const CustomProgressDialog());
      final auth = FirebaseAuth.instance;
      final credential = isSignUp
          ? await auth.createUserWithEmailAndPassword(email: email, password: password)
          : await auth.signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user == null) {
        Utils.showToast(Get.context!, EnumLocal.txtLoginFailedPleaseTryAgain.name.tr);
        return false;
      }
      // Remember me: keeps the email here, and offers to save the password in the phone's own password manager.
      if (remember) {
        await Preference.shared.setString(rememberedEmailKey, email);
        TextInput.finishAutofillContext();
      } else {
        await Preference.shared.remove(rememberedEmailKey);
        TextInput.finishAutofillContext(shouldSave: false);
      }
      if (!user.emailVerified) {
        await _sendVerificationEmail(user);
        return true;
      }
      await _finishEmailLogin(user);
      return false;
    } on FirebaseAuthException catch (e) {
      Utils.showToast(Get.context!, _emailErrorMessage(e.code));
      return false;
    } catch (e) {
      log("Email login error: $e");
      Utils.showToast(Get.context!, EnumLocal.txtAnErrorOccurredDuringLogin.name.tr);
      return false;
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  /// The user tapped "I've confirmed my email".
  Future<void> onEmailVerified() async {
    try {
      Get.dialog(const CustomProgressDialog());
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      final fresh = FirebaseAuth.instance.currentUser;
      if (fresh == null) {
        Utils.showToast(Get.context!, "Please sign in again.");
      } else if (!fresh.emailVerified) {
        Utils.showToast(Get.context!, "Your email isn't confirmed yet. Please open the link we sent you.");
      } else {
        await fresh.getIdToken(true); // the next request must carry the confirmed status
        await _finishEmailLogin(fresh);
      }
    } on FirebaseAuthException catch (e) {
      Utils.showToast(Get.context!, _emailErrorMessage(e.code));
    } catch (e) {
      log("Email verification check error: $e");
      Utils.showToast(Get.context!, EnumLocal.txtAnErrorOccurredDuringLogin.name.tr);
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  /// From info@dramabest.com; Firebase's own email is only the fallback.
  Future<void> _sendVerificationEmail(User user) async {
    final token = await user.getIdToken();
    if (token != null && await AuthEmailApi.sendVerification(token)) return;
    await user.sendEmailVerification(_returnToSignIn);
  }

  ActionCodeSettings get _returnToSignIn => ActionCodeSettings(url: "https://dramabest.com/?signin=1", handleCodeInApp: false);

  Future<void> onResendVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) await _sendVerificationEmail(user);
      Utils.showToast(Get.context!, "We sent the link again. Please check your inbox and spam folder.");
    } on FirebaseAuthException catch (e) {
      Utils.showToast(Get.context!, _emailErrorMessage(e.code));
    }
  }

  Future<void> onForgotPassword(String email) async {
    if (email.isEmpty) {
      Utils.showToast(Get.context!, "Please enter your email first.");
      return;
    }
    try {
      if (!await AuthEmailApi.sendPasswordReset(email)) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email, actionCodeSettings: _returnToSignIn);
      }
      Utils.showToast(Get.context!, "If that email has an account, we've sent a reset link.");
    } on FirebaseAuthException catch (e) {
      Utils.showToast(Get.context!, e.code == "user-not-found" ? "If that email has an account, we've sent a reset link." : _emailErrorMessage(e.code));
    }
  }

  Future<void> _finishEmailLogin(User user) async {
    final email = user.email ?? "";
    loginUserModel = await LoginApi.callApi(
      loginType: Utils.getLoginTypeValue(LoginType.EMAIL),
      email: email,
      identity: Preference.identity,
      fcmToken: Preference.fcmToken,
      name: user.displayName ?? email.split("@").first,
      profilePic: user.photoURL ?? "",
    );
    if (loginUserModel?.status == true) {
      await Preference.shared.setString(Preference.userData, jsonEncode(loginUserModel?.user?.toJson()));
      await Preference.onSetUserID(loginUserModel?.user?.id ?? "");
      await Preference.onIsLogin(true);
      Get.offAllNamed(AppRoutes.bottomBarPage);
    } else {
      await FirebaseAuth.instance.signOut();
      Utils.showToast(Get.context!, loginUserModel?.message ?? EnumLocal.txtLoginFailedPleaseTryAgain.name.tr);
    }
  }

  String _emailErrorMessage(String code) {
    switch (code) {
      case "invalid-email":
        return "Please enter a valid email address.";
      case "weak-password":
        return "Please use a password with at least 6 characters.";
      case "email-already-in-use":
        return "That email already has an account. Please sign in, or use Continue with Google.";
      case "invalid-credential":
      case "wrong-password":
      case "user-not-found":
        return "That email or password isn't right.";
      case "user-disabled":
        return "This account has been disabled.";
      case "too-many-requests":
        return "Too many attempts. Please wait a few minutes and try again.";
      case "network-request-failed":
        return "Please check your internet connection and try again.";
      case "operation-not-allowed":
        return "Email sign-in isn't available right now. Please use Continue with Google.";
      default:
        return EnumLocal.txtAnErrorOccurredDuringLogin.name.tr;
    }
  }

  /// Google Sign In Helper
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Sign out first to ensure account selection dialog appears
      await GoogleSignIn().signOut();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        Utils.showLog("Google Sign-In canceled by user");
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await FirebaseAuth.instance.signInWithCredential(credential);

      Utils.showLog("Google Login Email => ${result.user?.email}");
      Utils.showLog("Google Login isNewUser => ${result.additionalUserInfo?.isNewUser}");

      return result;
    } catch (error) {
      Utils.showLog("Google Login Error => $error");
      return null;
    }
  }
}
