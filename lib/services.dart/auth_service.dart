import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eshop/utils/constants.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  User? _user;

  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthService() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners(); // Notify listeners about the change in authentication state
    });
  }

  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      Fluttertoast.showToast(msg: 'Authenticating');

      final credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(Duration(seconds: 10));
      _setLoading(false);
      Fluttertoast.showToast(msg: 'Login Successful');
      if (credential.user != null) {
        _user = credential.user;
        notifyListeners();

        // Save login status
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        return true;
      }
      Fluttertoast.showToast(
        msg: 'Login Failed',
        backgroundColor: secondaryColor,
        textColor: Colors.white,
      );
    } catch (e) {
      print(e);
      _setLoading(false);
      Fluttertoast.showToast(msg: 'Login Failed: ${e.toString()}');
    }
    return false;
  }

  Future<bool> signup(String email, String password, String name) async {
    try {
      _setLoading(true);
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setLoading(false);
      if (credential.user != null) {
        _user = credential.user;
        await _firestore.collection('users').doc(user?.uid).set({
          'name': name,
          'email': email,
        });
        notifyListeners();
        Fluttertoast.showToast(msg: 'Account created successfully');
        return true;
      }
    } catch (e) {
      print(e);
      _setLoading(false);
      Fluttertoast.showToast(msg: 'Signup Failed: ${e.toString()}');
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      Fluttertoast.showToast(msg: 'Logged out');
      _user = null;
      notifyListeners();

      // Remove login status
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
