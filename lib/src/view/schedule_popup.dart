import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/history/history_model.dart';
import 'package:handey_app/src/business_logic/history/history_service.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/utils/ToDoCheckBtn.dart';
import 'package:handey_app/src/view/utils/exception_handler.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({@required this.selectedDay});

  final DateTime selectedDay;

  @override
  _HistoryScreenState createState() => new _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  ScreenSize size;
  int userId;
  TabController _tabController;

  DateTime _selectedDay;
  String selectedDayString;

  HistoryBoxModel historyBox;
  Future<HistoryBoxModel> futureHistoryBox;

  _fetchData() {
    userId = Provider.of<UserProvider>(context, listen: false).user.userId;
    selectedDayString = DateFormat("yyyy-MM-dd").format( _selectedDay);
    futureHistoryBox = getHistoryBox(userId, selectedDayString);
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    _selectedDay = widget.selectedDay;
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();

    return FutureBuilder(
        future: futureHistoryBox,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            handleException(context, snapshot.error);
          }
          if (snapshot.hasData) {
            historyBox = snapshot.data;
            return Container(
              height: MediaQuery.of(context).size.height * 0.58,
              child: Column(
                children: [
                  tabMenu(),
                  tabBody(_selectedDay),
                ],
              ),
            );
          } else {
            return Container(
                height: size.getSize(300),
                child: Center(child: CircularProgressIndicator()));
          }
        });
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
            child: Text('ToDo'),
          ),
          Tab(
            child: Text('Finished Weekly'),
          ),
        ],
      ),
    );
  }

  Widget tabBody(DateTime selectedDay) {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          HistoryToDoSection(toDoBoxHstList: historyBox.toDoBoxHstList),
          HistoryFwSection(fwBoxHstList: historyBox.fwBoxHstList,)
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


class HistoryToDoSection extends StatefulWidget {
  HistoryToDoSection({@required this.toDoBoxHstList});

  final List<ToDoBoxHstModel> toDoBoxHstList;

  @override
  _HistoryToDoSectionState createState() => _HistoryToDoSectionState();
}

class _HistoryToDoSectionState extends State<HistoryToDoSection> {
  ScreenSize size;
  int userId;

  List<ToDoBoxHstModel> toDoHistoryList;

  String selectedDayString;

  ScrollController _toDoHistoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    toDoHistoryList = widget.toDoBoxHstList;
  }

  @override
  void dispose() {
    _toDoHistoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();

    return historyToDoSection(toDoHistoryList);
  }

  Widget historyToDoSection(List<ToDoBoxHstModel> toDoHistoryList) {
    return Container(
      height: size.getSize(230),
      margin: EdgeInsets.only(bottom: size.getSize(8)),

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

  Widget toDoBox(ToDoBoxHstModel toDoHistoryBox) {
    return Container(

      padding: EdgeInsets.fromLTRB(size.getSize(12), size.getSize(8), size.getSize(0), size.getSize(8)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(size.getSize(5)),
        border: Border.all(color: Colors.white, width: 3.0),
        boxShadow: [
          BoxShadow(
            color: Color(0x979797),
            offset: Offset(2.0, 2.0), //(x,y)
            blurRadius: 2.0,
          ),
        ],
      ),
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
  
  Widget toDoElm(ToDoElmHstModel e) {
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

class HistoryFwSection extends StatefulWidget {
  HistoryFwSection({@required this.fwBoxHstList});

  final List<FwBoxHstModel> fwBoxHstList;

  @override
  _HistoryFwSectionState createState() => _HistoryFwSectionState();
}

class _HistoryFwSectionState extends State<HistoryFwSection> {
  ScreenSize size;
  int userId;

  List<FwBoxHstModel> fwBoxHstList;

  String selectedDayString;

  ScrollController _fwHistoryScrollController = ScrollController();

  @override
  void initState() {
    fwBoxHstList = widget.fwBoxHstList;
    super.initState();
  }

  @override
  void dispose() {
    ScrollController _fwHistoryScrollController = ScrollController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();
    return historyFwSection(fwBoxHstList);
  }

  Widget historyFwSection(List<FwBoxHstModel> fwHistoryList) {
    return Container(
      alignment: Alignment.topCenter,
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
          controller: _fwHistoryScrollController,
          child: ListView.separated(
              padding: EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: fwBoxHstList.length,
              itemBuilder: (context, index) {
                return fwBox(fwBoxHstList[index]);
              },
              separatorBuilder: (context, index) {
                return Space(height: 8);
              })
      )
    );
  }

  Widget fwBox(FwBoxHstModel fwHistoryBox) {
    return Container(
      child: Column(
        children: [
          fwTitle(fwHistoryBox.title),
          Space(height: 10),
          Column(children: fwHistoryBox.fwElmList.map((e) => fwElm(e)).toList()),
        ],
      ),
    );
  }

  Widget fwTitle(String title) {
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

  Widget fwElm(FwElmHstModel e) {
    return Padding(
      padding: EdgeInsets.only(top: size.getSize(2), bottom: size.getSize(2)),
      child: Row(
        children: [
          ToDoCheckBtn(value: true),
          Space(width: 10),
          Text(e.content ?? '', style: rTxtStyle,)
        ],
      ),
    );
  }
}
