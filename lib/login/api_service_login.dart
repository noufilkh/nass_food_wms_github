import 'package:food_wms/customcontrols/apphttprequest.dart';

class LoginApiService {
  static Future<dynamic> checklogin(
    String username,
    String password,
    String key,
  ) async {
    final url = Uri.parse('https://localhost:8095/api/auth/apiNF.php/validatenfu');
    final body = {
      'validateNF': [
        {'username': username, 'password': password, 'decrypt': key},
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

    return ApiService.post(url, body, headers, true);
  }

  static Future<dynamic> getuserdata(String username) async {
    final url = Uri.parse(
      'https://localhost:8095/api/auth/apiNF.php/getuserdetails/$username',
    );
    return ApiService.get(url);
  }
}
