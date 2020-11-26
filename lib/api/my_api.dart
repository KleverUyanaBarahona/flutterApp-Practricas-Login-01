import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_rest/pages/home_page.dart';
import 'package:flutter_api_rest/utils/auth.dart';
import 'package:flutter_api_rest/utils/dialogs.dart';
import 'package:meta/meta.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String puerto =  DotEnv().env['ORGANIZATION_ID'];
// ignore: non_constant_identifier_names
final String api_url = DotEnv().env['API_URL'];
// ignore: non_constant_identifier_names
final String api_key = DotEnv().env['API_KEY'];
// ignore: non_constant_identifier_names
//final String auth_url = DotEnv().env['AUTH_URL'];
final String auth_url = DotEnv().env['AUTH_URL'];

class MyAPI {

  MyAPI._internal();
  static MyAPI _instance = MyAPI._internal();
  static MyAPI get instance =>_instance;

  final Dio _dio = Dio();

  //
  Future<void> register(BuildContext context,
      {@required String username,
      @required String email,
      @required String password}) async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();
      final Response response = await this._dio.post(
          'https://curso-api-flutter.herokuapp.com/api/v1/register',
          data: {
            "username": username,
            "email": email,
            "password": password,
          });
      await Auth.instance.setSession(response.data);
      progressDialog.dismiss();
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (_) => false);
    } catch (e) {
      progressDialog.dismiss();
      if (e is DioError) {
        print(e.response.statusCode);
        print(e.response.data);
        Dialogs.info(context,
            title: "ERROR",
            content: e.response.statusCode == 409
                ? 'Duplicated email or username'
                : e.message);
      } else {
        print(e);
      }
    }
  }

  Future<void> login(BuildContext context,
      {
      @required String email,
      @required String password}) async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    //final String url = api_url.toString()+auth_url.toString();
    //print("url"+url);
    try {
      progressDialog.show();
      final Response response = await this._dio.post(
          api_url+auth_url,
          options: Options(headers: {"api-key": api_key}),
          data: {
            "username": email,
            "password": password,
            "grant_type": password
          });
      //print("resres"+email+response.data["data"]["attributes"]["email"]);
      await Auth.instance.setSession(response.data);
      progressDialog.dismiss();
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (_) => false);
    } catch (e) {
      progressDialog.dismiss();
      if (e is DioError) {
        print(e.response.statusCode);
        print(e.response.data);
        String message = e.message;
        if(e.response.statusCode==500){
          message = "User not found";
        }else if(e.response.statusCode==401){
          message = "Invalid password";
        }
        Dialogs.info(context,
            title: "ERROR",
            content: message);
      } else {
        print(e);
      }
    }
  }

  Future <dynamic> refresh() async {
    try{
      final Session session = await Auth.instance.getSession();
      var params =  {
        "refresh_token": session.refreshToken,
        "grant_type": "refresh_token"
      };
      print("fffff"+session.refreshToken);
      final Response response = await this._dio.post(
        api_url+auth_url,
        queryParameters: params
        ,options: Options(
        headers: {
          "authorization": session.tokenType+" "+session.accessToken,
          "api-key": api_key
        }
      ),
      );
      print("refres"+response.data.toString());
     return response.data;
    }catch(e){
      print(e);
      return null;
    }
  }

}
