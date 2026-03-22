import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wildx_frontend/core/services/backend_service.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _i = AuthService._();
  factory AuthService() => _i;
  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn(
    clientId: '705159796565-vf87s62vfpd5eldg1s0gegs8i694hfi9.apps.googleusercontent.com',
  );

  bool isPhone(String s) {
    final t = s.trim().replaceAll(' ', '');
    return t.startsWith('+') || RegExp(r'^\d{9,}$').hasMatch(t);
  }
  bool isEmail(String s) =>
      RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(s.trim());

  Future<AuthResult> registerWithEmail(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      if (cred.user == null) return AuthResult.failure('Registration failed.');
      await BackendService().syncUserWithBackend();
      return AuthResult.success(UserModel(
          id: cred.user!.uid, email: cred.user!.email, authType: AuthType.email));
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_err(e.code));
    }
  }

  Future<AuthResult> loginWithEmail(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      if (cred.user == null) return AuthResult.failure('Login failed.');
      await BackendService().syncUserWithBackend();
      return AuthResult.success(UserModel(
          id: cred.user!.uid, email: cred.user!.email, authType: AuthType.email));
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_err(e.code));
    }
  }

  Future<AuthResult> sendEmailLink(String email) async {
    try {
      await _auth.sendSignInLinkToEmail(
        email: email.trim(),
        actionCodeSettings: ActionCodeSettings(
          url: 'https://wildx-6d2ef.firebaseapp.com/finishSignIn',
          handleCodeInApp: true,
          androidPackageName: 'com.wildx.wildx_login',
          androidInstallApp: true,
          androidMinimumVersion: '12',
          iOSBundleId: 'com.wildx.wildxLogin',
        ),
      );
      return AuthResult.emailSent(email.trim());
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_err(e.code));
    }
  }

  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String) onCodeSent,
    required void Function(String) onFailed,
    required void Function(PhoneAuthCredential) onAutoVerified,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),
      verificationCompleted: onAutoVerified,
      verificationFailed: (e) => onFailed(e.message ?? 'Verification failed.'),
      codeSent: (id, _) => onCodeSent(id),
      codeAutoRetrievalTimeout: (_) {},
      timeout: const Duration(seconds: 60),
    );
  }

  Future<AuthResult> verifyPhoneOtp(
      {required String verificationId, required String smsCode}) async {
    try {
      final cred = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      final r = await _auth.signInWithCredential(cred);
      if (r.user == null) return AuthResult.failure('Login failed.');
      await BackendService().syncUserWithBackend();
      return AuthResult.success(UserModel(
          id: r.user!.uid,
          phoneNumber: r.user!.phoneNumber,
          authType: AuthType.phone));
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_err(e.code));
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      final gUser = await _google.signIn();
      if (gUser == null) return AuthResult.failure('Cancelled.');
      final auth = await gUser.authentication;
      final cred = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      final r = await _auth.signInWithCredential(cred);
      if (r.user == null) return AuthResult.failure('Google sign in failed.');
      await BackendService().syncUserWithBackend();
      return AuthResult.success(UserModel(
          id: r.user!.uid,
          email: r.user!.email,
          displayName: r.user!.displayName,
          photoUrl: r.user!.photoURL,
          authType: AuthType.google));
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_err(e.code));
    } catch (e) {
      return AuthResult.failure('Google error: $e');
    }
  }

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }

  String _err(String code) {
    switch (code) {
      case 'email-already-in-use':    return 'Email already registered.';
      case 'user-not-found':          return 'No account found.';
      case 'wrong-password':
      case 'invalid-credential':      return 'Wrong email or password.';
      case 'invalid-email':           return 'Invalid email.';
      case 'weak-password':           return 'Password too weak (6+ chars).';
      case 'invalid-phone-number':    return 'Invalid phone. Use +94 77 123 4567';
      case 'too-many-requests':       return 'Too many attempts. Try later.';
      case 'invalid-verification-code': return 'Wrong OTP.';
      case 'network-request-failed':  return 'Network error.';
      default: return 'Something went wrong. ($code)';
    }
  }
}

class AuthResult {
  final AuthResultType type;
  final UserModel? user;
  final String? errorMessage;
  final String? email;
  const AuthResult._({required this.type, this.user, this.errorMessage, this.email});
  factory AuthResult.success(UserModel u)   => AuthResult._(type: AuthResultType.success, user: u);
  factory AuthResult.failure(String m)      => AuthResult._(type: AuthResultType.failure, errorMessage: m);
  factory AuthResult.emailSent(String e)    => AuthResult._(type: AuthResultType.emailSent, email: e);
  bool get isSuccess   => type == AuthResultType.success;
  bool get isEmailSent => type == AuthResultType.emailSent;
}
enum AuthResultType { success, failure, emailSent }
