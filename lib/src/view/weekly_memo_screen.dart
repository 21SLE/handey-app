import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handey_app/src/business_logic/fw/fw_model.dart';
import 'package:handey_app/src/business_logic/fw/fw_service.dart';
import 'package:handey_app/src/business_logic/memo/memo_model.dart';
import 'package:handey_app/src/business_logic/memo/memo_service.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/business_logic/weekly/weekly_model.dart';
import 'package:handey_app/src/business_logic/weekly/weekly_service.dart';
import 'package:handey_app/src/view/utils/ToDoCheckBtn.dart';
import 'package:handey_app/src/view/utils/border.dart';
import 'package:handey_app/src/view/utils/exception_handler.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeeklyMemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Space(height: 16),
                  WeeklyAfterSection(),
                  Space(height: 16),
                  MemoSection(),
                  Space(height: 16),
                ],
              ),
            )
        ),
      ),
    );
  }
}

class WeeklyAfterSection extends StatefulWidget {
  @override
  _WeeklyAfterSectionState createState() => _WeeklyAfterSectionState();
}

class _WeeklyAfterSectionState extends State<WeeklyAfterSection> {
  ScreenSize size;
  int userId;
  List<WeeklyBoxModel> weeklyBoxList;
  List<FwBoxModel> fwBoxList;
  Future<List<WeeklyBoxModel>> futureWeeklyBoxList;
  Future<List<FwBoxModel>> futureFwBoxList;


  int fieldCount = 0;

  _fetchData() {
    userId = Provider.of<UserProvider>(context, listen: false).user.userId;
    futureWeeklyBoxList = getWeeklyBoxList(userId);
    futureFwBoxList = getFwBoxList(userId, DateFormat("yyyy-MM-dd").format(DateTime.now()));
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();
    return Container(
      width: size.getSize(350.0),
      // height: size.getSize(420.0),
      padding: EdgeInsets.all(size.getSize(8)),
      margin: EdgeInsets.symmetric(horizontal: size.getSize(8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.getSize(8)),
        border: Border.all(color: Colors.white, width: 3.0),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF979797),
            offset: Offset(3.0, 3.0), //(x,y)
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Column(
        children: [
          weeklySection(),
          Space(height: 16),
          fwSection()
        ],
      ),
    );
  }

  Widget weeklySection() {
    return FutureBuilder(
        future: futureWeeklyBoxList,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            handleException(context, snapshot.error);
          }
          if (snapshot.hasData) {
            weeklyBoxList = snapshot.data;

            return Container(
                height: size.getSize(250.0),
                child: Column(
                  children: [
                    sectionTitle(true),
                    Divider(thickness: 2),
                    Expanded(
                      child: SingleChildScrollView(
                          child: weeklyBoxListSection()
                      ),
                    )
                  ],
                )
            );
          } else {
            return Container(
                height: size.getSize(300),
                child: Center(child: CircularProgressIndicator()));
          }
        });

  }

  Widget fwSection() {
    return FutureBuilder(
        future: futureFwBoxList,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            handleException(context, snapshot.error);
          }
          if (snapshot.hasData) {
            fwBoxList = snapshot.data;

            return Container(
                height: size.getSize(130.0),
                child: Column(
                  children: [
                    sectionTitle(false),
                    Divider(thickness: 2),
                    Expanded(
                      child: SingleChildScrollView(
                          child: fwBoxListSection()
                      ),
                    )

                  ],
                )
            );
          } else {
            return Container(
                height: size.getSize(300),
                child: Center(child: CircularProgressIndicator()));
          }
        });

  }

  Widget sectionTitle(bool weeklySectionTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(weeklySectionTitle ? 'Weekly' : 'Finished Today', style: rTxtStyle.copyWith(fontSize: size.getSize(20), fontWeight: FontWeight.bold)),
        weeklySectionTitle ? createWeeklyBoxBtn() : Container(),
      ],
    );
  }

  Widget createWeeklyBoxBtn() {
    return GestureDetector(
      onTap: () async {
        int newWeeklyBoxId = await createWeeklyBoxObj(userId);
        setState(() {
          WeeklyBoxModel newWeeklyBox = new WeeklyBoxModel();
          newWeeklyBox.id = newWeeklyBoxId;
          newWeeklyBox.weeklyElmList = new List<WeeklyElmModel>.empty(growable: true);
          weeklyBoxList.add(newWeeklyBox);

          fieldCount++;
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: size.getSize(24.0),
        height: size.getSize(24.0),
        child: Icon(
          Icons.add,
          size: size.getSize(20),
        ),
      ),
    );
  }

  Widget weeklyBoxListSection() {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: size.getSize(0)),
        itemCount: weeklyBoxList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            child: WeeklyBoxTile(
                weeklyBox: weeklyBoxList[index],
                weeklyElmList: weeklyBoxList[index].weeklyElmList,
                onCompleteWeeklyElm: onCompleteWeeklyElm),
              onDismissed: (direction) {
                // 해당 index의 item을 리스트에서 삭제
                deleteWeeklyBox(userId, weeklyBoxList[index].id);
                setState(() {
                  weeklyBoxList.removeAt(index);
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
        },
        separatorBuilder: (context, index) {
          return Divider(thickness: 1.0);
        }
    );
  }

  Widget fwBoxListSection() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: size.getSize(0)),
        itemCount: fwBoxList.length,
        itemBuilder: (context, index) {
          return FwBoxTile(
              fwBox: fwBoxList[index],
              fwElmList: fwBoxList[index].fwElmList);
        }
    );
  }


  onCompleteWeeklyElm(WeeklyBoxModel weeklyBox, WeeklyElmModel weeklyElm) {
    if(weeklyElm.completed) {
      restoreFwElmToWeekly(userId, weeklyBox.id, weeklyElm.id);
    } else {
      addFwElm(userId, weeklyElm.id);
    }
  }
}

class WeeklyBoxTile extends StatefulWidget {
  WeeklyBoxTile({@required this.weeklyBox, @required this.weeklyElmList, @required this.onCompleteWeeklyElm});

  final WeeklyBoxModel weeklyBox;
  final List<WeeklyElmModel> weeklyElmList;
  final Function(WeeklyBoxModel, WeeklyElmModel) onCompleteWeeklyElm;

  @override
  _WeeklyBoxTileState createState() => _WeeklyBoxTileState();
}

class _WeeklyBoxTileState extends State<WeeklyBoxTile> {
  ScreenSize size;
  int userId;

  int weeklyBoxIndex;
  WeeklyBoxModel weeklyBox;
  List<WeeklyElmModel> weeklyElmList;

  TextEditingController titleTEC;
  List<TextEditingController> weeklyElmTEC = [];

  bool editingYn;
  int fieldCount = 0;


  @override
  void initState() {
    super.initState();
    weeklyBox = widget.weeklyBox;
    weeklyElmList = widget.weeklyElmList;
    titleTEC = TextEditingController(text: weeklyBox.title);
    if(weeklyElmList != null && weeklyElmList.length != 0) {
      for (int i = 0; i < weeklyElmList.length; i++)
        weeklyElmTEC.add(TextEditingController(text: weeklyElmList[i].content));
    }
    editingYn = false;
    if(weeklyElmList != null && weeklyElmList.length != 0)
      fieldCount = weeklyElmList.length;
    else
      fieldCount = 0;
  }

  @override
  void dispose() {
    titleTEC.dispose();
    if(weeklyBox.weeklyElmList != null && weeklyBox.weeklyElmList.length != 0) {
      for (int i = 0; i < weeklyBox.weeklyElmList.length; i++) weeklyElmTEC[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();

    return Container(
      width: size.getSize(350.0),
      // height: size.getSize(120.0),
      padding: EdgeInsets.fromLTRB(size.getSize(5), size.getSize(00),
          size.getSize(0), size.getSize(0)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              weeklyBoxTitleInput(),
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
                  : weeklyBoxEditBtn(),
            ],
          ),
          weeklyBox.weeklyElmList != null && weeklyBox.weeklyElmList.length != 0
              ? weeklyElmInputSection()
              : Container()
        ],
      ),
    );
  }

  Widget weeklyBoxTitleInput() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: size.getSize(21), width: size.getSize(6), color: Color.fromRGBO(254, 192, 1, 1)),
          Space(width: 10),
          Container(
            height: size.getSize(26.0),
            width: size.getSize(200),
            child: Focus(
              onFocusChange: (hasFocus) {
                if(!hasFocus) {
                  weeklyBox.title = titleTEC.text;
                  updateWeeklyBoxTitle(weeklyBox.id, titleTEC.text);
                  updateFwBoxTitle(weeklyBox.id, titleTEC.text);
                }
              },
              child: TextFormField(
                controller: titleTEC,
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

  Widget weeklyBoxEditBtn() {
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
              int weeklyBoxId = weeklyBox.id;
              switch(value) {
                case '추가':
                  int newWeeklyBoxId = await createWeeklyElmObj(weeklyBoxId);
                  setState(() {
                    WeeklyElmModel newWeeklyElm = new WeeklyElmModel();
                    newWeeklyElm.id = newWeeklyBoxId;
                    newWeeklyElm.completed = false;
                    weeklyElmList.add(newWeeklyElm);

                    weeklyElmTEC.add(TextEditingController());
                    fieldCount++;
                    //weeklyElmFNode.add(FocusNode());
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
                child: weeklyMenuItem(Icon(Icons.add, size: size.getSize(16)), '추가'),
                value: '추가',
              ),
              PopupMenuItem(
                height: size.getSize(24),
                child: weeklyMenuItem(Icon(Icons.edit, size: size.getSize(16)), '편집'), /* weeklyelm 자리 이동, weeklyelm 삭제가능하게*/
                value: '편집',
              )
            ],
          );
        }
    );
  }

  Widget weeklyMenuItem(Icon iconWidget, String text) {
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

  Widget weeklyElmInputSection() {
    return Column(
        children: weeklyElmList.map((e) {
          int index = weeklyElmList.indexOf(e);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        updateWeeklyElmCompleted(e.id);
                        widget.onCompleteWeeklyElm(weeklyBox, e);

                        setState(() {
                          e.completed = !e.completed;
                        });
                      },
                      child: ToDoCheckBtn(value: e.completed)),
                  Space(width: 8),
                  Container(
                    height: size.getSize(26.0),
                    width: size.getSize(200),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          weeklyElmList[index].content = weeklyElmTEC[index].text;
                          updateWeeklyElmContent(e.id, weeklyElmTEC[index].text);
                          updateFwElmContent(weeklyBox.id, e.id, weeklyElmTEC[index].text);
                        }
                      },
                      child: TextFormField(
                        controller: weeklyElmTEC[index],
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
                      fieldCount--;
                      weeklyElmTEC.removeAt(index);
                      weeklyElmList.removeAt(index);
                    });
                    deleteWeeklyElm(e.id);
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

class FwBoxTile extends StatefulWidget {
  FwBoxTile({@required this.fwBox, @required this.fwElmList});

  final FwBoxModel fwBox;
  final List<FwElmModel> fwElmList;

  @override
  _FwBoxTileState createState() => _FwBoxTileState();
}

class _FwBoxTileState extends State<FwBoxTile> {
  ScreenSize size;
  int useId;

  FwBoxModel fwBox;
  List<FwElmModel> fwElmList;

  @override
  void initState() {
    super.initState();
    fwBox = widget.fwBox;
    fwElmList = widget.fwElmList;
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();
    return Container(
      width: size.getSize(350.0),
      // height: size.getSize(120.0),
      padding: EdgeInsets.fromLTRB(size.getSize(5), size.getSize(0),
          size.getSize(0), size.getSize(5)),
      child: Column(
        children: [
          fwBoxTitle(),
          fwElmList != null && fwElmList.length != 0
              ? fwElmListSection()
              : Container()
        ],
      ),
    );
  }

  Widget fwBoxTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(fwBox.title ?? '',
            style: rTxtStyle.copyWith(
                color: Color(0xFFF6CE05), fontSize: size.getSize(18)))
      ],
    );
  }

  Widget fwElmListSection() {
    return Column(
      children: fwElmList.map((e) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: size.getSize(2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_right_rounded, color: Colors.grey, size: size.getSize(16)),
                  // Space(width: 2),
                  Text(e.content ?? '', style: rTxtStyle.copyWith(color: Colors.grey,fontSize: size.getSize(16)),)
                ],
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}


class MemoSection extends StatefulWidget {
  @override
  _MemoSectionState createState() => _MemoSectionState();
}

class _MemoSectionState extends State<MemoSection> {
  ScreenSize size;
  int userId;
  MemoModel memo;
  Future<MemoModel> futureMemo;

  TextEditingController memoTEC;
  ScrollController _scrollController = ScrollController();

  _fetchData() {
    userId = Provider.of<UserProvider>(context, listen: false).user.userId;
    futureMemo = getMemo(userId);
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    memoTEC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();

    return FutureBuilder(
        future: futureMemo,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            handleException(context, snapshot.error);
          }
          if (snapshot.hasData) {
            memo = snapshot.data;
            memoTEC.text = memo.content;
            return Container(
                alignment: Alignment.topLeft,
                width: size.getSize(350),
                height: size.getSize(120),
                margin: EdgeInsets.symmetric(horizontal: size.getSize(8)),
                padding: EdgeInsets.fromLTRB(size.getSize(12), size.getSize(5), size.getSize(0), size.getSize(12)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.getSize(8)),
                  border: Border.all(color: Colors.white, width: 3.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF979797),
                      offset: Offset(3.0, 3.0), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: memoTextFormField()
                )
            );
          } else {
            return Container(
                height: size.getSize(300),
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget memoTextFormField() {
    return Focus(
      onFocusChange: (hasFocus) {
        if(!hasFocus) {
          setState(() {
            memo.content = memoTEC.text;
          });
          userId = Provider.of<UserProvider>(context, listen: false).user.userId;
          updateMemo(userId, memo.content);
        }
      },
      child: TextFormField(
        controller: memoTEC,
        textAlign: TextAlign.left,
        minLines: 1,
        maxLines: null,
        maxLength: 255,
        style: rTxtStyle,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.getSize(10.0),
            vertical: size.getSize(15.0),
          ),
          counterText: "",
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        )
      ),
    );
  }
}
