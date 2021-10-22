import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/todo/todo_model.dart';
import 'package:handey_app/src/business_logic/todo/todo_provider.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/utils/ToDoCheckBtn.dart';
import 'package:handey_app/src/view/utils/border.dart';
import 'package:handey_app/src/view/utils/exception_handler.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
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
              // ToDoBoxListSection()
              SingleChildScrollView(
                controller: scrollController,
                child: ToDoBoxListSection()
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

class ToDoBoxListSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    int userId = Provider.of<UserProvider>(context, listen: false).user.userId;
    return FutureBuilder(
        future: Provider.of<ToDoProvider>(context, listen: false)
            .getToDoBoxList(userId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            handleException(context, snapshot.error);
          }
          if (snapshot.hasData) {
            List<ToDoBoxModel> toDoBoxList = snapshot.data;
            if (toDoBoxList.length == 0) {
              return Container();
            } else {
              return Padding(
                padding: EdgeInsets.only(left: size.getSize(20), right: size.getSize(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ToDoBoxListView(toDoBoxList: toDoBoxList),
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
}

class ToDoBoxListView extends StatelessWidget {
  ToDoBoxListView({@required this.toDoBoxList});

  final List<ToDoBoxModel> toDoBoxList;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(top: size.getSize(0)),
      itemCount: toDoBoxList.length,
      itemBuilder: (context, index) {
        return ToDoBoxTile(
            toDoBoxIndex: index,
            toDoBox: toDoBoxList[index],
            toDoElmList: toDoBoxList[index].toDoElmList);},
      separatorBuilder: (context, index) {
        return Space(height: 8);},
    );
  }
}

class ToDoBoxTile extends StatefulWidget {
  ToDoBoxTile({@required this.toDoBoxIndex, @required this.toDoBox, @required this.toDoElmList});

  final int toDoBoxIndex;
  final ToDoBoxModel toDoBox;
  final List<ToDoElmModel> toDoElmList;
  @override
  _ToDoBoxTileState createState() => _ToDoBoxTileState();
}

class _ToDoBoxTileState extends State<ToDoBoxTile> {
  ScreenSize size;

  int toDoBoxIndex;
  ToDoBoxModel toDoBox;
  List<ToDoElmModel> toDoElmList;

  TextEditingController titleTEC;
  List<TextEditingController> toDoElmTEC = [];

  FocusNode titleFNode;
  List<FocusNode> todoElmFNode = [];

  @override
  void initState() {
    super.initState();
    toDoBoxIndex = widget.toDoBoxIndex;
    toDoBox = widget.toDoBox;
    toDoElmList = widget.toDoElmList;
    titleTEC = TextEditingController(text: toDoBox.title);
    titleFNode = FocusNode();
    if(toDoElmList != null && toDoElmList.length != 0) {
      for (int i = 0; i < toDoElmList.length; i++) toDoElmTEC.add(TextEditingController(text: toDoElmList[i].content));
      for (int i = 0; i < toDoBox.toDoElmList.length; i++) todoElmFNode.add(FocusNode());
    }
  }

  @override
  void dispose() {
    titleTEC.dispose();
    titleFNode.dispose();
    if(toDoBox.toDoElmList != null && toDoBox.toDoElmList.length != 0) {
      for (int i = 0; i < toDoBox.toDoElmList.length; i++) toDoElmTEC[i].dispose();
      for (int i = 0; i < toDoBox.toDoElmList.length; i++) todoElmFNode[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();

    return Container(
      width: size.getSize(350.0),
      // height: size.getSize(120.0),
      padding: EdgeInsets.all(size.getSize(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.getSize(10)),
        border: Border.all(color: Colors.white, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          toDoBoxTitleInput(),
          toDoBox.toDoElmList != null && toDoBox.toDoElmList.length != 0
              ? toDoElmInputSection(toDoBox.toDoElmList)
              : Container()
        ],
      ),
    );
  }

  Widget toDoBoxTitleInput() {
    return Consumer<ToDoProvider>(
        builder: (context, provider, child) {
          return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(height: size.getSize(22), width: size.getSize(8), color: Colors.yellow),
                Space(width: 12),
                Container(
                  height: size.getSize(26.0),
                  width: size.getSize(200),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      if(!hasFocus) {
                        provider.updateToDoBoxTitle(provider.toDoBoxList[toDoBoxIndex].id, titleTEC.text);
                      }
                    },
                    child: TextFormField(
                      controller: titleTEC,
                      focusNode: titleFNode,
                      textAlign: TextAlign.left,
                      minLines: 1,
                      style: rTxtStyle,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: underlineFocusedBorder(),
                      ),
                    ),
                  ),
                )
              ]
          );
        }
    );
  }

  Widget toDoElmInputSection(List<ToDoElmModel> toDoElmList) {
    return Consumer<ToDoProvider>(
      builder: (context, provider, child) {
        return Column(
            children: toDoElmList.map((e) {
              int index = toDoElmList.indexOf(e);
              return Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        provider.updateToDoElmCompleted(e.id);
                        setState(() {
                          e.completed = !e.completed;
                        });
                      },
                      child: ToDoCheckBtn(value: e.completed)),
                  Space(width: 10),
                  Container(
                    height: size.getSize(26.0),
                    width: size.getSize(200),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if(!hasFocus) {
                          provider.updateToDoElmContent(e.id, toDoElmTEC[index].text);
                        }
                      },
                      child: TextFormField(
                        controller: toDoElmTEC[index],
                        focusNode: todoElmFNode[index],
                        textAlign: TextAlign.left,
                        minLines: 1,
                        style: rTxtStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: underlineFocusedBorder(),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }).toList());
      }
    );
  }
}


