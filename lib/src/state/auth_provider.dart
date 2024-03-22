import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pzdeals/src/services/fcmtoken_service.dart';

final authProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isUserAuthenticated = false;
  String _userUID = '';
  String _googleToken = '';
  String _email = '';
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'email',
    'profile',
    PeopleServiceApi.userGenderReadScope,
    PeopleServiceApi.userPhonenumbersReadScope,
    PeopleServiceApi.userBirthdayReadScope
  ]);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FcmTokenService fcmTokenService = FcmTokenService();

  bool get isAuthenticated => isUserAuthenticated;
  String get userUID => _userUID;
  String get googleToken => _googleToken;
  String get email => _email;

  //Google Sign-in
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        final AdditionalUserInfo? additionalUserInfo =
            authResult.additionalUserInfo;

        //retrieve additional user information from Google People API
        Map<String, dynamic> personInfo = await getGooglePersonInfo();

        // Retrieve additional user information from the GoogleSignInAccount object
        final googleUser = googleSignIn.currentUser;
        final String? email = googleUser?.email;

        _googleToken = googleSignInAuthentication.accessToken!;
        _email = email!;

        // Save the additional user information to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
          'firstName': additionalUserInfo?.profile!['given_name'],
          'lastName': additionalUserInfo?.profile!['family_name'],
          'email': email,
          'profilePicture': additionalUserInfo?.profile!['picture'],
          'gender': personInfo['gender'],
          'birthDate': personInfo['birthday'],
          'phoneNumber': personInfo['phoneNumber'],
          'uID': user.uid,
        });

        if (await isFcmTokenChanged(user.uid)) {
          updateFcmToken(user.uid);
        }

        setIsUserAuthenticated(true);
        setUserUID(user.uid);
        return user;
      }
    } on PlatformException catch (error) {
      debugPrint('PlatformException /Google sign-in error: $error');
      return null;
    } catch (error) {
      debugPrint('Google sign-in error: $error');
      return null;
    }
    return null;
  }

  Future<void> signOutGoogle() async {
    try {
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      setIsUserAuthenticated(false);
      setUserUID('');
      // Perform any additional sign-out related tasks
    } catch (error) {
      // Handle any errors that occur during sign-out
      debugPrint('Error signing out: $error');
    }
  }

  //Firebase Auth
  Future<Map<String, String>> signInEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      debugPrint('User logged in: ${userCredential.user!.uid}');
      setIsUserAuthenticated(true);
      setUserUID(userCredential.user!.uid);
      if (await isFcmTokenChanged(userCredential.user!.uid)) {
        updateFcmToken(userCredential.user!.uid);
      }
      return {'code': 'success', 'message': 'User logged in'};
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'user-disabled':
          errorMessage = 'Account has been disabled.';
          break;
        case 'wrong-password':
        case 'invalid-credential':
          errorMessage =
              'Invalid login attempt. Please check your credentials.';
          break;
        default:
          errorMessage = e.message ?? 'Unknown error';
          break;
      }
      return {'code': e.code, 'message': errorMessage};
    }
  }

  Future<void> signOutFirebaseAuth() async {
    setIsUserAuthenticated(false);
    setUserUID('');
    FirebaseAuth.instance.signOut();
  }

  Future<Map<String, String>> registerFirebaseUser(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      debugPrint('User registered: ${userCredential.user!.uid}');
      return {'code': 'success', 'message': userCredential.user!.uid};
    } on FirebaseAuthException catch (e) {
      debugPrint('Registration failed: $e.message');
      return {'code': 'error', 'message': e.message.toString()};
    }
  }

  Future<Map<String, String>> registerAccountInfo(
      Map<String, dynamic> userInfo, String userUID) async {
    try {
      final String? fcmToken = await _firebaseMessaging.getToken();
      userInfo['fcmToken'] = fcmToken;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .set(userInfo);
      await fcmTokenService.addUserFcmToken(userUID, fcmToken!);
      return {'code': 'success', 'message': 'success'};
    } on FirebaseException catch (e) {
      debugPrint('Registration failed: $e.message');
      return {'code': 'error', 'message': e.message.toString()};
    }
  }

  Future<Map<String, String>> resetFirebaseUserPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return {'code': 'success', 'message': 'success'};
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Reset password failed';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Invalid attempt.';
          break;
        case 'user-disabled':
          errorMessage = 'Account has been disabled.';
          break;
        case 'wrong-password':
        case 'invalid-credential':
          errorMessage = e.message ?? 'Invalid credentials.';
          break;
        default:
          errorMessage = e.message ?? 'Unknown error';
          break;
      }
      return {'code': e.code, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> getGooglePersonInfo() async {
    final httpClient = await googleSignIn.authenticatedClient();
    try {
      final response = await PeopleServiceApi(httpClient!).people.get(
            'people/me',
            personFields: 'birthdays,genders,phoneNumbers',
          );

      final Map<String, dynamic> birthday = {
        'year': response.birthdays?[0].date?.year,
        'month': response.birthdays?[0].date?.month,
        'day': response.birthdays?[0].date?.day,
      };

      final String? gender = response.genders?[0].value;
      final String? phoneNumber = response.phoneNumbers?[0].canonicalForm;

      return {
        "gender": gender,
        "birthday": birthday,
        "phoneNumber": phoneNumber,
      };
    } catch (e) {
      debugPrint('Error fetching person info: $e');
      throw Exception('Failed to fetch person info');
    }
  }

  void setIsUserAuthenticated(bool value) {
    debugPrint("setIsUserAuthenticated called with value: $value");
    isUserAuthenticated = value;
  }

  void setUserUID(String uid) {
    debugPrint("setUserUID called with value: $uid");
    _userUID = uid;
  }

  Future<bool> isFcmTokenChanged(String userUID) async {
    final String? fcmToken = await _firebaseMessaging.getToken();
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userUID).get();
    final String? savedFcmToken = userDoc.data()!['fcmToken'];

    return fcmToken != savedFcmToken;
  }

  Future<void> updateFcmToken(String userUID) async {
    final String? fcmToken = await _firebaseMessaging.getToken();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .update({'fcmToken': fcmToken});
    await fcmTokenService.updateUserFcmToken(userUID, fcmToken!);
  }
}
