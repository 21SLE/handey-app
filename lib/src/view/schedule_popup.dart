import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';

class ScheduleHistoryScreen extends StatefulWidget {
  ScheduleHistoryScreen({@required this.selectedDay});

  final DateTime selectedDay;

  @override
  _ScheduleHistoryScreenState createState() => new _ScheduleHistoryScreenState();
}

class _ScheduleHistoryScreenState extends State<ScheduleHistoryScreen>
    with SingleTickerProviderStateMixin {
  ScreenSize size;
  TabController _tabController;

  DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    _selectedDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();

    return Container(
      height: MediaQuery.of(context).size.height * 0.58,
      child: Column(
        children: [
          tabMenu(),
          tabBody(_selectedDay),
        ],
      ),
    );
  }

  Widget tabMenu() {
    return Container(
      height: size.getSize(60),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.yellow,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(
            child: Text('일정'),
          ),
          Tab(
            child: Text('History'),
          ),
        ],
      ),
    );
  }

  Widget tabBody(DateTime selectedDay) {
    return Container(
      height: size.getSize(100),
      child: TabBarView(
        controller: _tabController,
        children: [
          scheduleSection(selectedDay),
          historySection()
        ],
      ),
    );
  }

  Widget scheduleSection(DateTime selectedDay) {
    return Container(
      alignment: Alignment.center,
      child: Text(selectedDay.toString()),
    );
  }

  Widget historySection() {
    return Container();
  }
}
