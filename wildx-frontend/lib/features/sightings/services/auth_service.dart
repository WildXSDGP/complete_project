import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'backend_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '705159796565-vf87s62vfpd5eldg1s0gegs8i694hfi9.apps.googleusercontent.com',
  );

  // ── Input type detection ───────────────────────────────────
  bool isPhone(String input) {
    final s = input.trim().replaceAll(' ', '');
    return s.startsWith('+') || RegExp(r'^\d{9,}$').hasMatch(s);
  }

  bool isEmail(String input) =>
      RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(input.trim());

  // ── Email: Register ────────────────────────────────────────
  Future<AuthResult> registerWithEmail(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user;
      if (user == null) return AuthResult.failure('Registration failed.');
      await BackendService().loginToBackend();
      return AuthResult.success(UserModel(
        id: user.uid, email: user.email, authType: AuthType.email,
      ));
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapError(e.code));
    }
  }

  // ── Email: Login ───────────────────────────────────────────
  Future<AuthResult> loginWithEmail(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user;
      if (user == null) return AuthResult.failure('Login failed.');
      await BackendService().loginToBackend();
      return AuthResult.success(UserModel(
        id: user.uid, email: user.email, authType: AuthType.email,
      ));
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapError(e.code));
    }
  }

  // ── Email: Send sign-in link (forgot password) ─────────────
  Future<AuthResult> sendEmailLink(String email) async {
    try {
      final settings = ActionCodeSettings(
        url: 'https://wildx-6d2ef.firebaseapp.com/finishSignIn',
        handleCodeInApp: true,
        androidPackageName: 'com.wildx.wildx_login',
        androidInstallApp: true,
        androidMinimumVersion: '12',
        iOSBundleId: 'com.wildx.wildxLogin',
      );
      await _auth.sendSignInLinkToEmail(
        email: email.trim(),
        actionCodeSettings: settings,
      );
      return AuthResult.emailSent(email.trim());
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapError(e.code));
    }
  }

  // ── Phone: Send OTP ────────────────────────────────────────
  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onFailed,
    required void Function(PhoneAuthCredential credential) onAutoVerified,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),
      verificationCompleted: onAutoVerified,
      verificationFailed: (e) => onFailed(e.message ?? 'Verification failed.'),
      codeSent: (verificationId, _) => onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (_) {},
      timeout: const Duration(seconds: 60),
    );
  }

  // ── Phone: Verify OTP ──────────────────────────────────────
  Future<AuthResult> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) return AuthResult.failure('Login failed.');
      await BackendService().loginToBackend();
      return AuthResult.success(UserModel(
        id: user.uid, phoneNumber: user.phoneNumber, authType: AuthType.phone,
      ));
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapError(e.code));
    }
  }

  // ── Google Sign In ─────────────────────────────────────────
  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return AuthResult.failure('Google sign in cancelled.');
      final auth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) return AuthResult.failure('Google sign in failed.');
      await BackendService().loginToBackend();
      return AuthResult.success(UserModel(
        id: user.uid, email: user.email,
        displayName: user.displayName, photoUrl: user.photoURL,
        authType: AuthType.google,
      ));
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapError(e.code));
    } catch (e) {
      return AuthResult.failure('Google sign in error: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use': return 'Email already registered. Please login.';
      case 'user-not-found': return 'No account found. Please sign up.';
      case 'wrong-password':
      case 'invalid-credential': return 'Incorrect email or password.';
      case 'invalid-email': return 'Invalid email address.';
      case 'weak-password': return 'Password too weak. Use 6+ characters.';
      case 'invalid-phone-number': return 'Invalid phone number. Use: +94 77 123 4567';
      case 'too-many-requests': return 'Too many attempts. Try again later.';
      case 'invalid-verification-code': return 'Incorrect OTP. Please try again.';
      case 'session-expired': return 'OTP expired. Request a new one.';
      case 'network-request-failed': return 'Network error. Check connection.';
      default: return 'Something went wrong. ($code)';
    }
  }
}

// ── Result wrapper ─────────────────────────────────────────
class AuthResult {
  final AuthResultType type;
  final UserModel? user;
  final String? errorMessage;
  final String? email;

  const AuthResult._({required this.type, this.user, this.errorMessage, this.email});

  factory AuthResult.success(UserModel user) =>
      AuthResult._(type: AuthResultType.success, user: user);
  factory AuthResult.failure(String msg) =>
      AuthResult._(type: AuthResultType.failure, errorMessage: msg);
  factory AuthResult.emailSent(String email) =>
      AuthResult._(type: AuthResultType.emailSent, email: email);

  bool get isSuccess => type == AuthResultType.success;
  bool get isEmailSent => type == AuthResultType.emailSent;
}

enum AuthResultType { success, failure, emailSent }
