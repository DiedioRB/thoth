import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/usuario.dart';

class AuthHelper {
  static Future<User?> registerUsingEmailAndPassword(BuildContext context,
      {required String nome,
      required String email,
      required String senha}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      user = credential.user;
      await user!.updateDisplayName(nome);
      await user.reload();
      user = auth.currentUser;

      saveUser(
          name: nome,
          email: email,
          uid: FirebaseAuth.instance.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = "A senha é muito fraca!";
      } else if (e.code == 'email-already-in-use') {
        message = "E-mail já está em uso!";
      }
      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
          content: Text("Ocorreu um erro! Tente novamente mais tarde...")));
    }

    return user;
  }

  static void saveUser(
      {required String name,
      required String email,
      required String uid}) async {
    // final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Usuario usuario = Usuario(nome: name, email: email, temasReferences: []);
    usuario.create(uid: uid);
    // firestore.collection('usuarios').doc(uid).set({
    //   'nome': name,
    //   'email': email,
    // });
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
