import 'package:handey_app/src/business_logic/api/http_client.dart';
import 'package:handey_app/src/business_logic/history/history_model.dart';

HttpClient _httpClient = HttpClient();

Future<HistoryBoxModel> getHistoryBox(int userId, String searchDt) async {
  Map<String, dynamic> data = await _httpClient.getRequest('/user/$userId/history/date?dt=$searchDt', tokenYn: true);

  if (data != null && data['success']) {
    return HistoryBoxModel.fromJson(data['data']);
  } else {
    return null;
  }
}