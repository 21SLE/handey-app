import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/schecule_event/schecule_event.dart';
import 'package:handey_app/src/business_logic/schecule_event/schedule_event_service.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/utils/colors.dart';
import 'package:handey_app/src/view/utils/exception_handler.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../schedule_popup.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  ScreenSize size;
  Map<DateTime, List<ScheduleEventModel>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay;
  DateTime focusedDay;

  int userId;
  Future<List<ScheduleEventModel>> futureScheduleEventList;
  List<ScheduleEventModel> scheduleEventList;

  _fetchData() {
    userId = Provider.of<UserProvider>(context, listen: false).user.userId;
    futureScheduleEventList = getScheduleEventList(userId);
  }
  
  List<ScheduleEventModel> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void initState() {
    super.initState();
    selectedEvents = {};
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    _fetchData();
  }

  @override
  void dispose() {
    // _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();
    return FutureBuilder(
        future: futureScheduleEventList,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            handleException(context, snapshot.error);
          }
          if (snapshot.hasData) {
            scheduleEventList = snapshot.data;
            scheduleEventList.forEach((element) {
              // selectedEvents[element.]
            });
            return Container(
                width: size.getSize(340.0),
                height: size.getSize(190.0),
                padding: EdgeInsets.fromLTRB(size.getSize(12), size.getSize(14), size.getSize(8), size.getSize(8)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.getSize(10)),
                  color: Color.fromRGBO(242, 242, 242, 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // buildHandeyText(),
                          Padding(
                            padding: EdgeInsets.only(right: size.getSize(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Space(height: 4),
                                Text(
                                  DateFormat('yyyy').format(DateTime.now()),
                                  style: TextStyle(
                                      // color: Color(0xFF747474),
                                      color: cheeseYellow,
                                      fontSize: size.getSize(36),
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                // Space(height: 2),
                                // Text(
                                //   DateFormat(' MM.dd').format(DateTime.now()),
                                //   style: TextStyle(
                                //       color: Color(0xFF747474),
                                //       // color: regularYellow,
                                //       fontSize: size.getSize(24),
                                //       // fontWeight: FontWeight.bold
                                //   ),
                                // ),
                                Space(height: 4),
                                Text(
                                  DateFormat('MM').format(DateTime.now()),
                                  style: TextStyle(
                                      color: Color(0xFF747474),
                                      fontSize: size.getSize(32),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.getSize(220),
                      child: TableCalendar(
                        headerVisible: true,
                        daysOfWeekVisible: false,
                        shouldFillViewport: true,
                        focusedDay: selectedDay,
                        firstDay: DateTime(1990),
                        lastDay: DateTime(2050),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: rTxtStyle.copyWith(fontSize: size.getSize(14)),
                          headerPadding: EdgeInsets.all(0),
                          leftChevronPadding: EdgeInsets.all(0),
                          rightChevronPadding: EdgeInsets.all(0),
                        ),
                        calendarStyle: CalendarStyle(
                          isTodayHighlighted: true,

                          todayDecoration: BoxDecoration(
                            // shape: BoxShape.circle,
                              color: cheeseYellow,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          selectedDecoration: BoxDecoration(
                              color: regularYellow,
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        selectedDayPredicate: (date) {
                          return isSameDay(selectedDay, date);
                        },
                        eventLoader: _getEventsFromDay,
                        onPageChanged: (day) {
                          // setState(() {
                          //   calendarYear = day.year.toString();
                          //   calendarMonth = day.month.toString();
                          // });
                          focusedDay = day;
                        },
                        onDaySelected: (selectDay, focusDay) {
                          setState(() {
                            selectedDay = selectDay;
                            focusedDay = focusDay;
                          });
                          showModalBottomSheet<dynamic>(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(size.getSize(24)), topRight: Radius.circular(size.getSize(24)))),
                              builder: (context) => Wrap(
                                children: [
                                  HistoryScreen(selectedDay: selectedDay),
                                ],
                              ));
                        },
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            if (events.isNotEmpty) {
                              // children.add(
                              //   Positioned(
                              //     right: 1,
                              //     top: 1,
                              //     child: _buildEventsMarker(date, events),
                              //   ),
                              // );
                            }
                            return Container();
                          }
                        ),
                      ),
                    ),
                  ],
                )
            );
          } else {
            return Container(
                height: size.getSize(190.0),
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Text buildHandeyText() {
    return Text(
      'HANDEY',
      style: rTxtStyle.copyWith(fontSize: size.getSize(22), fontWeight: FontWeight.w700, color: cheeseYellow),
    );
  }
}