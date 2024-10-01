import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pzdeals/src/services/account_delete_service.dart';
import 'package:pzdeals/src/services/fcmtoken_service.dart';
import 'package:pzdeals/src/utils/helpers/generate_nonce.dart'
    as noncegenerator;
import 'package:pzdeals/src/utils/helpers/hash_value.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final authProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AccountDeleteService accountDeleteService = AccountDeleteService();
  bool isUserAuthenticated = false;
  String _userUID = '';
  String _googleToken = '';
  String _email = '';
  String _signInMethod = '';
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'email',
    'profile',
    // PeopleServiceApi.userGenderReadScope,
    // PeopleServiceApi.userPhonenumbersReadScope,
    // PeopleServiceApi.userBirthdayReadScope
  ]);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FcmTokenService fcmTokenService = FcmTokenService();

  bool get isAuthenticated => isUserAuthenticated;
  String get userUID => _userUID;
  String get googleToken => _googleToken;
  String get email => _email;
  String get signInMethod => _signInMethod;

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
        // Map<String, dynamic> personInfo = await getGooglePersonInfo();

        // Retrieve additional user information from the GoogleSignInAccount object
        final googleUser = googleSignIn.currentUser;
        final String? email = googleUser?.email;

        _googleToken = googleSignInAuthentication.accessToken!;
        _email = email!;

        // Save the additional user information to Firestore
        FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
          'firstName': additionalUserInfo?.profile!['given_name'],
          'lastName': additionalUserInfo?.profile!['family_name'],
          'email': email,
          'profilePicture': additionalUserInfo?.profile!['picture'],
          // 'gender': personInfo['gender'],
          // 'birthDate': personInfo['birthday'],
          // 'phoneNumber': personInfo['phoneNumber'],
          'gender': null,
          'birthDate': null,
          'phoneNumber': null,
          'uID': user.uid,
        });

        // if (await isFcmTokenChanged(user.uid)) {
        updateFcmToken(user.uid);
        // }

        setIsUserAuthenticated(true);
        setUserUID(user.uid);
        _signInMethod = 'google';
        saveSignInMethodToPrefs(_signInMethod);
        saveUserIdToPrefs(user.uid);
        return user;
      }
    } on PlatformException catch (error) {
      debugPrint('PlatformException /Google sign-in error: $error');
      return null;
    } catch (error, stackTrace) {
      debugPrint('Google sign-in error: $stackTrace');
      return null;
    }
    return null;
  }

  //Apple Sign-in
  Future<User?> signInWithApple() async {
    debugPrint('Apple sign-in initiated');
    final rawNonce = noncegenerator.generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
        nonce: nonce,
      );
      //https://pzdeals-b9228.firebaseapp.com/__/auth/handler
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(oauthCredential);

      final User? user = authResult.user;
      final AdditionalUserInfo? additionalUserInfo =
          authResult.additionalUserInfo;

      debugPrint('Apple sign-in successful - uid: ${user!.uid}');
      debugPrint('Apple sign-in successful - email: ${user.email}');
      debugPrint('Apple sign-in successful - displayName: ${user.displayName}');
      debugPrint(
          'Apple sign-in successful - profile: ${additionalUserInfo?.profile}');
      debugPrint('Apple sign-in successful - user: $user');

      String firstName = '';
      String lastName = '';
      String email = '';
      String phoneNumber = '';
      String profilePicture = '';
      String displayName = '';

      email = user.email ?? '';
      displayName = user.displayName ?? '';

      //if displayName is not null, split the name into first and last name
      final List<String> nameParts = displayName.split(' ');

      if (nameParts.length > 1) {
        firstName = nameParts[0];
        lastName = nameParts[1];
      } else {
        firstName = nameParts[0];
      }

      //if firstName is empty, get the first name from email
      if (firstName.isEmpty) {
        firstName = email.split('@')[0];
      }

      phoneNumber = user.phoneNumber ?? '';
      profilePicture = user.photoURL ?? '';

      //retrieve additional user information from Apple
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'profilePicture': profilePicture,
        'gender': '',
        'birthDate': null,
        'phoneNumber': phoneNumber,
        'uID': user.uid,
      });

      // if (await isFcmTokenChanged(user.uid)) {
      updateFcmToken(user.uid);
      // }

      setIsUserAuthenticated(true);
      setUserUID(user.uid);
      _signInMethod = 'apple';
      saveSignInMethodToPrefs(_signInMethod);
      saveUserIdToPrefs(user.uid);
      return user;
    } catch (e, stackTrace) {
      debugPrint('Apple sign-in error: $stackTrace');
      return null;
    }
  }

  // Future<void> signOutApple() async {
  //   try {
  //     _auth.signOut();
  //     setIsUserAuthenticated(false);
  //     setUserUID('');
  //   } catch (e, stackTrace) {
  //     debugPrint('Error signing out: $stackTrace');
  //   }
  // }

  Future<void> signOutGoogle() async {
    try {
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      setIsUserAuthenticated(false);
      setUserUID('');
      removeSignInMethodFromPrefs();
      removeUserIdFromPrefs();
      // Perform any additional sign-out related tasks
    } catch (error) {
      // Handle any errors that occur during sign-out
      debugPrint('Error signing out: $error');
    }
  }

  Future<void> deleteAccount() async {
    try {
      debugPrint('Deleting account: $_userUID');

      if (_userUID.isEmpty) {
        _userUID = await getUserIdFromPrefs();
      }

      await accountDeleteService.deleteAccountFromFirestore(_userUID);
      await accountDeleteService.deleteAccountFromDatabase(_userUID);
      await accountDeleteService.deleteAccountSettingsFromDatabase(_userUID);
      await accountDeleteService
          .deleteAccountForYouConfigFromDatabase(_userUID);
      // Attempt to delete the Firebase user account
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        if (_signInMethod == 'google') {
          await googleSignIn.disconnect();
          await googleSignIn.signOut();
        } else {
          await _auth.signOut();
        }
        setIsUserAuthenticated(false);
        setUserUID('');
        debugPrint('Firebase user account deleted successfully.');
        removeSignInMethodFromPrefs();
        removeUserIdFromPrefs();
      } else {
        debugPrint('No authenticated user found.');
      }
    } catch (error, stackTrace) {
      debugPrint('Error deleting account: $stackTrace');
    }
  }

  Future<bool> reauthenticateUser(String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        //reauthenticate via email and password
        if (signInMethod == '') {
          _signInMethod = await getSignInMethodFromPrefs();
        }
        if (signInMethod == 'email' && password.isNotEmpty) {
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );
          await user.reauthenticateWithCredential(credential);
          debugPrint('User reauthenticated with email');
          return true;
        } else if (signInMethod == 'google') {
          //reauthenticate via google
          final GoogleSignInAccount? googleSignInAccount =
              await googleSignIn.signIn();
          if (googleSignInAccount != null) {
            final GoogleSignInAuthentication googleSignInAuthentication =
                await googleSignInAccount.authentication;

            final AuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken,
            );
            await user.reauthenticateWithCredential(credential);
            debugPrint('User reauthenticated with Google');
            return true;
          }
        } else if (signInMethod == 'apple') {
          try {
            //reauthenticate via apple
            final rawNonce = noncegenerator.generateNonce();
            final nonce = sha256ofString(rawNonce);

            final appleCredential = await SignInWithApple.getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
              ],
              nonce: nonce,
            );
            //https://pzdeals-b9228.firebaseapp.com/__/auth/handler
            final oauthCredential = OAuthProvider("apple.com").credential(
              idToken: appleCredential.identityToken,
              rawNonce: rawNonce,
            );

            await user.reauthenticateWithCredential(oauthCredential);
            debugPrint('User reauthenticated with Apple');
            return true;
          } catch (e, stackTrace) {
            debugPrint('Reauthentication failed: $stackTrace');
            return false;
          }
        }
        return false;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Reauthentication failed: $e');
      return false;
    }
    return false;
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
      // if (await isFcmTokenChanged(userCredential.user!.uid)) {
      updateFcmToken(userCredential.user!.uid);
      // }
      _email = email.trim();
      _signInMethod = 'email';
      saveSignInMethodToPrefs(_signInMethod);
      saveUserIdToPrefs(userCredential.user!.uid);
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
    removeSignInMethodFromPrefs();
    removeUserIdFromPrefs();
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
      await fcmTokenService.updateUserFcmToken(userUID, fcmToken!, 'userId');
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
    debugPrint('authProvider: calling updateUserFcmToken');
    await fcmTokenService.updateUserFcmToken(userUID, fcmToken!, 'userId');
    await fcmTokenService.deleteInstanceIdFcmToken();
  }

  Future<void> saveSignInMethodToPrefs(String method) async {
    //save the sign-in method to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('signInMethod', method);
  }

  Future<String> getSignInMethodFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('signInMethod') ?? '';
  }

  Future<void> removeSignInMethodFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('signInMethod');
  }

  Future<void> saveUserIdToPrefs(String userId) async {
    //save the user id to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }

  Future<void> removeUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }
}
