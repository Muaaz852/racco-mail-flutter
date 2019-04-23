import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String listTileTitle;
  final String onTapRoute;
  final IconData iconName;

  CustomListTile({this.listTileTitle, this.onTapRoute, this.iconName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconTheme(
            data: IconThemeData(
              color: Colors.white,
            ),
            child: Icon(iconName),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              listTileTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).pushNamed(onTapRoute);
      },
    );
  }
}
