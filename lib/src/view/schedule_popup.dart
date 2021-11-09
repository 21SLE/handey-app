import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:handey_app/src/view/utils/space.dart';

import 'home_stf.dart';

class ScheduleHistoryScreenMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScheduleHistoryScreen(),
    );
  }
}


class ScheduleHistoryScreen extends StatefulWidget {
  @override
  _ScheduleHistoryScreenState createState() => new _ScheduleHistoryScreenState();
}

class _ScheduleHistoryScreenState extends State<ScheduleHistoryScreen> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          CalendarWidget(),
          Space(height: 10),
          Container(
          decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
          child: new TabBar(
            controller: _controller,
            tabs: [
              new Tab(
                icon: const Icon(Icons.home),
                text: 'Address',
              ),
              new Tab(
                icon: const Icon(Icons.my_location),
                text: 'Location',
              ),
            ],
          ),
        ),
          Container(
            height: 80.0,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                new Card(
                  child: new ListTile(
                    leading: const Icon(Icons.home),
                    title: new TextField(
                      decoration: const InputDecoration(hintText: 'Search for address...'),
                    ),
                  ),
                ),
                new Card(
                  child: new ListTile(
                    leading: const Icon(Icons.location_on),
                    title: new Text('Latitude: 48.09342\nLongitude: 11.23403'),
                    trailing: new IconButton(icon: const Icon(Icons.my_location), onPressed: () {}),
                  ),
                ),
              ],
            ),
          ),],
      )
    );
  }
}
