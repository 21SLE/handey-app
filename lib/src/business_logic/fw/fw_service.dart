import 'package:handey_app/src/business_logic/api/http_client.dart';
import 'package:handey_app/src/business_logic/fw/fw_model.dart';

HttpClient _httpClient = HttpClient();

/// 회원별 weeklybox list 불러오기
Future<List<FwBoxModel>> getFwBoxList(int userId, String searchDt) async {
  Map<String, dynamic> data = await _httpClient.getRequest('/user/$userId/fw?dt=$searchDt', tokenYn: true);

  if (data['success']) {
    List<dynamic> fwBoxListData = data['data'];
    List<FwBoxModel> fwBoxList = fwBoxListData.map((e) => FwBoxModel.fromJson(e)).toList();

    return fwBoxList;
  } else {
    return [];
  }
}

/// weekly -> fw
Future<bool> addFwElm(int userId, int weeklyElmId) async {
  // /user/{userId}/fwelm/{weeklyElmId}
  Map<String, dynamic> data =
  await _httpClient.postRequest('/user/$userId/fwelm/$weeklyElmId', {},tokenYn: true);

  if(data['data']){
    return true;
  } else {
    return false;
  }
}

/// fw -> weekly
Future<bool> restoreFwElmToWeekly(int userId, int weeklyBoxId, int weeklyElmId) async {
  // /user/{userId}/fwbox/{weeklyBoxId}/fwelm/{weeklyElmId}
  Map<String, dynamic> data =
  await _httpClient.putRequest('/user/$userId/fwbox/$weeklyBoxId/fwelm/$weeklyElmId', {},tokenYn: true);

  if(data['data']){
    return true;
  } else {
    return false;
  }
}

/// fw 타이틀 수정
Future<bool> updateFwBoxTitle(int weeklyBoxId, String title) async {
  // /user/fwbox/{weeklyBoxId}
  Map<String, dynamic> data =
  await _httpClient.putRequest('/user/fwbox/$weeklyBoxId', {'title': title}, tokenYn: true);

  // 요청 성공여부 return
  return data['success'];
}

/// fw elm 내용 수정
Future<bool> updateFwElmContent(int weeklyBoxId, int weeklyElmId, String content) async {
  // /user/fwbox/{weeklyBoxId}/fwelm/{weeklyElmId}
  Map<String, dynamic> data =
  await _httpClient.putRequest('/user/fwbox/$weeklyBoxId/fwelm/$weeklyElmId', {'content': content}, tokenYn: true);

  // 요청 성공여부 return
  return data['success'];
}