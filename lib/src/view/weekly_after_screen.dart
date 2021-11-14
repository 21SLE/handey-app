import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handey_app/src/business_logic/memo/memo_model.dart';
import 'package:handey_app/src/business_logic/memo/memo_service.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/utils/costumed_appbar.dart';
import 'package:handey_app/src/view/utils/exception_handler.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:provider/provider.dart';

class WeeklyAfterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CostumedAppBar(),
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

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();

    return Column(
      children: [
        weeklySection(),
        Space(height: 16),
        afterSection()
      ],
    );
  }

  Widget weeklySection() {
    return Container(
      width: size.getSize(350.0),
      height: size.getSize(250.0),
      margin: EdgeInsets.symmetric(horizontal: size.getSize(8)),
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
      alignment: Alignment.center,
      child: Text('weekly'),
    );
  }

  Widget afterSection() {
    return Container(
      width: size.getSize(350.0),
      height: size.getSize(150.0),
      margin: EdgeInsets.symmetric(horizontal: size.getSize(8)),
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
      alignment: Alignment.center,
      child: Text('after'),
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
