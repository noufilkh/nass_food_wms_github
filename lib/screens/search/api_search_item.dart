import 'package:food_wms/customcontrols/apphttprequest.dart';
import 'package:food_wms/screens/search/search_list_item.dart';

class SearchItemApiService {
  static Future<List<SearchListItem>> searchitem(
    String itemcode,
    String locator,
  ) async {
    final url = Uri.parse('https://localhost:8095/api/auth/apiNF.php/ItemSearch');
    final body = {
      'ItemSearch': [
        {'Itemcode': itemcode, 'Locator': locator},
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final result = await ApiService.post(url, body, headers, true);

    if (result['status'] == null) {
      List<dynamic> searchItems = result["Item Details"];
      List<SearchListItem> searchitemlist =
          searchItems.map((data) => SearchListItem.fromJson(data)).toList();
      return searchitemlist;
    } else {
      throw Exception(result["msg"]);
    }
  }
}
