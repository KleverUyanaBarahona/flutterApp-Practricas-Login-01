import 'package:flutter/material.dart';
import 'package:flutter_api_rest/utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
  @override
  Widget build(BuildContext context) {

    final Responsive responsive = Responsive.of(context);
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor)..rotateY(isDrawerOpen? -0.5:0),
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
          color: Colors.grey[200],

          borderRadius: BorderRadius.circular(isDrawerOpen?40:0.0)

      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: responsive.dp(3),),
          Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.menu),onPressed: (){},)
            ],
          )
        ],
      ),

    );
  }
}
