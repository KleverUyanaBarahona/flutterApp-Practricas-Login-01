import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_api_rest/api/my_api.dart';
import 'package:flutter_api_rest/pages/login_page.dart';
import 'package:meta/meta.dart' show required;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Auth{
  Auth._internal();
  static var _instance = Auth._internal();
  static Auth get instance => _instance;

  final _storage = FlutterSecureStorage();
  final key = "SESSION";

  Completer _completer;

  Future<String> get accessToken async{
    if(_completer != null ){
      await _completer.future;
    }

    print("AccesToken");

    _completer =Completer();
    final Session session = await this.getSession();
    if(session != null){
      final DateTime currentDate = DateTime.now();
      final DateTime createdAt = session.createdAt;
      final int expiresIn = session.expiresIn;

      final int diff = currentDate.difference(createdAt).inSeconds;
      //final int diff = 7150;
      print("Time: ${expiresIn-diff}");
      if(expiresIn-diff>=60){
        print("Token alive");
        _completer.complete();
        return session.accessToken;
      }else{
        //MyAPI myAPI = MyAPI();
        //final Map<String,dynamic> data = await myAPI.refresh();
        final Map<String,dynamic> data = await MyAPI.instance.refresh();
        print("refresh token");
        if(data!=null){
         await this.setSession(data);
         _completer.complete();
         return data["data"]["attributes"]["accessToken"];
        }
        _completer.complete();
        return null;
      }
    }
    _completer.complete();
    print("session null");
    return null;
  }

  Future<void> setSession(Map<String,dynamic>data) async {

    final Session session = Session(
        accessToken: data["data"]["attributes"]["accessToken"],
        tokenType: data["data"]["attributes"]["tokenType"],
        refreshToken: data["data"]["attributes"]["refreshToken"],
        expiresIn: data["data"]["attributes"]["expiresIn"],
        createdAt: DateTime.now());
    //await Auth.instance.setSession(session);
    final String value = jsonEncode(session.toJson());
    await this._storage.write(key: key, value: value);
    print("Json_save:"+session.toJson().toString());
  }

  Future<Session> getSession()async {
   final String value = await this._storage.read(key: key);
   if(value!=null){
    final Map<String,dynamic> json = jsonDecode(value);
    final session = Session.fromJson(json);
    print("getSession"+session.toJson().toString());
    return session;
   }
   return null;
  }

  Future<void>logOut(BuildContext context)async{
   await this._storage.deleteAll();
   Navigator.pushNamedAndRemoveUntil(
       context,
       LoginPage.routeName, (_) => false);
  }
}

class Session{
  final String accessToken;
  final String tokenType;
  final String refreshToken;
  final int expiresIn;
  final DateTime createdAt;

  Session({
    @required this.accessToken,
    @required this.tokenType,
    @required this.refreshToken,
    @required this.expiresIn,
    @required this.createdAt
  });

  static Session fromJson(Map<String, dynamic> json) {
    return Session(
      accessToken: json['accessToken'],
      tokenType: json['tokenType'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
      createdAt: DateTime.parse(json['createAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accessToken": this.accessToken,
      "tokenType": this.tokenType,
      "refreshToken": this.refreshToken,
      "expiresIn": this.expiresIn,
      "createAt": this.createdAt.toString()
    };
  }
}
