import 'package:cade_voce/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;
  final UserService userService;

  AuthService(this.userService, this.auth, this.googleSignIn);

  Future<void> signIn() async {
    try {
      final credential = await _googleAuthCredential();
      if(credential != null) {
        await auth.signInWithCredential(credential);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<OAuthCredential?> _googleAuthCredential()async{
    try{
      final googleAccount = await googleSignIn.signIn();
      final googleAuth = await googleAccount?.authentication;
      return GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
    }catch(e){
      print(e);
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  User get user => auth.currentUser!;

  Stream<User?> get authStateChanges => auth.authStateChanges();
}
