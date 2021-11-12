import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/todo/todo_model.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/utils/ToDoCheckBtn.dart';
import 'package:handey_app/src/view/utils/border.dart';
import 'package:handey_app/src/view/utils/calendar.dart';
import 'package:handey_app/src/view/utils/costumed_appbar.dart';
import 'package:handey_app/src/view/utils/exception_handler.dart';
import 'package:handey_app/src/business_logic/todo/todo_service.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:provider/provider.dart';


class HomeStateful extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: CostumedAppBar(),
          body: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Space(height: 12),
                  CalendarWidget(),
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

class ToDoBoxListSection extends StatefulWidget {
  @override
  _ToDoBoxListSectionState createState() => _ToDoBoxListSectionState();
}

class _ToDoBoxListSectionState extends State<ToDoBoxListSection> {
  ScreenSize size;
  int userId;
  List<ToDoBoxModel> toDoBoxList;
  Future<List<ToDoBoxModel>> futureToDoBoxList;

  _fetchData() {
    userId = Provider.of<UserProvider>(context, listen: false).user.userId;
    futureToDoBoxList = getToDoBoxList(userId);
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Called when the top route has been popped off, and the current route shows up.
  // @override
  // void didPopNext() {
  //   _fetchData();
  //   setState(() {});
  //   super.didPopNext();
  // }

  // @override
  // void dispose() {
  //
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();

    return FutureBuilder(
        future: futureToDoBoxList,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            handleException(context, snapshot.error);
          }
          if (snapshot.hasData) {
            toDoBoxList = snapshot.data;
            if (toDoBoxList.length == 0) {
              return Container();
            } else {
              return Container(
                margin: EdgeInsets.only(top: size.getSize(12)),
                padding: EdgeInsets.only(left: size.getSize(20), right: size.getSize(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    toDoBoxListView(),
                    createToDoBoxBtn(),
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
      onTap: () async {
        int newToDoBoxId = await createToDoBoxObj(userId);
        setState(() {
          ToDoBoxModel newToDoBox = new ToDoBoxModel();
          newToDoBox.id = newToDoBoxId;
          toDoBoxList.add(newToDoBox);
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: size.getSize(350.0),
        height: size.getSize(64.0),
        // margin: EdgeInsets.only(bottom: size.getSize(8)),
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
        child: Icon(
          Icons.add,
          size: size.getSize(20),
        ),
      ),
    );
  }

  Widget toDoBoxListView() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: size.getSize(0)),
        itemCount: toDoBoxList.length,
        itemBuilder: (context, index) {
          final toDoBox = toDoBoxList[index];
          return Dismissible(
            key: UniqueKey(),
            child: ToDoBoxTile(
                toDoBoxIndex: index,
                toDoBox: toDoBoxList[index],
                toDoElmList: toDoBoxList[index].toDoElmList),
            onDismissed: (direction) {
              // 해당 index의 item을 리스트에서 삭제
              setState(() {
                toDoBoxList.removeAt(index);
                deleteTodoBox(userId, toDoBox.id);
              });
            },
            direction: DismissDirection.endToStart,
            background: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFBD2A24),
                    borderRadius: BorderRadius.circular(size.getSize(10))),
                margin: EdgeInsets.only(bottom: size.getSize(8)),
                padding: EdgeInsets.only(right: size.getSize(20)),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete),
                ],
              )
            ),
          );
        }
    );
  }

}

class ToDoBoxTile extends StatefulWidget {
  ToDoBoxTile({@required this.toDoBoxIndex, @required this.toDoBox, @required this.toDoElmList});
  // ToDoBoxTile({@required this.toDoBoxIndex, @required this.toDoBox, @required this.toDoElmList, @required this.notifyToDoBoxListSection});

  final int toDoBoxIndex;
  final ToDoBoxModel toDoBox;
  final List<ToDoElmModel> toDoElmList;
  // final Function() notifyToDoBoxListSection;
  @override
  _ToDoBoxTileState createState() => _ToDoBoxTileState();
}

class _ToDoBoxTileState extends State<ToDoBoxTile> {
  ToDoService _toDoService = ToDoService();

  ScreenSize size;

  int toDoBoxIndex;
  ToDoBoxModel toDoBox;
  List<ToDoElmModel> toDoElmList;

  TextEditingController titleTEC;
  List<TextEditingController> toDoElmTEC = [];

  FocusNode titleFNode;
  //List<FocusNode> todoElmFNode = [];

  bool editingYn;
  int fieldCount = 0;
  int nextIndex = 0;

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
      //for (int i = 0; i < toDoBox.toDoElmList.length; i++) todoElmFNode.add(FocusNode());
    }
    editingYn = false;
    if(toDoElmList != null && toDoElmList.length != 0)
      fieldCount = toDoElmList.length;
    else
      fieldCount = 0;
  }

  @override
  void dispose() {
    titleTEC.dispose();
    titleFNode.dispose();
    if(toDoBox.toDoElmList != null && toDoBox.toDoElmList.length != 0) {
      for (int i = 0; i < toDoBox.toDoElmList.length; i++) toDoElmTEC[i].dispose();
      //for (int i = 0; i < toDoBox.toDoElmList.length; i++) todoElmFNode[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();

    return Container(
      width: size.getSize(350.0),
      // height: size.getSize(120.0),
      padding: EdgeInsets.fromLTRB(size.getSize(12), size.getSize(5),
          size.getSize(0), size.getSize(12)),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              toDoBoxTitleInput(),
              editingYn
              ? GestureDetector(
                onTap: () {
                  setState(() {
                    editingYn = false;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, size.getSize(12), size.getSize(12), size.getSize(19.5)),
                  child: Text(
                    '완료',
                    style: rTxtStyle.copyWith(fontSize: size.getSize(14), color: Colors.grey),
                  ),
                )
              )
              : toDoBoxEditBtn(toDoBox),
            ],
          ),
          toDoBox.toDoElmList != null && toDoBox.toDoElmList.length != 0
              ? toDoElmInputSection(toDoBox.toDoElmList)
              : Container()
        ],
      ),
    );
  }

  Widget toDoBoxTitleInput() {
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
                  // provider.updateToDoBoxTitle(provider.toDoBoxList[toDoBoxIndex].id, titleTEC.text);
                  toDoBox.title = titleTEC.text;
                  _toDoService.updateToDoBoxTitle(toDoBox.id, titleTEC.text);
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

  Widget toDoBoxEditBtn(ToDoBoxModel toDoBox) {
    return Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return PopupMenuButton(
            // 팝업메뉴버튼 참고 https://codesinsider.com/flutter-popup-menu-button/
            padding: EdgeInsets.fromLTRB(size.getSize(0), size.getSize(0), size.getSize(0), size.getSize(0)),
            offset: Offset(-10, -20),
            elevation: 4.0,
            icon: Icon(Icons.more_vert, size: size.getSize(20), color: Colors.grey,),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(size.getSize(10))),
            ),
            onSelected: (value) async {
              int toDoBoxId = toDoBox.id;
              switch(value) {
                case '추가':
                  int newToDoBoxId = await _toDoService.createToDoElmObj(toDoBoxId);
                  setState(() {
                    ToDoElmModel newToDoElm = new ToDoElmModel();
                    newToDoElm.id = newToDoBoxId;
                    newToDoElm.completed = false;
                    toDoElmList.add(newToDoElm);

                    toDoElmTEC.add(TextEditingController());
                    fieldCount++;
                    //todoElmFNode.add(FocusNode());
                  });
                  break;
                case '고정':
                  _toDoService.updateToDoBoxFixedYn(toDoBoxId);
                  setState(() {
                    toDoBox.fixed = !toDoBox.fixed;
                  });
                  break;
                default: // 편집
                  setState(() {
                    editingYn = true;
                  });
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                height: size.getSize(24),
                child: toDoMenuItem(Icon(Icons.add, size: size.getSize(16)), '추가'),
                value: '추가',
              ),
              PopupMenuItem(
                height: size.getSize(24),
                child: toDoMenuItem(Icon(Icons.push_pin, size: size.getSize(16)), '고정'),
                value: '고정',
              ),
              PopupMenuItem(
                height: size.getSize(24),
                child: toDoMenuItem(Icon(Icons.edit, size: size.getSize(16)), '편집'), /* todoelm 자리 이동, todoelm 삭제가능하게*/
                value: '편집',
              )
            ],
          );
        }
    );
  }

  Widget toDoMenuItem(Icon iconWidget, String text) {
    return Container(
      // width: size.getSize(100),
      child: Row(
          children: [
            iconWidget,
            Space(width: 10),
            Text(text, style: rTxtStyle.copyWith(fontSize: size.getSize(16)))
          ]
      ),
    );
  }

  Widget toDoElmInputSection(List<ToDoElmModel> toDoElmList) {
    return Column(
        children: toDoElmList.map((e) {
          int index = toDoElmList.indexOf(e);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        _toDoService.updateToDoElmCompleted(e.id);
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
                        if (!hasFocus) {
                          toDoElmList[index].content = toDoElmTEC[index].text;
                          _toDoService.updateToDoElmContent(e.id, toDoElmTEC[index].text);
                        }
                      },
                      child: TextFormField(
                        controller: toDoElmTEC[index],
                        //focusNode: todoElmFNode[index],
                        textAlign: TextAlign.left,
                        minLines: 1,
                        style: rTxtStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: underlineFocusedBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              editingYn
                  ? GestureDetector(
                    onTap: () async {
                      setState(() {
                        // await toDoElmTEC[index].dispose();
                        //todoElmFNode[index].dispose();

                        // when removing a TextField, you must do two things:
                        // 1. decrement the number of controllers you should have (fieldCount)
                        // 2. actually remove this field's controller from the list of controllers
                        fieldCount--;
                        toDoElmTEC.removeAt(index);
                        toDoElmList.removeAt(index);

                      });
                      _toDoService.deleteTodoElm(e.id);

                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: size.getSize(12)),
                      child: Icon(
                        Icons.delete,
                        size: size.getSize(20)),
                    ))
                  : Container()
            ],
          );
    }).toList());
  }
}
