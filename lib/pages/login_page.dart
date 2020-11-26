import 'package:flutter/material.dart';
import 'package:flutter_api_rest/utils/color_parse.dart';
import 'package:flutter_api_rest/utils/responsive.dart';
import 'package:flutter_api_rest/widgets/circle.dart';
import 'package:flutter_api_rest/widgets/icon_container.dart';
import 'package:flutter_api_rest/widgets/login_form.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    final double pinkSize = responsive.wp(80);
    final double orangeSize = responsive.wp(57);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: responsive.height,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: -orangeSize * 0.0,
                  left: -orangeSize * 0.15,
                  child: Circle(
                    size: orangeSize+10,
                    colors: [
                      parseColor('#42D1DD'),
                      parseColor('#33929A'),
                    ],
                  ),
                ),
                Positioned(
                  top: -pinkSize * 0.4,
                  right: -pinkSize * 0.2,
                  child: Circle(
                    size: pinkSize,
                    colors: [
                      parseColor('#42D1DD'),
                      parseColor('#33929A'),
                    ],
                  ),
                ),
                Positioned(
                  top: -orangeSize * 0.55,
                  left: -orangeSize * 0.15,
                  child: Circle(
                    size: orangeSize,
                    colors: [
                      parseColor('#33929A'),
                      parseColor('#42D1DD'),
                    ],
                  ),
                ),
                Positioned(
                  top: pinkSize * 0.35,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: responsive.dp(8),
                      ),
                      IconContainer(
                        size: responsive.isTablet?responsive.wp(30):responsive.wp(40),
                      ),
                      SizedBox(
                        height: responsive.dp(3),
                      ),
                      /*Text(
                        "Hello Again\nWelcome Back!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: responsive.dp(1.6),
                        ),
                      ),*/
                      SizedBox(
                        height: responsive.dp(2),
                      ),
                      /*SvgPicture.asset(
                        'assets/logo_chaingo.svg',
                        width: responsive.dp(25),
                        height: responsive.dp(25),

                      ),*/
                      LoginForm()
                    ],
                  ),
                ),
                //LoginForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
