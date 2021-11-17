import 'package:handey_app/src/business_logic/api/http_client.dart';
import 'package:handey_app/src/business_logic/history_todo/todohst_model.dart';

HttpClient _httpClient = HttpClient();

Future<List<ToDoHistoryModel>> getToDoHistoryList(int userId, String searchDt) async {
  Map<String, dynamic> data = await _httpClient.getRequest('/user/$userId/history/todos/date?dt=$searchDt', tokenYn: true);

  if (data['success']) {
    List<dynamic> toDoBoxHistoryListData = data['data'];
    List<ToDoHistoryModel> toDoBoxHistoryList = toDoBoxHistoryListData.map((e) => ToDoHistoryModel.fromJson(e)).toList();

    print(data['data']);
    return toDoBoxHistoryList;
  } else {
    return [];
  }
}