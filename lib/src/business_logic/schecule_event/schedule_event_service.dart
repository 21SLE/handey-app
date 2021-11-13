import 'package:handey_app/src/business_logic/api/http_client.dart';
import 'package:handey_app/src/business_logic/schecule_event/schecule_event.dart';

HttpClient _httpClient = HttpClient();

/// 회원별 일정 list 불러오기
Future<List<ScheduleEventModel>> getScheduleEventList(int userId) async {
  Map<String, dynamic> data = await _httpClient.getRequest('/user/$userId/schedule', tokenYn: true);

  if (data['success']) {
    List<dynamic> scheduleListData = data['data'];
    List<ScheduleEventModel> scheduleList = scheduleListData.map((e) => ScheduleEventModel.fromJson(e)).toList();

    return scheduleList;
  } else {
    return [];
  }
}

/// 일정 생성
Future<int> createScheduleEvent(int userId, ScheduleEventModel schedule) async {
  Map<String, dynamic> data =
  await _httpClient.postRequest('/user/$userId/schedule', schedule.toJson(), tokenYn: true);

  //scheduleId return
  if(data['success']){
    return data['data'];
  } else {
    return null;
  }
}

/// 일정 삭제
Future<bool> deleteScheduleEvent(int userId, int scheduleId) async {
  Map<String, dynamic> data =
  await _httpClient.deleteRequest('/user/schedule/$scheduleId', tokenYn: true);

  // 요청 성공여부 return
  return data['success'];
}

/// 일정 수정
Future<bool> updateScheduleEvent(int scheduleId, ScheduleEventModel schedule) async {
  Map<String, dynamic> data =
  await _httpClient.putRequest('/user/schedule/$scheduleId', schedule.toJson(), tokenYn: true);

  // 요청 성공여부 return
  return data['success'];
}