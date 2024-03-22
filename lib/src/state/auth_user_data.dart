import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pzdeals/src/models/user_data.dart';
import 'package:pzdeals/src/state/auth_provider.dart';
import 'package:pzdeals/src/utils/formatter/date_formatter.dart';

final authUserDataProvider = ChangeNotifierProvider<AuthUserData>((ref) {
  final authUserData = AuthUserData();
  authUserData.init(ref);
  return authUserData;
});

class AuthUserData extends ChangeNotifier {
  UserData? _userData;
  bool _isAuthenticated = false;

  UserData? get userData => _userData;
  bool get isAuthenticated => _isAuthenticated;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void init(ChangeNotifierProviderRef ref) {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        try {
          final userData =
              await _firestore.collection("users").doc(user.uid).get();
          if (userData.exists) {
            final data = userData.data() as Map<String, dynamic>;
            _userData = UserData(
              uid: user.uid,
              emailAddress: user.email,
              firstName: data['firstName'],
              lastName: data['lastName'] ?? "",
              phoneNumber: data['phoneNumber'] ?? "",
              birthDate: formatDateToDateTime(data['birthDate']),
              gender: data['gender'] ?? "",
              dateRegistered: user.metadata.creationTime,
            );

            _isAuthenticated = true;
          } else {
            await _auth.signOut();
            ref.read(authProvider).signOutGoogle();
          }
        } catch (e) {
          debugPrint("Error fetching user data: $e");
          await _auth.signOut();
          ref.read(authProvider).signOutGoogle();
        }
      } else {
        _userData = null;
        _isAuthenticated = false;
      }
      notifyListeners();
    });
  }
}
