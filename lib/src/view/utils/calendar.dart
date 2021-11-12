import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:table_calendar/table_calendar.dart';

import '../schedule_popup.dart';

class CalendarWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Container(
        width: size.getSize(340.0),
        height: size.getSize(180.0),
        padding: EdgeInsets.fromLTRB(size.getSize(12), size.getSize(14), size.getSize(8), size.getSize(8)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.getSize(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // padding: EdgeInsets.only(top: size.getSize(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateTime.now().year.toString(),
                          style: TextStyle(
                              color: Color(0xFFFFE600),
                              fontSize: size.getSize(34),
                              fontWeight: FontWeight.bold),
                        ),
                        Space(height: 10),
                        Text(
                          DateTime.now().month.toString(),
                          style: TextStyle(
                              color: Color(0xFF747474),
                              fontSize: size.getSize(24),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: size.getSize(3), bottom: size.getSize(5)),
                        child: Icon(
                          Icons.add,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: size.getSize(220),
              child: TableCalendar(
                headerStyle: HeaderStyle(
                  headerMargin: EdgeInsets.all(0),
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(Icons.arrow_left),
                  rightChevronIcon: Icon(Icons.arrow_right),
                  titleTextStyle: const TextStyle(fontSize: 17.0),
                ),
                headerVisible: false,
                shouldFillViewport: true,
                focusedDay: DateTime.now(),
                firstDay: DateTime(1990),
                lastDay: DateTime(2050),
                onDaySelected: (selectedDay, focusedDay) {
                  showModalBottomSheet<dynamic>(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(size.getSize(24)), topRight: Radius.circular(size.getSize(24)))),
                      builder: (context) => Wrap(
                        children: [
                          ScheduleHistoryScreen(selectedDay: selectedDay),
                        ],
                      ));
                },
              ),
            ),
          ],
        )
    );
  }
}