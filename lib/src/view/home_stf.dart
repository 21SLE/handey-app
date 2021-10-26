import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/todo/todo_model.dart';
import 'package:handey_app/src/business_logic/todo/todo_provider.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/utils/ToDoCheckBtn.dart';
import 'package:handey_app/src/view/utils/border.dart';
import 'package:handey_app/src/view/utils/exception_handler.dart';
import 'package:handey_app/src/business_logic/todo/todo_service.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:provider/provider.dart';

class HomeStf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Space(height: 20),
                WelcomeText(),
                Space(height: 12),
                CalendarWidget(),
                Space(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                      controller: scrollController,
                      child: ToDoBoxListSection()
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Container(
      padding: EdgeInsets.only(left: size.getSize(18)),
      child: Row(
        children: [
          Text('홍길동님 환영합니다.',
              style: rTxtStyle.copyWith(fontSize: 16))
        ],
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Container(
      width: size.getSize(340.0),
      height: size.getSize(140.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.getSize(10)),
        border: Border.all(color: Colors.white, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            offset: Offset(0.5, 0.5), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Text('Calendar', style: rTxtStyle),
    );
  }
}

class ToDoBoxListSection extends StatefulWidget {
  @override
  _ToDoBoxListSectionState createState() => _ToDoBoxListSectionState();
}

class _ToDoBoxListSectionState extends State<ToDoBoxListSection> {
  ScreenSize size;
  int userId;
  List<ToDoBoxModel> toDoBoxList;



  // @override
  // void initState() {
  //   super.initState();
  //
  // }
  //
  // @override
  // void dispose() {
  //
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();
    userId = Provider.of<UserProvider>(context, listen: false).user.userId;
    return FutureBuilder(
        future: getToDoBoxList(userId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            handleException(context, snapshot.error);
          }
          if (snapshot.hasData) {
            toDoBoxList = snapshot.data;
            if (toDoBoxList.length == 0) {
              return Container();
            } else {
              return Padding(
                padding: EdgeInsets.only(left: size.getSize(20), right: size.getSize(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        createToDoBoxBtn(),
                      ],
                    ),
                    toDoBoxListView(),
                    Space(height: size.getSize(20))
                  ],
                ),
              );
            }
          } else {
            return Container(
                height: size.getSize(300),
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget createToDoBoxBtn() {
    return GestureDetector(
      onTap: () {
        createToDoBoxObj(userId);
        setState(() {
          ToDoBoxModel newToDoBox = new ToDoBoxModel();
          toDoBoxList.add(newToDoBox);
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: size.getSize(25.0),
        height: size.getSize(25.0),
        margin: EdgeInsets.only(bottom: size.getSize(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.getSize(6)),
          border: Border.all(color: Colors.white, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          size: size.getSize(20),
        ),
      ),
    );
  }

  Widget toDoBoxListView() {
    return Column(
        children: toDoBoxList.map((e) {
          int index = toDoBoxList.indexOf(e);
          return toDoBoxTile(
              index,
              toDoBoxList[index],
              toDoBoxList[index].toDoElmList);
        }).toList());
  }

  Widget toDoBoxTile(int toDoBoxIndex, ToDoBoxModel toDoBox, List<ToDoElmModel> toDoElmList){
    return Container();
  }
}

