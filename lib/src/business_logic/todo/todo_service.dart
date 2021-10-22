
import 'package:handey_app/src/business_logic/api/http_client.dart';
import 'package:handey_app/src/business_logic/todo/todo_model.dart';

class ToDoService {
  HttpClient _httpClient = HttpClient();

  /// 회원별 todobox list 불러오기
  Future<List<ToDoBoxModel>> getToDoBoxList(int userId) async {
    Map<String, dynamic> data = await _httpClient.getRequest('/user/$userId/toDoBoxList', tokenYn: true);
    print(data);
    if (data['success']) {
      List<dynamic> toDoBoxListData = data['data'];
      List<ToDoBoxModel> toDoBoxList = toDoBoxListData.map((e) => ToDoBoxModel.fromJson(e)).toList();

      return toDoBoxList;
    } else {
      return [];
    }
  }

  /// todobox 객체 생성
  Future<int> createToDoBoxObj(int userId) async {
    Map<String, dynamic> data =
        await _httpClient.postRequest('/user/$userId/toDoBox', {},tokenYn: true);

    //toDoBoxId return
    if(data['success']){
      return data['data'];
    } else {
      return null;
    }
  }

  /// todobox title 수정
  Future<bool> updateToDoBoxTitle(int toDoBoxId, String title) async {
    Map<String, dynamic> data =
        await _httpClient.putRequest('/user/toDoBox/$toDoBoxId', {'title': title},tokenYn: true);

    // 요청 성공여부 return
    return data['success'];
  }

  /// todobox 고정 여부 수정
  Future<bool> updateToDoBoxFixedYn(int toDoBoxId) async {
    Map<String, dynamic> data =
        await _httpClient.patchRequest('/user/toDoBox/$toDoBoxId', tokenYn: true);

    // todobox 고정 상태 return
    if(data['success']){
      return data['data'];
    } else {
      return null;
    }
  }

  /// todobox 타이틀 유무 여부 수정
  Future<bool> updateToDoBoxNoTitleYn(int toDoBoxId) async {
    Map<String, dynamic> data =
        await _httpClient.patchRequest('/user/toDoBox/$toDoBoxId/title', tokenYn: true);

    // todobox 타이틀 유무 상태 return
    if(data['success']){
      return data['data'];
    } else {
      return null;
    }
  }

  /// todobox 삭제
  Future<bool> deleteTodoBox(int userId, int toDoBoxId) async {
    Map<String, dynamic> data =
        await _httpClient.deleteRequest('/user/$userId/toDoBox/$toDoBoxId', tokenYn: true);

    // 요청 성공여부 return
    return data['success'];
  }

  /// todoelm 객체 생성
  Future<int> createToDoElmObj(int toDoBoxId) async {
    Map<String, dynamic> data =
    await _httpClient.postRequest('/user/toDoBox/$toDoBoxId', {},tokenYn: true);

    //toDoElmId return
    if(data['success']){
      return data['data'];
    } else {
      return null;
    }
  }

  /// todoelm 내용 수정
  Future<bool> updateToDoElmContent(int toDoElmId, String content) async {
    Map<String, dynamic> data =
    await _httpClient.putRequest('/user/toDoElm/$toDoElmId', {'content': content}, tokenYn: true);

    // 요청 성공여부 return
    return data['success'];
  }

  /// todoelm 삭제
  Future<bool> deleteTodoElm(int toDoElmId) async {
    Map<String, dynamic> data =
      await _httpClient.deleteRequest('/user/toDoElm/$toDoElmId', tokenYn: true);

    // 요청 성공여부 return
    return data['success'];
  }

  /// todoelm complete 여부 수정
  Future<bool> updateToDoElmCompleted(int toDoElmId) async {
    Map<String, dynamic> data =
    await _httpClient.patchRequest('/user/toDoElm/$toDoElmId', tokenYn: true);

    // todobox 타이틀 유무 상태 return
    if(data['success']){
      return data['data'];
    } else {
      return null;
    }
  }


}