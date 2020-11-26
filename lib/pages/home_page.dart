import 'package:flutter/material.dart';
import 'package:flutter_api_rest/utils/auth.dart';
import 'package:flutter_api_rest/utils/color_parse.dart';
import 'package:flutter_api_rest/widgets/drawerScreen.dart';
import 'package:flutter_api_rest/widgets/homeScreen.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("test"),backgroundColor: parseColor('#33929A'),),
      body: Center(child: Text(''),),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('ChainGo Tech',style: TextStyle(color: Colors.white),),
              decoration: BoxDecoration(
                color: parseColor('#33929A')
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: (){
                Navigator.pop(context, HomePage.routeName);
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap:()=> Auth.instance.logOut(context),
            )
          ],
        ),
      ),

    );
  }
}

/*
* class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(child: Text("Log Out"),
        onPressed: ()=> Auth.instance.logOut(context),
        ),
      ),
    );
  }
}*/