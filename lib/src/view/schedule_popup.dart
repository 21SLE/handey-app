import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/history_after/afterhst_model.dart';
import 'package:handey_app/src/business_logic/history_after/afterhst_service.dart';
import 'package:handey_app/src/business_logic/history_todo/todohst_model.dart';
import 'package:handey_app/src/business_logic/history_todo/todohst_service.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/utils/ToDoCheckBtn.dart';
import 'package:handey_app/src/view/utils/exception_handler.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    return Expanded(
      // height: MediaQuery.of(context).size.height * 0.58 - size.getSize(100),
      child: TabBarView(
        controller: _tabController,
        children: [
          scheduleSection(selectedDay),
          HistorySection(selectedDay: selectedDay)
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
}

class ScheduleTile extends StatefulWidget {
  ScheduleTile({@required this.scheduleName, @required this.selectedDay});

  final String scheduleName;
  final DateTime selectedDay;
  @override
  _ScheduleTileState createState() => _ScheduleTileState();
}

class _ScheduleTileState extends State<ScheduleTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(widget.scheduleName)
        ],
      )
    );
  }


}


class HistorySection extends StatelessWidget {
  HistorySection({@required this.selectedDay});

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Container(
      padding: EdgeInsets.all(size.getSize(20)),
      child: Column(
        children: [
          HistoryToDoSection(selectedDay: selectedDay),
          HistoryAfterSection(selectedDay: selectedDay)
        ],
      ),
    );
  }
}


class HistoryToDoSection extends StatefulWidget {
  HistoryToDoSection({@required this.selectedDay});

  final DateTime selectedDay;

  @override
  _HistoryToDoSectionState createState() => _HistoryToDoSectionState();
}

class _HistoryToDoSectionState extends State<HistoryToDoSection> {
  ScreenSize size;
  int userId;

  List<ToDoHistoryModel> toDoHistoryList;
  Future<List<ToDoHistoryModel>> futureToDoHistoryList;

  String selectedDayString;

  ScrollController _toDoHistoryScrollController = ScrollController();

  _fetchData() {
    userId = Provider.of<UserProvider>(context, listen: false).user.userId;
    selectedDayString = DateFormat("yyyy-MM-dd").format(widget.selectedDay);
    futureToDoHistoryList = getToDoHistoryList(userId, selectedDayString);
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _toDoHistoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();

    return FutureBuilder(
        future: futureToDoHistoryList,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            handleException(context, snapshot.error);
          }
          if (snapshot.hasData) {
            toDoHistoryList = snapshot.data;
            return historyToDoSection(toDoHistoryList);
          } else {
            return Container(
                height: size.getSize(300),
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget historyToDoSection(List<ToDoHistoryModel> toDoHistoryList) {
    return Container(
      height: size.getSize(230),
      padding: EdgeInsets.fromLTRB(size.getSize(12), size.getSize(8), size.getSize(0), size.getSize(8)),
      margin: EdgeInsets.only(bottom: size.getSize(8)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(size.getSize(10)),
        border: Border.all(color: Colors.white, width: 3.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: SingleChildScrollView(
          controller: _toDoHistoryScrollController,
          child: ListView.separated(
              padding: EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: toDoHistoryList.length,
              itemBuilder: (context, index) {
                return toDoBox(toDoHistoryList[index]);
              },
              separatorBuilder: (context, index) {
                return Divider(thickness: 1.0);
              })
      ),
    );
  }

  Widget toDoBox(ToDoHistoryModel toDoHistoryBox) {
    return Container(
      child: Column(
        children: [
          toDoTitle(toDoHistoryBox.title),
          Space(height: 10),
          Column(children: toDoHistoryBox.toDoElmHstList.map((e) => toDoElm(e)).toList()),
        ],
      ),
    );
  }
  
  Widget toDoTitle(String title) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: size.getSize(22), width: size.getSize(8), color: Colors.yellow),
          Space(width: 12),
          Text(title ?? '', style: rTxtStyle)
        ],
      ),
    );
  }
  
  Widget toDoElm(ToDoElmHistoryModel e) {
    return Padding(
      padding: EdgeInsets.only(top: size.getSize(2), bottom: size.getSize(2)),
      child: Row(
        children: [
          ToDoCheckBtn(value: e.completed),
          Space(width: 10),
          Text(e.content ?? '', style: rTxtStyle,)
        ],
      ),
    );
  }
}

class HistoryAfterSection extends StatefulWidget {
  HistoryAfterSection({@required this.selectedDay});

  final DateTime selectedDay;

  @override
  _HistoryAfterSectionState createState() => _HistoryAfterSectionState();
}

class _HistoryAfterSectionState extends State<HistoryAfterSection> {
  ScreenSize size;
  int userId;

  List<AfterHistoryModel> afterHistoryList;
  Future<List<AfterHistoryModel>> futureAfterHistoryList;

  String selectedDayString;

  ScrollController _afterHistoryScrollController = ScrollController();

  _fetchData() {
    userId = Provider.of<UserProvider>(context, listen: false).user.userId;
    selectedDayString = DateFormat("yyyy-MM-dd").format(widget.selectedDay);
    futureAfterHistoryList = getAfterHistoryList(userId, selectedDayString);
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _afterHistoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();
    return Expanded(
      child: FutureBuilder(
          future: futureAfterHistoryList,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              handleException(context, snapshot.error);
            }
            if (snapshot.hasData) {
              afterHistoryList = snapshot.data;
              return historyAfterSection(afterHistoryList);
            } else {
              return Container(
                  height: size.getSize(300),
                  child: Center(child: CircularProgressIndicator()));
            }
          })
    );
  }

  Widget historyAfterSection(List<AfterHistoryModel> afterHistoryList) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(size.getSize(12), size.getSize(5), size.getSize(0), size.getSize(12)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(size.getSize(10)),
        border: Border.all(color: Colors.white, width: 3.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: SingleChildScrollView(
          controller: _afterHistoryScrollController,
          child: ListView.separated(
              padding: EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: afterHistoryList.length,
              itemBuilder: (context, index) {
                return afterElement(afterHistoryList[index], afterHistoryList[index].subtitle);
              },
              separatorBuilder: (context, index) {
                return Space(height: 8);
              })
      )
    );
  }

  Widget afterElement(AfterHistoryModel afterHistory, bool subtitleYn) {
    return subtitleYn
        ? Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: size.getSize(22),
                    width: size.getSize(8),
                    color: Colors.yellow),
                Space(width: 12),
                Text(afterHistory.content ?? '', style: rTxtStyle)
              ],
            ),
          )
        : Padding(
            padding:
                EdgeInsets.only(top: size.getSize(2), bottom: size.getSize(2)),
            child: Row(
              children: [
                ToDoCheckBtn(value: true),
                Space(width: 10),
                Text(
                  afterHistory.content ?? '',
                  style: rTxtStyle,
                )
              ],
            ),
          );
  }
}
