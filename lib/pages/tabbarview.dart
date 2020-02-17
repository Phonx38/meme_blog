import 'package:flutter/material.dart';


class tab extends StatefulWidget {
  @override
  _tabState createState() => _tabState();
}

class _tabState extends State<tab> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF3F5AA6),
              title: Text("Title text"),
              bottom: menu(),
            ),
            body: TabBarView(
              children: [
                Container(child: Icon(Icons.directions_car)),
                Container(child: Icon(Icons.directions_transit)),
                Container(child: Icon(Icons.directions_bike)),
                Container(child: Icon(Icons.directions_bike)),
              ],
            ),
          ),
        ),
      );
  }

   Widget menu() {
      return TabBar(
        tabs: [
          Tab(
            text: "Transactions",
            icon: Icon(Icons.euro_symbol),
          ),
          Tab(
            text: "Bills",
            icon: Icon(Icons.assignment),
          ),
          Tab(
            text: "Balance",
            icon: Icon(Icons.account_balance_wallet),
          ),
          Tab(
            text: "Options",
            icon: Icon(Icons.settings),
          ),
        ],
      );
    }
}