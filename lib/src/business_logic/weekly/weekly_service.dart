import 'package:handey_app/src/business_logic/api/http_client.dart';
import 'package:handey_app/src/business_logic/weekly/weekly_model.dart';

HttpClient _httpClient = HttpClient();

/// 회원별 weeklybox list 불러오기
Future<List<WeeklyBoxModel>> getWeeklyBoxList(int userId) async {
  Map<String, dynamic> data = await _httpClient.getRequest('/user/$userId/weeklyBoxList', tokenYn: true);

  if (data['success']) {
    List<dynamic> weeklyBoxListData = data['data'];
    List<WeeklyBoxModel> weeklyBoxList = weeklyBoxListData.map((e) => WeeklyBoxModel.fromJson(e)).toList();

    return weeklyBoxList;
  } else {
    return [];
  }
}

/// weeklybox 객체 생성
Future<int> createWeeklyBoxObj(int userId) async {
  Map<String, dynamic> data =
  await _httpClient.postRequest('/user/$userId/weeklyBox', {},tokenYn: true);

  //weeklyBoxId return
  if(data['success']){
    return data['data'];
  } else {
    return null;
  }
}

/// weeklybox 삭제
Future<bool> deleteWeeklyBox(int userId, int weeklyBoxId) async {
  Map<String, dynamic> data =
  await _httpClient.deleteRequest('/user/weeklyBox/$weeklyBoxId', tokenYn: true);

  // 요청 성공여부 return
  return data['success'];
}

/// weeklybox title 수정
Future<bool> updateWeeklyBoxTitle(int weeklyBoxId, String title) async {
  Map<String, dynamic> data =
  await _httpClient.putRequest('/user/weeklyBox/$weeklyBoxId', {'title': title},tokenYn: true);

  // 요청 성공여부 return
  return data['success'];
}

/// weeklyelm 객체 생성
Future<int> createWeeklyElmObj(int weeklyBoxId) async {
  Map<String, dynamic> data =
  await _httpClient.postRequest('/user/weeklyBox/$weeklyBoxId', {},tokenYn: true);

  //toDoElmId return
  if(data['success']){
    return data['data'];
  } else {
    return null;
  }
}

/// todoelm 내용 수정
Future<bool> updateWeeklyElmContent(int weeklyElmId, String content) async {
  Map<String, dynamic> data =
  await _httpClient.putRequest('/user/weeklyElm/$weeklyElmId', {'content': content}, tokenYn: true);

  // 요청 성공여부 return
  return data['success'];
}

/// weeklyelm 삭제
Future<bool> deleteWeeklyElm(int weeklyElmId) async {
  Map<String, dynamic> data =
  await _httpClient.deleteRequest('/user/weeklyElm/$weeklyElmId', tokenYn: true);

  // 요청 성공여부 return
  return data['success'];
}

/// weeklyelm complete 여부 수정
Future<bool> updateWeeklyElmCompleted(int weeklyElmId) async {
  Map<String, dynamic> data =
  await _httpClient.patchRequest('/user/weeklyElm/$weeklyElmId', tokenYn: true);

  // todobox 타이틀 유무 상태 return
  if(data['success']){
    return data['data'];
  } else {
    return null;
  }
}