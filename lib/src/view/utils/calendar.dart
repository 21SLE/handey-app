import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/schecule_event/schecule_event.dart';
import 'package:handey_app/src/business_logic/schecule_event/schedule_event_service.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/utils/exception_handler.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../schedule_popup.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
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
    ScreenSize size = ScreenSize();
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
                height: size.getSize(180.0),
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
                                      color: Color.fromRGBO(254, 192, 1, 1),
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
                        headerVisible: false,
                        shouldFillViewport: true,
                        focusedDay: selectedDay,
                        firstDay: DateTime(1990),
                        lastDay: DateTime(2050),
                        calendarStyle: CalendarStyle(
                          isTodayHighlighted: true,
                          todayDecoration: BoxDecoration(
                              color: Color.fromRGBO(254, 192, 1, 1),
                              borderRadius: BorderRadius.circular(size.getSize(20))
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Color(0xFFFDDC42),
                              borderRadius: BorderRadius.circular(size.getSize(20))
                          ),
                        ),
                        selectedDayPredicate: (date) {
                          return isSameDay(selectedDay, date);
                        },
                        // rangeStartDay: DateTime.now().subtract(Duration(days:3)),
                        // rangeEndDay: DateTime.now().subtract(Duration(days:1)),
                        eventLoader: _getEventsFromDay,
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
                height: size.getSize(180.0),
                child: Center(child: CircularProgressIndicator()));
          }
        });
    
  }
}