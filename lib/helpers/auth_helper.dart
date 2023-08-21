import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthHelper {
  static Future<User?> registerUsingEmailAndPassword(
      {required String nome,
      required String email,
      required String senha}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: senha);
    user = credential.user;
    await user!.updateDisplayName(nome);
    await user.reload();
    user = auth.currentUser;

    return user;
  }

  static void saveUser({required String name, required String email}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    firestore.collection('usuarios').doc('userid:$timestamp').set({
      'nome':name,
      'email':email,
    });

  }

  static Future<User?> signIn(
      {required String email, required String senha}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: senha);
    user = credential.user;

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static void logout() {
    FirebaseAuth.instance.signOut();
  }
}
