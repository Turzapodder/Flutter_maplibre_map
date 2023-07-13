import 'package:barikoi_maplibre_map/utils/const.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final BuildContext scaffoldContext; // New parameter

  const CustomDrawer(this.scaffoldContext); // Constructor

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child:  Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text("Guest User", style: TextStyle(fontSize: 22),),
                    accountEmail: Text(" "),
                    currentAccountPicture: GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Container(
                            height: 80,
                            width: 80,
                            child: Center(child: Text("G", style: TextStyle(fontSize: 38, color: Colors.black),)),
                          ),
                        ),
                    ),

                    decoration: const BoxDecoration(
                      color: primaryColor,
                    ),
                  ),
                  ListTile(
                      title: Text("How to?"),
                      leading: Icon(Icons.help_outline_outlined),
                      onTap: () {
                      }
                  ),

                  ListTile(
                      title: Text("Privacy policy"),
                      leading: Icon(Icons.receipt_long_sharp),
                      onTap: () {
                      }
                  ),

                  ListTile(
                      title: Text("Log in"),
                      leading: Icon(Icons.login_outlined),
                      onTap: () {
                      }
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/img.png', // Replace with your image path
                width: double.infinity,
                height: 150,
                // You can customize the width, height, and other properties as per your requirement
              ),
            ),
          ],
        )
    );
  }
}
