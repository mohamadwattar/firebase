import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> _authebticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBJss8ZKTUXJWHcw7LNOKLMHFu4JvnFhZ8');
    try {
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final resData = json.decode(res.body);
      //print(json.decode(res.body));
      if (resData['error'] != null) {
        throw "${resData['error']['message']}";
      }
      token = resData['idToken'];
      _userId = resData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(resData['expiresIn'])));
      autoLogOut();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    return _authebticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authebticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    print('logOut');
    _token = null;
    _userId = null;
    _expiryDate = null;

    notifyListeners();
  }

  set token(String? value) {
    _token = value;
    notifyListeners();
  }

  void autoLogOut() {
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry!), logOut);
  }
}
