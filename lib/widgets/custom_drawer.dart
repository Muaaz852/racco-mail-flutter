import 'package:flutter/material.dart';

import './custom_list_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(30, 52, 70, 1),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
                SizedBox(
                  width: 30.0,
                ),
                Container(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset(
                    'images/logo-raccomail-esteso.png',
                    height: 45,
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Divider(
              color: Colors.white,
              height: 0.0,
            ),
            CustomListTile(
              listTileTitle: 'IMPOSTAZIONI',
              onTapRoute: '/Settings',
              iconName: Icons.settings,
            ),
            Divider(
              color: Colors.white,
              height: 0.0,
            ),
            CustomListTile(
              listTileTitle: 'INFO',
              onTapRoute: '/Info',
              iconName: Icons.info_outline,
            ),
            Divider(
              color: Colors.white,
              height: 0.0,
            ),
            CustomListTile(
              listTileTitle: 'PRIVACY',
              onTapRoute: '/Privacy',
              iconName: Icons.assistant,
            ),
            Divider(
              color: Colors.white,
              height: 0.0,
            ),
            CustomListTile(
              listTileTitle: 'Cerca PEC Mail',
              onTapRoute: '/SearchPECMail',
              iconName: Icons.search,
            ),
            Divider(
              color: Colors.white,
              height: 0.0,
            ),
          ],
        ),
      ),
    );
  }
}
