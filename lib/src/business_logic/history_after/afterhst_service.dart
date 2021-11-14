import 'package:handey_app/src/business_logic/api/http_client.dart';
import 'package:handey_app/src/business_logic/history_after/afterhst_model.dart';

HttpClient _httpClient = HttpClient();

Future<List<AfterHistoryModel>> getAfterHistoryList(int userId, String searchDt) async {
  Map<String, dynamic> data = await _httpClient.getRequest('/user/$userId/history/after/date?dt=$searchDt', tokenYn: true);

  if (data['success']) {
    List<dynamic> afterHistoryListData = data['data'];
    List<AfterHistoryModel> afterHistoryList = afterHistoryListData.map((e) => AfterHistoryModel.fromJson(e)).toList();

    print(data['data']);
    return afterHistoryList;
  } else {
    return [];
  }
}