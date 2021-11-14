import 'package:handey_app/src/business_logic/api/http_client.dart';
import 'package:handey_app/src/business_logic/memo/memo_model.dart';

HttpClient _httpClient = HttpClient();

/// 메모 불러오기
Future<MemoModel> getMemo(int userId) async {
  Map<String, dynamic> data = await _httpClient.getRequest('/user/$userId/memo', tokenYn: true);

  if (data != null && data['success']) {
    return MemoModel.fromJson(data['data']);
  } else {
    return null;
  }
}

/// 메모 수정하기
Future<bool> updateMemo(int userId, String content) async {
  Map<String, dynamic> data =
  await _httpClient.putRequest('/user/$userId/memo', {'content': content}, tokenYn: true);

  // 요청 성공여부 return
  return data['success'];
}