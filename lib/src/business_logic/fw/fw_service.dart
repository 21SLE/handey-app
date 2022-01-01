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