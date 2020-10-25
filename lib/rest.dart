import 'package:http/http.dart' as http;

class RestService {
  String baseUrl = "http://feel-now.com/api-dev/";

  void login(String jwt) {}

  Future<String> signUp() async {
    String url = baseUrl + "users";

    var response = await http.post(url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return "hey";

  }
}
